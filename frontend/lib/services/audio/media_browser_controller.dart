import 'package:audio_service/audio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/episode.dart';
import '../../data/models/podcast.dart';
import '../../data/repositories/library_repository.dart';
import '../../data/repositories/queue_repository.dart';
import '../../features/player/view_model/player_view_model.dart';
import '../../features/podcast_detail/view_model/podcast_by_id_provider.dart';
import 'media_browser.dart';
import 'podcast_audio_handler.dart';

part 'media_browser_controller.g.dart';

/// Monta a árvore de mídia do Android Auto a partir dos repositórios.
/// Fica fora do `PodcastAudioHandler` pra não vazar Riverpod pro handler.
class RepoMediaBrowserSource implements MediaBrowserSource {
  RepoMediaBrowserSource(this._ref);

  final Ref _ref;

  LibraryRepository get _library => _ref.read(libraryRepositoryProvider);

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId) async {
    switch (parentMediaId) {
      case MediaBrowserIds.root:
        return _rootFolders();
      case MediaBrowserIds.continueRoot:
        final items = await _library.watchContinueListening(limit: 30).first;
        return [for (final i in items) _episodeItem(i.podcast, i.episode)];
      case MediaBrowserIds.queue:
        final entries = await _ref.read(queueRepositoryProvider).currentQueue();
        return [for (final e in entries) _episodeItem(e.podcast, e.episode)];
      case MediaBrowserIds.subs:
        final subs = await _library.watchSubscriptions().first;
        return [for (final p in subs) _subFolder(p)];
      case MediaBrowserIds.downloads:
        return _downloads();
      default:
        final subId = MediaBrowserIds.parseSubMediaId(parentMediaId);
        if (subId == null) return const [];
        final podcast = await _resolvePodcast(subId);
        if (podcast == null) return const [];
        final eps = await _library.cachedEpisodes(subId);
        return [for (final e in eps.take(50)) _episodeItem(podcast, e)];
    }
  }

  @override
  Future<MediaItem?> getMediaItem(String mediaId) async {
    final parsed = MediaBrowserIds.parseEpisodeMediaId(mediaId);
    if (parsed == null) return null;
    final podcast = await _resolvePodcast(parsed.podcastId);
    final episode = await _resolveEpisode(parsed.podcastId, parsed.guid);
    if (podcast == null || episode == null) return null;
    return _episodeItem(podcast, episode);
  }

  @override
  Future<void> playFromMediaId(String mediaId) async {
    final parsed = MediaBrowserIds.parseEpisodeMediaId(mediaId);
    if (parsed == null) return;
    final podcast = await _resolvePodcast(parsed.podcastId);
    final episode = await _resolveEpisode(parsed.podcastId, parsed.guid);
    if (podcast == null || episode == null) return;
    await _ref
        .read(playerViewModelProvider.notifier)
        .playEpisode(podcast, episode, autoPlay: true);
  }

  List<MediaItem> _rootFolders() => const [
        MediaItem(
          id: MediaBrowserIds.continueRoot,
          title: 'Continuar ouvindo',
          playable: false,
        ),
        MediaItem(id: MediaBrowserIds.queue, title: 'Fila', playable: false),
        MediaItem(id: MediaBrowserIds.subs, title: 'Assinaturas', playable: false),
        MediaItem(
          id: MediaBrowserIds.downloads,
          title: 'Baixados',
          playable: false,
        ),
      ];

  /// Concatena os episódios baixados de todas as assinaturas.
  Future<List<MediaItem>> _downloads() async {
    final subs = await _library.watchSubscriptions().first;
    final result = <MediaItem>[];
    for (final p in subs) {
      final eps = await _library.watchDownloadedEpisodes(p.id).first;
      for (final e in eps) {
        result.add(_episodeItem(p, e));
      }
    }
    return result;
  }

  MediaItem _subFolder(Podcast podcast) => MediaItem(
        id: MediaBrowserIds.subMediaId(podcast.id),
        title: podcast.title,
        playable: false,
        artUri: _tryUri(podcast.artworkUrl),
      );

  MediaItem _episodeItem(Podcast podcast, Episode episode) => MediaItem(
        id: MediaBrowserIds.episodeMediaId(podcast.id, episode.guid),
        title: episode.title,
        artist: podcast.title,
        album: podcast.title,
        duration: episode.duration,
        playable: true,
        artUri: _tryUri(episode.imageUrl ?? podcast.artworkUrl),
        extras: {'guid': episode.guid, 'podcastId': podcast.id},
      );

  Uri? _tryUri(String? url) => url == null ? null : Uri.tryParse(url);

  /// Assinaturas primeiro (offline); cai na iTunes Search API se não
  /// estiver assinado (ver `podcastByIdProvider`).
  Future<Podcast?> _resolvePodcast(int id) =>
      _ref.read(podcastByIdProvider(id).future);

  /// Cache do podcast primeiro; se não achar (episódio arquivado / cache
  /// limpo), tenta a fila e o "continuar ouvindo".
  Future<Episode?> _resolveEpisode(int podcastId, String guid) async {
    final cached =
        await _library.cachedEpisodes(podcastId, includeArchived: true);
    for (final e in cached) {
      if (e.guid == guid) return e;
    }
    final queue = await _ref.read(queueRepositoryProvider).currentQueue();
    for (final entry in queue) {
      if (entry.episode.guid == guid) return entry.episode;
    }
    final continuing = await _library.watchContinueListening(limit: 50).first;
    for (final item in continuing) {
      if (item.episode.guid == guid) return item.episode;
    }
    return null;
  }
}

@Riverpod(keepAlive: true)
RepoMediaBrowserSource mediaBrowserSource(Ref ref) => RepoMediaBrowserSource(ref);

/// Seam de fiação: liga a árvore de mídia ao handler. O integrador chama
/// `ref.listen(mediaBrowserWiringProvider, (_, _) {})` no AppShell.
@Riverpod(keepAlive: true)
void mediaBrowserWiring(Ref ref) {
  ref.read(audioHandlerProvider).mediaBrowser = ref.read(mediaBrowserSourceProvider);
}
