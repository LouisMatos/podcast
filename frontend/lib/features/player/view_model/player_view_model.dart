import 'dart:async';

import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/download_repository.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../services/audio/podcast_audio_handler.dart';
import 'player_state.dart';

part 'player_view_model.g.dart';

const _tickInterval = Duration(seconds: 1);
const _ticksPerSave = 5; // salva progresso a cada ~5s, não a cada tick

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

  Podcast? _podcast;
  List<Episode> _queue = const [];

  PodcastAudioHandler get _handler => ref.read(audioHandlerProvider);

  @override
  PlayerState build() {
    final handler = _handler;

    _mediaItemSub = handler.mediaItem.listen(_onMediaItemChanged);
    _playbackStateSub = handler.playbackState.listen(_onPlaybackStateChanged);
    _ticker = Timer.periodic(_tickInterval, (_) => _onTick());

    ref.onDispose(() {
      _mediaItemSub?.cancel();
      _playbackStateSub?.cancel();
      _ticker?.cancel();
      _sleepTimer?.cancel();
    });

    return const PlayerState();
  }

  /// Toca [episode], começando a fila em [queue] (a lista de episódios do
  /// podcast) — retoma de onde parou se houver progresso salvo (Fase 3).
  Future<void> playEpisode(Podcast podcast, Episode episode, {required List<Episode> queue}) async {
    _podcast = podcast;
    _queue = queue;

    // Atualiza o estado já síncrono, antes de qualquer await — quem chamou
    // playEpisode costuma navegar pro player logo em seguida (sem esperar
    // essa Future), e a tela precisa ver podcast/episode desde o 1º frame,
    // não só depois do disco/rede responderem.
    state = state.copyWith(podcast: podcast, episode: episode, queue: queue, duration: episode.duration);

    final startIndex = queue.indexWhere((e) => e.guid == episode.guid);
    final savedPosition = await ref.read(libraryRepositoryProvider).playbackPositionFor(podcast.id, episode.guid);

    // Toca do arquivo baixado sempre que existir — é o que faz um episódio
    // baixado funcionar em modo avião (Fase 5).
    final localPaths = await ref.read(downloadRepositoryProvider).completedPathsForPodcast(podcast.id);
    final items = [for (final e in queue) _toMediaItem(podcast, e, localPath: localPaths[e.guid])];
    await _handler.playQueue(
      items,
      startIndex: startIndex < 0 ? 0 : startIndex,
      initialPosition: savedPosition,
    );
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
  }

  Future<void> playNextInQueue() async {
    final episode = state.episode;
    final podcast = _podcast;
    if (episode == null || podcast == null) return;

    final index = _queue.indexWhere((e) => e.guid == episode.guid);
    if (index == -1 || index >= _queue.length - 1) return;

    await playEpisode(podcast, _queue[index + 1], queue: _queue);
  }

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
    state = state.copyWith(duration: item.duration);
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

    final index = playbackState.queueIndex;
    if (index == null || index < 0 || index >= _queue.length) return;

    final episodeAtIndex = _queue[index];
    if (episodeAtIndex.guid != state.episode?.guid) {
      state = state.copyWith(episode: episodeAtIndex, duration: episodeAtIndex.duration);
    }
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
    );
  }
}
