import 'dart:async';
import 'dart:io' show Platform;

import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/prefs/preferences_store.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/download_repository.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/queue_repository.dart';
import '../../../services/audio/podcast_audio_handler.dart';
import 'player_state.dart';

part 'player_view_model.g.dart';

const _tickInterval = Duration(seconds: 1);
const _ticksPerSave = 5; // salva progresso a cada ~5s, não a cada tick

enum EqualizerPreset { flat, voz, grave, agudo }

/// Ganhos (dB) por banda pra um preset, interpolando uma curva de 5 pontos
/// pro nº de bandas do device e limitando a `[minDb, maxDb]`. Função pura —
/// testável sem o handler.
List<double> equalizerPresetGains(EqualizerPreset preset, int bandCount, double minDb, double maxDb) {
  if (bandCount <= 0) return const [];

  // Curva de referência (graves → agudos), em "força" -1..1.
  const shapes = <EqualizerPreset, List<double>>{
    EqualizerPreset.flat: [0, 0, 0, 0, 0],
    EqualizerPreset.voz: [-0.4, 0.2, 0.7, 0.4, -0.3],
    EqualizerPreset.grave: [1.0, 0.6, 0.1, -0.2, -0.4],
    EqualizerPreset.agudo: [-0.4, -0.2, 0.1, 0.6, 1.0],
  };
  final shape = shapes[preset]!;
  // Escala positiva usa maxDb; negativa usa |minDb|.
  final up = maxDb <= 0 ? 12.0 : maxDb;
  final down = minDb >= 0 ? 12.0 : -minDb;

  double sample(double t) {
    final x = (t * (shape.length - 1)).clamp(0.0, (shape.length - 1).toDouble());
    final i = x.floor();
    final f = x - i;
    final a = shape[i];
    final b = shape[i + 1 >= shape.length ? shape.length - 1 : i + 1];
    return a + (b - a) * f;
  }

  return [
    for (var i = 0; i < bandCount; i++)
      () {
        final strength = sample(bandCount == 1 ? 0.5 : i / (bandCount - 1));
        final db = strength >= 0 ? strength * up : strength * down;
        return db.clamp(minDb, maxDb).toDouble();
      }(),
  ];
}

/// ViewModel do player — o único que fala com o [PodcastAudioHandler].
/// `keepAlive`: o áudio toca em background e o mini-player aparece em
/// qualquer tela, então esse estado precisa sobreviver a trocas de tela.
@Riverpod(keepAlive: true)
class PlayerViewModel extends _$PlayerViewModel {
  StreamSubscription<audio_service.MediaItem?>? _mediaItemSub;
  StreamSubscription<audio_service.PlaybackState>? _playbackStateSub;
  Timer? _ticker;
  Timer? _sleepTimer;
  DateTime? _sleepTimerEndsAt;
  int _tickCount = 0;

  /// Última fila persistida vista — usada pra resolver o podcast/episódio do
  /// item que passou a tocar (o handler só devolve `MediaItem`).
  List<QueueEntry> _entries = const [];

  PodcastAudioHandler get _handler => ref.read(audioHandlerProvider);
  PreferencesStore get _prefs => ref.read(preferencesStoreProvider);

  @override
  PlayerState build() {
    final handler = _handler;

    _mediaItemSub = handler.mediaItem.listen(_onMediaItemChanged);
    _playbackStateSub = handler.playbackState.listen(_onPlaybackStateChanged);
    _ticker = Timer.periodic(_tickInterval, (_) => _onTick());

    // Fila persistida (Fase 12) é a fonte de verdade da ordem — o handler é
    // só o espelho dela. Quando ela muda (enfileirar / reordenar / consumir),
    // re-sincroniza o handler.
    handler.onItemConsumed = _onItemConsumed;
    ref.listen(queueProvider, (_, next) {
      final entries = next.value;
      if (entries != null) unawaited(_syncQueue(entries));
    }, fireImmediately: true);

    ref.onDispose(() {
      _mediaItemSub?.cancel();
      _playbackStateSub?.cancel();
      _ticker?.cancel();
      _sleepTimer?.cancel();
      handler.onItemConsumed = null;
    });

    // Restaura volume/velocidade salvos (Fase pós-8). O equalizador é
    // restaurado em `_loadEqualizer`, quando as bandas do device são
    // conhecidas.
    final volume = _prefs.volume;
    final speed = _prefs.playbackSpeed;
    unawaited(_handler.setVolume(volume));
    unawaited(_handler.setSpeed(speed));
    return PlayerState(volume: volume, speed: speed);
  }

  /// Toca [episode] agora: a fila passa a ser **só ele** (Fase 12, decisão
  /// b — tocar um episódio não substitui a fila pela lista inteira do
  /// podcast; pra isso o usuário enfileira explicitamente). Retoma de onde
  /// parou se houver progresso salvo (Fase 3).
  ///
  /// [autoPlay] `false` (padrão): só prepara o áudio e mostra o mini-player
  /// pausado — selecionar um episódio não toca sozinho (Fase 8.3). A tela de
  /// episódio e o botão de play na lista passam `true`.
  Future<void> playEpisode(Podcast podcast, Episode episode, {bool autoPlay = false}) async {
    // Atualiza o estado já síncrono, antes de qualquer await — quem chamou
    // playEpisode costuma navegar pro player logo em seguida (sem esperar
    // essa Future), e a tela precisa ver podcast/episode desde o 1º frame.
    _entries = [(podcast: podcast, episode: episode)];
    state = state.copyWith(
      podcast: podcast,
      episode: episode,
      queue: [episode],
      duration: episode.duration,
    );

    final savedPosition =
        await ref.read(libraryRepositoryProvider).playbackPositionFor(podcast.id, episode.guid);
    if (!ref.mounted) return;
    // Põe o episódio na frente da fila persistida, preservando o que já
    // estava enfileirado (o stream `queueProvider` reemite; `_syncQueue`
    // completa o `_entries` com a fila inteira).
    await ref.read(queueRepositoryProvider).playNow(podcast, episode);
    if (!ref.mounted) return;

    // Toca do arquivo baixado sempre que existir — modo avião (Fase 5).
    final localPaths =
        await ref.read(downloadRepositoryProvider).completedPathsForPodcast(podcast.id);
    if (!ref.mounted) return;
    await _handler.setQueue(
      [_toMediaItem(podcast, episode, localPath: localPaths[episode.guid])],
      playFirst: true,
      initialPosition: savedPosition,
      autoPlay: autoPlay,
    );

    // O equalizador do device só fica disponível depois que um áudio foi
    // carregado. Android apenas.
    unawaited(_loadEqualizer());
    unawaited(_applyPodcastSpeed(podcast.id));
  }

  /// Velocidade fixa por podcast (Fase 13) — `null` volta pra global salva.
  Future<void> _applyPodcastSpeed(int podcastId) async {
    final settings = await ref.read(libraryRepositoryProvider).watchSubscriptionSettings(podcastId).first;
    if (!ref.mounted) return;
    final target = settings.playbackSpeedOverride ?? _prefs.playbackSpeed;
    if (target == state.speed) return;
    unawaited(_handler.setSpeed(target));
    state = state.copyWith(speed: target);
  }

  /// "Adicionar à fila" — vai pro fim.
  Future<void> enqueue(Podcast podcast, Episode episode) =>
      ref.read(queueRepositoryProvider).addToEnd(podcast, episode);

  /// "Tocar a seguir" — logo após o episódio atual.
  Future<void> playNext(Podcast podcast, Episode episode) => ref
      .read(queueRepositoryProvider)
      .playNextAfter(podcast, episode, state.episode?.guid);

  /// Enfileira vários de uma vez, na ordem dada (usado pelo "enfileirar os
  /// próximos" da tela de episódio).
  Future<void> enqueueAll(Podcast podcast, List<Episode> episodes) async {
    final repo = ref.read(queueRepositoryProvider);
    for (final e in episodes) {
      await repo.addToEnd(podcast, e);
    }
  }

  /// Remove um item de "a seguir" pela posição na fila (índice 0 é o atual).
  Future<void> removeFromQueueAt(int index) =>
      ref.read(queueRepositoryProvider).removeAt(index);

  Future<void> reorderQueue(int oldIndex, int newIndex) =>
      ref.read(queueRepositoryProvider).move(oldIndex, newIndex);

  Future<void> clearQueue() => ref.read(queueRepositoryProvider).clear();

  /// Sincroniza a fila do handler com a persistida, sem recarregar o áudio
  /// que já toca (a menos que o item atual tenha saído da fila).
  Future<void> _syncQueue(List<QueueEntry> entries) async {
    _entries = entries;
    state = state.copyWith(queue: [for (final e in entries) e.episode]);

    if (entries.isEmpty) {
      await _handler.setQueue(const []);
      return;
    }

    final currentId = _handler.mediaItem.value?.id;
    final handlerIds = [for (final i in _handler.queue.value) i.id];

    final items = <audio_service.MediaItem>[];
    for (final e in entries) {
      final paths =
          await ref.read(downloadRepositoryProvider).completedPathsForPodcast(e.podcast.id);
      if (!ref.mounted) return;
      items.add(_toMediaItem(e.podcast, e.episode, localPath: paths[e.episode.guid]));
    }
    final newIds = [for (final i in items) i.id];

    if (currentId != null && !newIds.contains(currentId)) {
      // O item que tocava saiu da fila (reordenação/remoção esquisita) —
      // recarrega o novo topo, preservando play/pause.
      await _handler.setQueue(items, playFirst: true, autoPlay: state.isPlaying);
    } else if (!_sameIds(handlerIds, newIds)) {
      await _handler.setQueue(items);
    }
  }

  bool _sameIds(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _onItemConsumed(audio_service.MediaItem consumed) {
    final guid = consumed.extras?['guid'] as String?;
    final podcastId = consumed.extras?['podcastId'] as int?;
    if (guid == null || podcastId == null) return;
    unawaited(ref.read(queueRepositoryProvider).removeEpisode(podcastId, guid));
  }

  void togglePlayPause() {
    if (state.isPlaying) {
      _handler.pause();
    } else {
      _handler.play();
    }
  }

  void seek(Duration position) => _handler.seek(position);

  void skipForward([Duration amount = const Duration(seconds: 30)]) => _handler.skipForward(amount);

  void skipBackward([Duration amount = const Duration(seconds: 15)]) => _handler.skipBackward(amount);

  void setSpeed(double speed) {
    _handler.setSpeed(speed);
    state = state.copyWith(speed: speed);
    unawaited(_prefs.setPlaybackSpeed(speed));
  }

  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    unawaited(_prefs.setVolume(volume));
    await _handler.setVolume(volume);
  }

  Future<void> toggleEqualizer(bool enabled) async {
    state = state.copyWith(equalizerEnabled: enabled);
    unawaited(_prefs.setEqualizerEnabled(enabled));
    await _handler.setEqualizerEnabled(enabled);
    if (enabled && state.equalizerBands.isEmpty) await _loadEqualizer();
  }

  Future<void> setEqualizerBand(int index, double gain) async {
    final bands = [
      for (final b in state.equalizerBands)
        if (b.index == index) (index: b.index, centerHz: b.centerHz, gain: gain) else b,
    ];
    state = state.copyWith(equalizerBands: bands);
    unawaited(_prefs.setEqualizerGains([for (final b in bands) b.gain]));
    await _handler.setEqualizerBandGain(index, gain);
  }

  Future<void> applyEqualizerPreset(EqualizerPreset preset) async {
    final current = state.equalizerBands;
    if (current.isEmpty) return;

    final gains = equalizerPresetGains(
      preset,
      current.length,
      state.equalizerMinDb,
      state.equalizerMaxDb,
    );
    state = state.copyWith(
      equalizerBands: [
        for (var i = 0; i < current.length; i++)
          (index: current[i].index, centerHz: current[i].centerHz, gain: gains[i]),
      ],
    );
    unawaited(_prefs.setEqualizerGains(gains));
    for (var i = 0; i < current.length; i++) {
      await _handler.setEqualizerBandGain(current[i].index, gains[i]);
    }
  }

  Future<void> _loadEqualizer() async {
    if (!Platform.isAndroid || state.equalizerBands.isNotEmpty) return;
    try {
      final snapshot = await _handler.equalizerSnapshot().timeout(const Duration(seconds: 3));
      final savedGains = _prefs.equalizerGains;
      final savedEnabled = _prefs.equalizerEnabled;

      // Se há ganhos salvos, aplica-os por índice (com clamp à faixa do
      // device); senão usa o que o device reportou.
      final bands = [
        for (final b in snapshot.bands)
          (
            index: b.index,
            centerHz: b.centerHz,
            gain: b.index < savedGains.length
                ? savedGains[b.index].clamp(snapshot.minDb, snapshot.maxDb).toDouble()
                : b.gain,
          ),
      ];

      state = state.copyWith(
        equalizerAvailable: true,
        equalizerEnabled: savedEnabled,
        equalizerMinDb: snapshot.minDb,
        equalizerMaxDb: snapshot.maxDb,
        equalizerBands: bands,
      );

      if (savedGains.isNotEmpty) {
        for (final b in bands) {
          await _handler.setEqualizerBandGain(b.index, b.gain);
        }
      }
      if (savedEnabled) await _handler.setEqualizerEnabled(true);
    } catch (_) {
      // Device sem equalizador, ou não respondeu — a UI some sozinha.
    }
  }

  /// "Próximo": descarta o item atual da fila e toca o seguinte.
  Future<void> playNextInQueue() => _handler.skipToNext();

  void startSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    _sleepTimerEndsAt = DateTime.now().add(duration);
    state = state.copyWith(sleepTimerRemaining: duration);
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickSleepTimer());
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerEndsAt = null;
    state = state.copyWith(sleepTimerRemaining: null);
  }

  void _tickSleepTimer() {
    final endsAt = _sleepTimerEndsAt;
    if (endsAt == null) return;

    final remaining = endsAt.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      _sleepTimer?.cancel();
      _sleepTimer = null;
      _sleepTimerEndsAt = null;
      state = state.copyWith(sleepTimerRemaining: null);
      _handler.pause();
    } else {
      state = state.copyWith(sleepTimerRemaining: remaining);
    }
  }

  void _onTick() {
    if (state.episode == null) return;

    final playbackState = _handler.playbackState.value;
    state = state.copyWith(
      position: playbackState.position,
      bufferedPosition: playbackState.bufferedPosition,
    );

    _tickCount++;
    if (playbackState.playing && _tickCount % _ticksPerSave == 0) {
      unawaited(_saveProgress());
    }
  }

  void _onMediaItemChanged(audio_service.MediaItem? item) {
    if (item == null) return;
    final guid = item.extras?['guid'] as String?;
    final entry = _entryFor(guid);
    state = state.copyWith(
      duration: item.duration,
      episode: entry?.episode ?? state.episode,
      podcast: entry?.podcast ?? state.podcast,
    );
  }

  QueueEntry? _entryFor(String? guid) {
    if (guid == null) return null;
    for (final e in _entries) {
      if (e.episode.guid == guid) return e;
    }
    return null;
  }

  void _onPlaybackStateChanged(audio_service.PlaybackState playbackState) {
    // Se estava tocando e parou de tocar (pause, fim do episódio, etc.),
    // salva na hora — não espera o próximo tick de 5s. Cobre o caso de
    // pausar bem no início, antes do primeiro ciclo de salvamento.
    final wasPlaying = state.isPlaying;

    state = state.copyWith(
      isPlaying: playbackState.playing,
      isBuffering: playbackState.processingState == audio_service.AudioProcessingState.buffering ||
          playbackState.processingState == audio_service.AudioProcessingState.loading,
      position: playbackState.position,
      bufferedPosition: playbackState.bufferedPosition,
      speed: playbackState.speed,
    );

    if (wasPlaying && !playbackState.playing) {
      unawaited(_saveProgress());
    }
    // Qual episódio está tocando vem do `mediaItem` (via `extras`), tratado
    // em `_onMediaItemChanged` — não do `queueIndex` (que é sempre 0 no
    // modelo de fila "consumir da frente").
  }

  Future<void> _saveProgress() async {
    final podcast = state.podcast;
    final episode = state.episode;
    if (podcast == null || episode == null) return;

    final duration = state.duration;
    final nearEnd = duration != null && duration > Duration.zero && state.position >= duration - const Duration(seconds: 3);

    await ref.read(libraryRepositoryProvider).savePlaybackPosition(
          podcastId: podcast.id,
          episodeGuid: episode.guid,
          position: state.position,
          completed: nearEnd,
        );
  }

  audio_service.MediaItem _toMediaItem(Podcast podcast, Episode episode, {String? localPath}) {
    final artUrl = episode.imageUrl ?? podcast.artworkUrl;
    final id = localPath != null ? Uri.file(localPath).toString() : episode.audioUrl;
    return audio_service.MediaItem(
      id: id,
      title: episode.title,
      artist: podcast.author,
      album: podcast.title,
      artUri: artUrl != null ? Uri.tryParse(artUrl) : null,
      duration: episode.duration,
      extras: {'guid': episode.guid, 'podcastId': podcast.id},
    );
  }
}
