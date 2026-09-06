// Named params ficam sem o underscore do campo privado (searchApi, não
// _searchApi) — mais legível pra quem chama o construtor — então não dá
// pra usar initializing formals aqui.
// ignore_for_file: prefer_initializing_formals

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../models/episode.dart';
import '../models/podcast.dart';
import '../sources/itunes_search_api.dart';
import '../sources/rss_feed_parser.dart';

part 'podcast_repository.g.dart';

/// Unifica busca (iTunes Search API) e feed (RSS) por trás de uma API só.
/// Um ViewModel nunca fala com `ItunesSearchApi`/`RssFeedParser` direto.
class PodcastRepository {
  PodcastRepository({required ItunesSearchApi searchApi, required RssFeedParser feedParser})
      : _searchApi = searchApi,
        _feedParser = feedParser;

  final ItunesSearchApi _searchApi;
  final RssFeedParser _feedParser;

  Future<List<Podcast>> search(String term) => _searchApi.search(term);

  Future<List<Episode>> episodesFor(Podcast podcast) => _feedParser.fetchEpisodes(podcast.feedUrl);
}

@riverpod
PodcastRepository podcastRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return PodcastRepository(
    searchApi: ItunesSearchApi(dio),
    feedParser: RssFeedParser(dio),
  );
}
