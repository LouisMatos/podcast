// Named params ficam sem o underscore do campo privado (searchApi, não
// _searchApi) — mais legível pra quem chama o construtor — então não dá
// pra usar initializing formals aqui.
// ignore_for_file: prefer_initializing_formals

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../models/episode.dart';
import '../models/episode_search_result.dart';
import '../models/podcast.dart';
import '../sources/apple_charts_api.dart';
import '../sources/itunes_search_api.dart';
import '../sources/rss_feed_parser.dart';

part 'podcast_repository.g.dart';

/// Um podcast do ranking, junto da sua posição (1 = mais ouvido).
typedef RankedPodcast = ({int rank, Podcast podcast});

/// Unifica busca (iTunes Search API), rankings (Apple Charts) e feed (RSS)
/// por trás de uma API só. Um ViewModel nunca fala com os sources direto.
class PodcastRepository {
  PodcastRepository({
    required ItunesSearchApi searchApi,
    required RssFeedParser feedParser,
    required AppleChartsApi chartsApi,
  })  : _searchApi = searchApi,
        _feedParser = feedParser,
        _chartsApi = chartsApi;

  final ItunesSearchApi _searchApi;
  final RssFeedParser _feedParser;
  final AppleChartsApi _chartsApi;

  Future<List<Podcast>> search(String term) => _searchApi.search(term);

  Future<List<Episode>> episodesFor(Podcast podcast) => _feedParser.fetchEpisodes(podcast.feedUrl);

  /// Busca episódios avulsos via iTunes (`entity=podcastEpisode`).
  Future<List<EpisodeSearchResult>> searchEpisodes(String term) => _searchApi.searchEpisodes(term);

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
  Future<List<RankedPodcast>> topPodcasts({int limit = 20}) async {
    final ids = await _chartsApi.topPodcastIds(limit: limit);
    return _resolveRanked(ids);
  }

  /// Os podcasts mais ouvidos no Brasil dentro de uma categoria (genreId da
  /// Apple), em ordem de ranking.
  Future<List<Podcast>> podcastsByGenre(int genreId, {int limit = 50}) async {
    final ids = await _chartsApi.topPodcastIds(limit: limit, genreId: genreId);
    final ranked = await _resolveRanked(ids);
    return ranked.map((r) => r.podcast).toList();
  }

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
}

/// `keepAlive`: sem estado próprio e usado por ViewModels `keepAlive`
/// (`FeaturedViewModel`) — `riverpod_lint: only_use_keep_alive_inside_keep_alive`.
@Riverpod(keepAlive: true)
PodcastRepository podcastRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return PodcastRepository(
    searchApi: ItunesSearchApi(dio),
    feedParser: RssFeedParser(dio),
    chartsApi: AppleChartsApi(dio),
  );
}
