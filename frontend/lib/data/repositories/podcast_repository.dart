// Named params ficam sem o underscore do campo privado (searchApi, não
// _searchApi) — mais legível pra quem chama o construtor — então não dá
// pra usar initializing formals aqui.
// ignore_for_file: prefer_initializing_formals

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/network/dio_client.dart';
import '../models/episode.dart';
import '../models/episode_search_result.dart';
import '../models/podcast.dart';
import '../sources/apple_charts_api.dart';
import '../sources/itunes_search_api.dart';
import '../sources/rss_feed_parser.dart';
import 'query_cache_store.dart';

part 'podcast_repository.g.dart';

/// Um podcast do ranking, junto da sua posição (1 = mais ouvido).
typedef RankedPodcast = ({int rank, Podcast podcast});

/// Unifica busca (iTunes Search API), rankings (Apple Charts) e feed (RSS)
/// por trás de uma API só. Um ViewModel nunca fala com os sources direto.
///
/// Cache-aside via `QueryCache` (Fase 27): toda busca/ranking/episódio bem-
/// sucedido escreve no cache; falha de rede cai pro último resultado salvo
/// em vez de propagar erro, desde que exista algo salvo pra aquela consulta.
class PodcastRepository {
  PodcastRepository({
    required ItunesSearchApi searchApi,
    required RssFeedParser feedParser,
    required AppleChartsApi chartsApi,
    required AppDatabase db,
  })  : _searchApi = searchApi,
        _feedParser = feedParser,
        _chartsApi = chartsApi,
        _cache = QueryCacheStore(db);

  final ItunesSearchApi _searchApi;
  final RssFeedParser _feedParser;
  final AppleChartsApi _chartsApi;
  final QueryCacheStore _cache;

  Future<List<Podcast>> search(String term) {
    final key = 'podcast_search:${_norm(term)}';
    return _cache.cacheAside<Podcast>(
      key: key,
      category: 'podcast_search',
      fetch: () => _searchApi.search(term),
      toJson: _podcastToJson,
      fromJson: _podcastFromJson,
    );
  }

  /// Último resultado salvo pra essa busca, `null` se nunca buscou.
  Future<List<Podcast>?> cachedSearchResults(String term) =>
      _cache.read('podcast_search:${_norm(term)}', _podcastFromJson);

  Future<List<Episode>> episodesFor(Podcast podcast) {
    final key = 'podcast_episodes:${podcast.id}';
    return _cache.cacheAside<Episode>(
      key: key,
      category: 'podcast_episodes',
      fetch: () => _feedParser.fetchEpisodes(podcast.feedUrl),
      toJson: _episodeToJson,
      fromJson: _episodeFromJson,
    );
  }

  /// Último feed salvo desse podcast, `null` se nunca abriu. Cobre inclusive
  /// podcast não-assinado (sem FK, ao contrário de `LibraryRepository`).
  Future<List<Episode>?> cachedEpisodesFor(Podcast podcast) =>
      _cache.read('podcast_episodes:${podcast.id}', _episodeFromJson);

  /// Busca episódios avulsos via iTunes (`entity=podcastEpisode`).
  Future<List<EpisodeSearchResult>> searchEpisodes(String term) {
    final key = 'episode_search:${_norm(term)}';
    return _cache.cacheAside<EpisodeSearchResult>(
      key: key,
      category: 'episode_search',
      fetch: () => _searchApi.searchEpisodes(term),
      toJson: _episodeSearchResultToJson,
      fromJson: _episodeSearchResultFromJson,
    );
  }

  Future<List<EpisodeSearchResult>?> cachedEpisodeSearchResults(String term) =>
      _cache.read('episode_search:${_norm(term)}', _episodeSearchResultFromJson);

  /// Resolve um único `collectionId` iTunes em [Podcast] completo, pro
  /// resolvedor de deep link `podcastapp://podcast/<id>`. `null` se a iTunes
  /// não devolver esse id ou se vier sem `feedUrl`.
  Future<Podcast?> podcastById(int id) async {
    final results = await _searchApi.lookup([id]);
    for (final podcast in results) {
      if (podcast.id == id && podcast.feedUrl.isNotEmpty) return podcast;
    }
    return null;
  }

  /// Os [limit] podcasts mais ouvidos no Brasil, em ordem de ranking.
  Future<List<RankedPodcast>> topPodcasts({int limit = 20}) {
    final key = 'top_podcasts:br:$limit';
    return _cache.cacheAside<RankedPodcast>(
      key: key,
      category: 'top_podcasts',
      fetch: () async {
        final ids = await _chartsApi.topPodcastIds(limit: limit);
        return _resolveRanked(ids);
      },
      toJson: _rankedToJson,
      fromJson: _rankedFromJson,
    );
  }

  Future<List<RankedPodcast>?> cachedTopPodcasts({int limit = 20}) =>
      _cache.read('top_podcasts:br:$limit', _rankedFromJson);

  /// Os podcasts mais ouvidos no Brasil dentro de uma categoria (genreId da
  /// Apple), em ordem de ranking.
  Future<List<Podcast>> podcastsByGenre(int genreId, {int limit = 50}) {
    final key = 'genre_podcasts:$genreId:$limit';
    return _cache.cacheAside<Podcast>(
      key: key,
      category: 'genre_podcasts',
      fetch: () async {
        final ids = await _chartsApi.topPodcastIds(limit: limit, genreId: genreId);
        final ranked = await _resolveRanked(ids);
        return ranked.map((r) => r.podcast).toList();
      },
      toJson: _podcastToJson,
      fromJson: _podcastFromJson,
    );
  }

  Future<List<Podcast>?> cachedPodcastsByGenre(int genreId, {int limit = 50}) =>
      _cache.read('genre_podcasts:$genreId:$limit', _podcastFromJson);

  /// Resolve ids em [Podcast]s e reordena pela posição original — o
  /// `/lookup` não devolve na ordem pedida, e ids sem `feedUrl` somem.
  Future<List<RankedPodcast>> _resolveRanked(List<int> ids) async {
    if (ids.isEmpty) return const [];

    final podcasts = await _searchApi.lookup(ids);
    final byId = {for (final p in podcasts) p.id: p};

    final ranked = <RankedPodcast>[];
    for (var i = 0; i < ids.length; i++) {
      final podcast = byId[ids[i]];
      if (podcast != null) ranked.add((rank: i + 1, podcast: podcast));
    }
    return ranked;
  }

  String _norm(String term) => term.trim().toLowerCase();
}

Map<String, dynamic> _podcastToJson(Podcast p) => {
      'id': p.id,
      'title': p.title,
      'author': p.author,
      'feedUrl': p.feedUrl,
      'artworkUrl': p.artworkUrl,
      'genre': p.genre,
      'episodeCount': p.episodeCount,
    };

Podcast _podcastFromJson(Map<String, dynamic> json) => Podcast(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      feedUrl: json['feedUrl'] as String,
      artworkUrl: json['artworkUrl'] as String?,
      genre: json['genre'] as String?,
      episodeCount: json['episodeCount'] as int? ?? 0,
    );

Map<String, dynamic> _episodeToJson(Episode e) => {
      'guid': e.guid,
      'title': e.title,
      'audioUrl': e.audioUrl,
      'description': e.description,
      'imageUrl': e.imageUrl,
      'durationSeconds': e.duration?.inSeconds,
      'publishedAt': e.publishedAt?.millisecondsSinceEpoch,
      'seasonNumber': e.seasonNumber,
      'episodeNumber': e.episodeNumber,
      'episodeType': e.episodeType,
      'link': e.link,
      'chaptersUrl': e.chaptersUrl,
    };

Episode _episodeFromJson(Map<String, dynamic> json) => Episode(
      guid: json['guid'] as String,
      title: json['title'] as String,
      audioUrl: json['audioUrl'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      duration: json['durationSeconds'] != null ? Duration(seconds: json['durationSeconds'] as int) : null,
      publishedAt:
          json['publishedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['publishedAt'] as int) : null,
      seasonNumber: json['seasonNumber'] as int?,
      episodeNumber: json['episodeNumber'] as int?,
      episodeType: json['episodeType'] as String?,
      link: json['link'] as String?,
      chaptersUrl: json['chaptersUrl'] as String?,
    );

Map<String, dynamic> _episodeSearchResultToJson(EpisodeSearchResult r) => {
      'collectionId': r.collectionId,
      'collectionName': r.collectionName,
      'feedUrl': r.feedUrl,
      'podcastArtworkUrl': r.podcastArtworkUrl,
      'episode': _episodeToJson(r.episode),
    };

EpisodeSearchResult _episodeSearchResultFromJson(Map<String, dynamic> json) => EpisodeSearchResult(
      collectionId: json['collectionId'] as int,
      collectionName: json['collectionName'] as String,
      feedUrl: json['feedUrl'] as String?,
      podcastArtworkUrl: json['podcastArtworkUrl'] as String?,
      episode: _episodeFromJson(json['episode'] as Map<String, dynamic>),
    );

Map<String, dynamic> _rankedToJson(RankedPodcast r) => {
      'rank': r.rank,
      'podcast': _podcastToJson(r.podcast),
    };

RankedPodcast _rankedFromJson(Map<String, dynamic> json) => (
      rank: json['rank'] as int,
      podcast: _podcastFromJson(json['podcast'] as Map<String, dynamic>),
    );

/// `keepAlive`: sem estado próprio e usado por ViewModels `keepAlive`
/// (`FeaturedViewModel`) — `riverpod_lint: only_use_keep_alive_inside_keep_alive`.
@Riverpod(keepAlive: true)
PodcastRepository podcastRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return PodcastRepository(
    searchApi: ItunesSearchApi(dio),
    feedParser: RssFeedParser(dio),
    chartsApi: AppleChartsApi(dio),
    db: ref.watch(appDatabaseProvider),
  );
}
