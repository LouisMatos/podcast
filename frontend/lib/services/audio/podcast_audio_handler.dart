import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  late final just_audio.AudioPlayer _player = just_audio.AudioPlayer(
    audioPipeline: just_audio.AudioPipeline(androidAudioEffects: [_equalizer]),
  );

  Future<void> setVolume(double volume) => _player.setVolume(volume);

  Future<void> setEqualizerEnabled(bool enabled) => _equalizer.setEnabled(enabled);

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

  /// Carrega uma fila a partir do item em [startIndex], retomando de
  /// [initialPosition] quando existe progresso salvo (Fase 3).
  ///
  /// [autoPlay] `false` só prepara o áudio (o usuário decide quando ouvir —
  /// Fase 8.3). O auto-avanço no fim de um episódio continua com `true`.
  Future<void> playQueue(
    List<MediaItem> items, {
    required int startIndex,
    Duration? initialPosition,
    bool autoPlay = true,
  }) async {
    queue.add(items);
    await skipToQueueItem(startIndex, initialPosition: initialPosition, autoPlay: autoPlay);
  }

  @override
  Future<void> skipToQueueItem(int index, {Duration? initialPosition, bool autoPlay = true}) async {
    final items = queue.value;
    if (index < 0 || index >= items.length) return;

    final item = items[index];
    mediaItem.add(item);
    playbackState.add(playbackState.value.copyWith(queueIndex: index));

    await _player.setAudioSource(just_audio.AudioSource.uri(Uri.parse(item.id)));
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

  Future<void> _seekBy(Duration amount) {
    final target = _player.position + amount;
    final duration = _player.duration;
    final clamped = target < Duration.zero
        ? Duration.zero
        : (duration != null && target > duration ? duration : target);
    return _player.seek(clamped);
  }

  Future<void> _onEpisodeCompleted() async {
    final items = queue.value;
    final nextIndex = (playbackState.value.queueIndex ?? -1) + 1;
    if (nextIndex < items.length) {
      await skipToQueueItem(nextIndex);
    } else {
      await stop();
    }
  }

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
