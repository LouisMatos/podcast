import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:audio_service/audio_service.dart' as audio_service;
// `foundation`/`services` (não `material`) — `visibleForTesting` e o
// `HapticFeedback` do "agitar pra estender o timer" (Fase 14). Não viola a
// regra de camada (que proíbe só `material.dart` no ViewModel).
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../core/prefs/preferences_store.dart';
import '../../../data/models/chapter.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/download_repository.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/queue_repository.dart';
import '../../../services/audio/podcast_audio_handler.dart';
import '../../../services/chapters/chapter_service.dart';
import 'player_state.dart';

part 'player_view_model.g.dart';

const _tickInterval = Duration(seconds: 1);
const _ticksPerSave = 5; // salva progresso a cada ~5s, não a cada tick

/// Estende o timer "agitar pra dormir mais um pouco" nesse tanto.
const _shakeExtension = Duration(minutes: 5);

/// Aceleração resultante (m/s²) acima da qual conta como "chacoalhada". ~2.5g
/// — filtra o balanço normal de quem está deitado com o celular na mão.
const _shakeThreshold = 24.0;

/// Silêncio entre chacoalhadas aceitas (senão um tranco vira várias).
const _shakeCooldown = Duration(seconds: 2);

/// Fase 17 — quanto do avanço de posição conta como "escuta real": o delta
/// entre dois pontos, limitado a `(0, 2min]`. Fora dessa faixa (retrocesso,
/// pausa parado, seek grande pra frente) → `Duration.zero`. Função pura pra
/// testar sem o handler.
Duration listeningDelta(Duration previous, Duration current) {
  final delta = current - previous;
  if (delta <= Duration.zero || delta > const Duration(minutes: 2)) {
    return Duration.zero;
  }
  return delta;
}

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
  StreamSubscription<List<Chapter>>? _chaptersSub;
  StreamSubscription<AccelerometerEvent>? _shakeSub;
  Timer? _ticker;
  Timer? _sleepTimer;
  DateTime? _sleepTimerEndsAt;
  DateTime? _lastShakeAt;
  int _tickCount = 0;

  /// Último índice de capítulo já refletido na notificação — pra só
  /// reescrever o `MediaItem` quando o capítulo realmente muda.
  int? _lastChapterIndex;

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
      _chaptersSub?.cancel();
      _shakeSub?.cancel();
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

    // Efeitos de áudio salvos (Fase 14) — pular silêncio e reforço de
    // volume. Android apenas; no-op no resto.
    final skipSilence = _prefs.skipSilenceEnabled;
    final boostEnabled = _prefs.volumeBoostEnabled;
    final boostGain = _prefs.volumeBoostGainDb;
    unawaited(_handler.setSkipSilence(skipSilence));
    unawaited(_handler.setVolumeBoost(enabled: boostEnabled, gainDb: boostGain));

    return PlayerState(
      volume: volume,
      speed: speed,
      skipSilenceEnabled: skipSilence,
      volumeBoostEnabled: boostEnabled,
      volumeBoostGainDb: boostGain,
    );
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
    _lastChapterIndex = null;
    _completedHapticGuid = null;
    state = state.copyWith(
      podcast: podcast,
      episode: episode,
      queue: [episode],
      duration: episode.duration,
      chapters: const [],
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
    unawaited(_loadChapters(podcast, episode));

    // Efeitos de áudio não persistem entre trocas de `AudioSource` — reaplica.
    unawaited(_handler.setSkipSilence(state.skipSilenceEnabled));
    unawaited(_handler.setVolumeBoost(
      enabled: state.volumeBoostEnabled,
      gainDb: state.volumeBoostGainDb,
    ));
  }

  /// Baixa (uma vez) e escuta os capítulos do episódio. `watchChapters`
  /// emite `[]` primeiro; quando o JSON chega, a lista aparece no player.
  Future<void> _loadChapters(Podcast podcast, Episode episode) async {
    await _chaptersSub?.cancel();
    final chapters = ref.read(chapterServiceProvider);
    unawaited(chapters.ensureChapters(
      podcastId: podcast.id,
      episodeGuid: episode.guid,
      chaptersUrl: episode.chaptersUrl,
    ));
    _chaptersSub = chapters.watchChapters(podcast.id, episode.guid).listen((list) {
      if (!ref.mounted) return;
      // Só do episódio que está tocando (troca rápida de episódio).
      if (state.episode?.guid != episode.guid) return;
      state = state.copyWith(chapters: list);
      _syncChapterToNotification();
    });
  }

  /// Reflete o capítulo atual no `MediaItem` (subtítulo da notificação /
  /// lockscreen). Só reescreve quando o índice muda.
  void _syncChapterToNotification() {
    final index = state.currentChapterIndex;
    if (index == _lastChapterIndex) return;
    _lastChapterIndex = index;
    _handler.setChapterTitle(index == null ? null : state.chapters[index].title);
  }

  /// Pula pro início do capítulo [index].
  void skipToChapter(int index) {
    if (index < 0 || index >= state.chapters.length) return;
    _handler.seek(state.chapters[index].start);
  }

  /// Próximo capítulo (no-op se já no último ou sem capítulos).
  void skipToNextChapter() {
    final current = state.currentChapterIndex;
    if (current == null) {
      if (state.chapters.isNotEmpty) skipToChapter(0);
      return;
    }
    skipToChapter(current + 1);
  }

  /// Capítulo anterior. Se já passou mais de 3s do início do capítulo atual,
  /// volta pro início dele (comportamento de faixa de música).
  void skipToPreviousChapter() {
    final current = state.currentChapterIndex;
    if (current == null) return;
    final into = state.position - state.chapters[current].start;
    if (into > const Duration(seconds: 3)) {
      skipToChapter(current);
    } else {
      skipToChapter(current - 1);
    }
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

  /// Guid do último episódio pra qual já demos o retorno tátil de "concluído"
  /// (Fase 15) — pra vibrar uma vez só, não a cada save perto do fim.
  String? _completedHapticGuid;

  /// Última posição já contabilizada no histórico de escuta (Fase 17) e o
  /// guid a que ela pertence. `_saveProgress` compara com a posição atual pra
  /// gravar só o avanço real ouvido.
  Duration _lastRecordedPosition = Duration.zero;
  String? _recordingGuid;

  /// "Adicionar à fila" — vai pro fim.
  Future<void> enqueue(Podcast podcast, Episode episode) {
    unawaited(HapticFeedback.mediumImpact());
    return ref.read(queueRepositoryProvider).addToEnd(podcast, episode);
  }

  /// "Tocar a seguir" — logo após o episódio atual.
  Future<void> playNext(Podcast podcast, Episode episode) {
    unawaited(HapticFeedback.mediumImpact());
    return ref
        .read(queueRepositoryProvider)
        .playNextAfter(podcast, episode, state.episode?.guid);
  }

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

    // Timer "fim do episódio": o episódio armado saiu de foco (terminou ou
    // foi pulado) — pausa antes do próximo começar.
    if (state.sleepTimerMode == SleepTimerMode.endOfEpisode && guid == _sleepAtEndGuid) {
      _handler.pause();
      cancelSleepTimer();
    }

    unawaited(ref.read(queueRepositoryProvider).removeEpisode(podcastId, guid));
  }

  // ---- Efeitos de áudio (Fase 14) — Android apenas ----

  Future<void> setSkipSilence(bool enabled) async {
    state = state.copyWith(skipSilenceEnabled: enabled);
    unawaited(_prefs.setSkipSilenceEnabled(enabled));
    await _handler.setSkipSilence(enabled);
  }

  Future<void> setVolumeBoostEnabled(bool enabled) async {
    state = state.copyWith(volumeBoostEnabled: enabled);
    unawaited(_prefs.setVolumeBoostEnabled(enabled));
    await _handler.setVolumeBoost(enabled: enabled, gainDb: state.volumeBoostGainDb);
  }

  Future<void> setVolumeBoostGain(double gainDb) async {
    state = state.copyWith(volumeBoostGainDb: gainDb);
    unawaited(_prefs.setVolumeBoostGainDb(gainDb));
    if (state.volumeBoostEnabled) {
      await _handler.setVolumeBoost(enabled: true, gainDb: gainDb);
    }
  }

  void togglePlayPause() {
    unawaited(HapticFeedback.selectionClick());
    if (state.isPlaying) {
      _handler.pause();
    } else {
      _handler.play();
    }
  }

  void seek(Duration position) => _handler.seek(position);

  void skipForward([Duration amount = const Duration(seconds: 30)]) {
    unawaited(HapticFeedback.selectionClick());
    _handler.skipForward(amount);
  }

  void skipBackward([Duration amount = const Duration(seconds: 15)]) {
    unawaited(HapticFeedback.selectionClick());
    _handler.skipBackward(amount);
  }

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

  // ---- Temporizador para dormir (Fase 14) ----

  /// Guid do episódio que estava tocando quando o modo "fim do episódio" foi
  /// armado — o timer dispara quando ESSE episódio sai de foco.
  String? _sleepAtEndGuid;

  /// Fonte do acelerômetro. Trocável em teste — o `accelerometerEventStream`
  /// do `sensors_plus` bate em platform channel.
  @visibleForTesting
  Stream<AccelerometerEvent> Function()? debugAccelerometerStream;

  /// Conta [duration] e pausa ao zerar. "Agite" adiciona 5 min.
  void startSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    _sleepAtEndGuid = null;
    _sleepTimerEndsAt = DateTime.now().add(duration);
    state = state.copyWith(
      sleepTimerMode: SleepTimerMode.duration,
      sleepTimerRemaining: duration,
    );
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickSleepTimer());
    _startShakeListener();
  }

  /// Pausa quando o episódio atual termina (sem contagem regressiva).
  void startSleepTimerAtEndOfEpisode() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerEndsAt = null;
    _sleepAtEndGuid = state.episode?.guid;
    state = state.copyWith(
      sleepTimerMode: SleepTimerMode.endOfEpisode,
      sleepTimerRemaining: null,
    );
    _startShakeListener();
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerEndsAt = null;
    _sleepAtEndGuid = null;
    _shakeSub?.cancel();
    _shakeSub = null;
    _lastShakeAt = null;
    state = state.copyWith(
      sleepTimerMode: SleepTimerMode.off,
      sleepTimerRemaining: null,
    );
  }

  void _tickSleepTimer() {
    final endsAt = _sleepTimerEndsAt;
    if (endsAt == null) return;

    final remaining = endsAt.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      _handler.pause();
      cancelSleepTimer();
    } else {
      state = state.copyWith(sleepTimerRemaining: remaining);
    }
  }

  void _startShakeListener() {
    _shakeSub?.cancel();
    final override = debugAccelerometerStream;
    // Mesmo critério do equalizer (ver Notas de plataforma): `Platform` é o
    // OS do host — `false` em `flutter test`, então o acelerômetro real não
    // é tocado no teste (que injeta `debugAccelerometerStream`).
    if (override == null && !(Platform.isAndroid || Platform.isIOS)) return;
    final source = override ?? accelerometerEventStream;
    _shakeSub = source().listen(_onAccelerometer, onError: (Object _) {});
  }

  void _onAccelerometer(AccelerometerEvent event) {
    if (!state.hasSleepTimer) return;
    final magnitude = math.sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    if (magnitude < _shakeThreshold) return;

    final now = DateTime.now();
    if (_lastShakeAt != null && now.difference(_lastShakeAt!) < _shakeCooldown) return;
    _lastShakeAt = now;
    _extendSleepTimer();
  }

  /// Chacoalhada aceita: dá mais 5 min. No modo "fim do episódio", converte
  /// pra contagem de 5 min a partir de agora.
  void _extendSleepTimer() {
    final base = _sleepTimerEndsAt ?? DateTime.now();
    _sleepTimerEndsAt = base.add(_shakeExtension);
    _sleepAtEndGuid = null;
    _sleepTimer ??= Timer.periodic(const Duration(seconds: 1), (_) => _tickSleepTimer());
    state = state.copyWith(
      sleepTimerMode: SleepTimerMode.duration,
      sleepTimerRemaining: _sleepTimerEndsAt!.difference(DateTime.now()),
    );
    unawaited(HapticFeedback.mediumImpact());
  }

  void _onTick() {
    if (state.episode == null || _radioActive) return;

    final playbackState = _handler.playbackState.value;
    state = state.copyWith(
      position: playbackState.position,
      bufferedPosition: playbackState.bufferedPosition,
    );
    _syncChapterToNotification();

    _tickCount++;
    if (playbackState.playing && _tickCount % _ticksPerSave == 0) {
      unawaited(_saveProgress());
    }
  }

  /// Rádio ao vivo toca no mesmo `PodcastAudioHandler` mas fora do fluxo de
  /// fila/progresso/capítulos — sem isso, `_saveProgress` gravaria a posição
  /// da rádio sob o guid do último episódio real tocado.
  bool get _radioActive => _handler.mediaItem.value?.extras?['isRadio'] == true;

  void _onMediaItemChanged(audio_service.MediaItem? item) {
    if (item == null) return;
    if (item.extras?['isRadio'] == true) return;
    final guid = item.extras?['guid'] as String?;

    // Trocou de episódio — zera a base do histórico de escuta (Fase 17).
    if (guid != null && _recordingGuid != null && guid != _recordingGuid) {
      _lastRecordedPosition = Duration.zero;
      _recordingGuid = null;
    }

    final entry = _entryFor(guid);
    state = state.copyWith(
      duration: item.duration,
      episode: entry?.episode ?? state.episode,
      podcast: entry?.podcast ?? state.podcast,
    );

    // Fase 21 v3: a duração real do player corrige a do `itunes:duration` no
    // cache. Uma vez por episódio, só quando diverge > 2s.
    final real = item.duration;
    if (real != null && guid != null && entry != null && _durationFixedGuid != guid) {
      final cached = entry.episode.duration;
      if (cached == null || (cached - real).abs() > const Duration(seconds: 2)) {
        _durationFixedGuid = guid;
        unawaited(ref
            .read(libraryRepositoryProvider)
            .updateEpisodeDuration(entry.podcast.id, guid, real));
      }
    }
  }

  String? _durationFixedGuid;

  QueueEntry? _entryFor(String? guid) {
    if (guid == null) return null;
    for (final e in _entries) {
      if (e.episode.guid == guid) return e;
    }
    return null;
  }

  void _onPlaybackStateChanged(audio_service.PlaybackState playbackState) {
    if (_radioActive) return;

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

    // Retorno tátil ao concluir um episódio (Fase 15), uma vez só.
    if (nearEnd && _completedHapticGuid != episode.guid) {
      _completedHapticGuid = episode.guid;
      unawaited(HapticFeedback.mediumImpact());
    }

    // Histórico de escuta (Fase 17): grava só o avanço real ouvido desde o
    // último save deste mesmo episódio.
    if (_recordingGuid == episode.guid) {
      final delta = listeningDelta(_lastRecordedPosition, state.position);
      if (delta > Duration.zero) {
        unawaited(ref.read(libraryRepositoryProvider).recordListening(
              podcastId: podcast.id,
              episodeGuid: episode.guid,
              delta: delta,
            ));
      }
    }
    _lastRecordedPosition = state.position;
    _recordingGuid = episode.guid;

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
