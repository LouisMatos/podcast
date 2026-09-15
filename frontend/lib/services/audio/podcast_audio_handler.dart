import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'media_browser.dart';

part 'podcast_audio_handler.g.dart';

/// Uma banda do equalizador, sem vazar tipo do `just_audio` pro ViewModel.
typedef EqualizerBandInfo = ({int index, double centerHz, double gain});

/// Estado do equalizador lido do device (nº de bandas e faixa de ganho
/// variam por aparelho).
typedef EqualizerSnapshot = ({double minDb, double maxDb, List<EqualizerBandInfo> bands});

/// Ponte entre o player (`just_audio`) e o sistema (notificação, lockscreen,
/// Bluetooth). Um `AudioHandler` só existe pra isso — decisão de negócio
/// (o que tocar, progresso, sleep timer) mora no `PlayerViewModel`.
class PodcastAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  PodcastAudioHandler() {
    _player.playbackEventStream.listen(_broadcastPlaybackState, onError: _broadcastError);
    _player.processingStateStream.listen((state) {
      if (state == just_audio.ProcessingState.completed) _onEpisodeCompleted();
    });
  }

  /// Equalizador só funciona no Android (limitação do `just_audio`). No iOS
  /// o efeito fica no pipeline mas é ignorado; o volume funciona nos dois.
  final just_audio.AndroidEqualizer _equalizer = just_audio.AndroidEqualizer();

  /// Normalização/reforço de volume (Fase 14). Android apenas. Precisa entrar
  /// no pipeline na construção do player, junto do equalizer — não dá pra
  /// adicionar efeito depois.
  final just_audio.AndroidLoudnessEnhancer _loudnessEnhancer =
      just_audio.AndroidLoudnessEnhancer();

  late final just_audio.AudioPlayer _player = just_audio.AudioPlayer(
    audioPipeline: just_audio.AudioPipeline(
      androidAudioEffects: [_loudnessEnhancer, _equalizer],
    ),
  );

  Future<void> setVolume(double volume) => _player.setVolume(volume);

  Future<void> setEqualizerEnabled(bool enabled) => _equalizer.setEnabled(enabled);

  /// Pular trechos de silêncio (Fase 14). Android apenas — no-op no resto.
  Future<void> setSkipSilence(bool enabled) => _player.setSkipSilenceEnabled(enabled);

  /// Reforço de volume (Fase 14). [gainDb] em decibéis (0 = sem reforço).
  Future<void> setVolumeBoost({required bool enabled, required double gainDb}) async {
    await _loudnessEnhancer.setTargetGain(enabled ? gainDb : 0.0);
    await _loudnessEnhancer.setEnabled(enabled);
  }

  /// Reflete o capítulo atual no subtítulo da notificação/lockscreen
  /// (Fase 14). `null` volta pro autor do podcast.
  void setChapterTitle(String? chapterTitle) {
    final current = mediaItem.value;
    if (current == null) return;
    mediaItem.add(current.copyWith(displaySubtitle: chapterTitle ?? current.artist));
  }

  /// Bandas do equalizador do device. Só resolve depois que um áudio foi
  /// carregado (o `just_audio` só ativa o efeito com o player ativo).
  Future<EqualizerSnapshot> equalizerSnapshot() async {
    final params = await _equalizer.parameters;
    return (
      minDb: params.minDecibels,
      maxDb: params.maxDecibels,
      bands: [
        for (final b in params.bands)
          (index: b.index, centerHz: b.centerFrequency, gain: b.gain),
      ],
    );
  }

  Future<void> setEqualizerBandGain(int index, double gain) async {
    final params = await _equalizer.parameters;
    if (index < 0 || index >= params.bands.length) return;
    await params.bands[index].setGain(gain);
  }

  /// Chamado quando o item em foco sai da fila (terminou ou o usuário
  /// pulou). O `PlayerViewModel` usa pra remover o mesmo item da fila
  /// persistida. Recebe o `MediaItem` consumido (o `guid`/`podcastId` vêm
  /// em `extras`).
  void Function(MediaItem consumed)? onItemConsumed;

  /// Árvore de mídia navegável (Android Auto). Setada de fora — igual
  /// `onItemConsumed`. `null` até o AppShell fiar (ver `mediaBrowserWiring`).
  /// O handler só delega; a lógica mora em `RepoMediaBrowserSource`.
  MediaBrowserSource? mediaBrowser;

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId,
          [Map<String, dynamic>? options]) =>
      mediaBrowser?.getChildren(parentMediaId) ?? Future.value(const []);

  @override
  Future<MediaItem?> getMediaItem(String mediaId) =>
      mediaBrowser?.getMediaItem(mediaId) ?? Future.value();

  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async {
    await mediaBrowser?.playFromMediaId(mediaId);
  }

  /// Substitui a fila do handler (Fase 12 — espelho da fila persistida).
  ///
  /// [playFirst] carrega o áudio do item 0 — usado ao tocar um episódio
  /// novo. Sem ele, só atualiza a lista sem mexer no áudio que já toca
  /// (usado quando o usuário só enfileira / reordena).
  ///
  /// [autoPlay] `false` só prepara o áudio (Fase 8.3).
  Future<void> setQueue(
    List<MediaItem> items, {
    bool playFirst = false,
    Duration? initialPosition,
    bool autoPlay = true,
  }) async {
    queue.add(items);
    if (items.isEmpty) {
      await stop();
      return;
    }
    if (playFirst) {
      await skipToQueueItem(0, initialPosition: initialPosition, autoPlay: autoPlay);
    } else {
      playbackState.add(playbackState.value.copyWith(queueIndex: 0));
    }
  }

  @override
  Future<void> skipToQueueItem(int index, {Duration? initialPosition, bool autoPlay = true}) async {
    final items = queue.value;
    if (index < 0 || index >= items.length) return;

    final item = items[index];
    mediaItem.add(item);
    playbackState.add(playbackState.value.copyWith(queueIndex: index));

    // Sem timeout aqui, uma conexão que abre mas nunca responde (proxy de
    // operadora, CDN quebrado) trava esse await pra sempre — nem lança
    // exceção nem emite erro no stream do just_audio, então o buffering
    // fica preso indefinidamente sem nada pra tratar.
    await _player
        .setAudioSource(just_audio.AudioSource.uri(Uri.parse(item.id)))
        .timeout(const Duration(seconds: 20));
    if (initialPosition != null && initialPosition > Duration.zero) {
      await _player.seek(initialPosition);
    }
    if (autoPlay) await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(playing: false, processingState: AudioProcessingState.idle));
    await super.stop();
  }

  Future<void> skipForward(Duration amount) => _seekBy(amount);

  Future<void> skipBackward(Duration amount) => _seekBy(-amount);

  /// Pula pro próximo da fila: descarta o item 0 e carrega o novo item 0.
  @override
  Future<void> skipToNext() => _advance(autoPlay: true);

  /// Sem histórico na fila — "anterior" volta ao início do episódio atual.
  @override
  Future<void> skipToPrevious() => _player.seek(Duration.zero);

  /// Tira o item em foco da fila e toca o próximo (ou para, se acabou).
  Future<void> _advance({bool autoPlay = true}) async {
    final items = [...queue.value];
    if (items.isEmpty) return;
    final consumed = items.removeAt(0);
    queue.add(items);
    onItemConsumed?.call(consumed);
    if (items.isEmpty) {
      await stop();
    } else {
      await skipToQueueItem(0, autoPlay: autoPlay);
    }
  }

  Future<void> _seekBy(Duration amount) {
    final target = _player.position + amount;
    final duration = _player.duration;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (duration != null && target > duration ? duration : target);
    return _player.seek(clamped);
  }

  Future<void> _onEpisodeCompleted() => _advance();

  void _broadcastPlaybackState(just_audio.PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: switch (_player.processingState) {
          just_audio.ProcessingState.idle => AudioProcessingState.idle,
          just_audio.ProcessingState.loading => AudioProcessingState.loading,
          just_audio.ProcessingState.buffering => AudioProcessingState.buffering,
          just_audio.ProcessingState.ready => AudioProcessingState.ready,
          just_audio.ProcessingState.completed => AudioProcessingState.completed,
        },
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: playbackState.value.queueIndex,
      ),
    );

    if (event.duration != null && event.duration != mediaItem.value?.duration) {
      final current = mediaItem.value;
      if (current != null) mediaItem.add(current.copyWith(duration: event.duration));
    }
  }

  void _broadcastError(Object error, StackTrace stackTrace) {
    playbackState.add(
      playbackState.value.copyWith(processingState: AudioProcessingState.error, playing: false),
    );
  }
}

/// Só existe de verdade depois de `AudioService.init` em `main.dart` — a
/// implementação aqui nunca roda, é sobrescrita via `overrideWithValue`
/// antes do primeiro `runApp`.
@Riverpod(keepAlive: true)
PodcastAudioHandler audioHandler(Ref ref) {
  throw UnimplementedError('audioHandlerProvider precisa de overrideWithValue em main.dart');
}
