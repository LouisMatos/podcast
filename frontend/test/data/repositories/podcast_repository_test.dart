import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/podcast_repository.dart';
import 'package:podcast_app/data/sources/apple_charts_api.dart';
import 'package:podcast_app/data/sources/itunes_search_api.dart';
import 'package:podcast_app/data/sources/rss_feed_parser.dart';

class _MockSearchApi extends Mock implements ItunesSearchApi {}

class _MockFeedParser extends Mock implements RssFeedParser {}

class _MockChartsApi extends Mock implements AppleChartsApi {}

Podcast _podcast(int id) =>
    Podcast(id: id, title: 'P$id', author: 'A', feedUrl: 'https://x/$id.xml');

void main() {
  late _MockSearchApi searchApi;
  late _MockFeedParser feedParser;
  late _MockChartsApi chartsApi;
  late PodcastRepository repo;

  setUp(() {
    searchApi = _MockSearchApi();
    feedParser = _MockFeedParser();
    chartsApi = _MockChartsApi();
    repo = PodcastRepository(searchApi: searchApi, feedParser: feedParser, chartsApi: chartsApi);
  });

  test('topPodcasts casa rank pela ordem dos ids mesmo com lookup fora de ordem', () async {
    when(() => chartsApi.topPodcastIds(limit: any(named: 'limit')))
        .thenAnswer((_) async => [10, 20, 30]);
    // lookup devolve embaralhado — o repositório tem que reordenar.
    when(() => searchApi.lookup([10, 20, 30]))
        .thenAnswer((_) async => [_podcast(30), _podcast(10), _podcast(20)]);

    final ranked = await repo.topPodcasts();

    expect(ranked.map((r) => (r.rank, r.podcast.id)).toList(), [
      (1, 10),
      (2, 20),
      (3, 30),
    ]);
  });

  test('topPodcasts descarta id que o lookup não resolveu (sem feedUrl)', () async {
    when(() => chartsApi.topPodcastIds(limit: any(named: 'limit')))
        .thenAnswer((_) async => [1, 2, 3]);
    when(() => searchApi.lookup([1, 2, 3]))
        .thenAnswer((_) async => [_podcast(1), _podcast(3)]);

    final ranked = await repo.topPodcasts();

    expect(ranked.map((r) => (r.rank, r.podcast.id)).toList(), [
      (1, 1),
      (3, 3),
    ]);
  });

  test('podcastsByGenre repassa o genreId e devolve só os podcasts', () async {
    when(() => chartsApi.topPodcastIds(limit: any(named: 'limit'), genreId: 1489))
        .thenAnswer((_) async => [7, 8]);
    when(() => searchApi.lookup([7, 8]))
        .thenAnswer((_) async => [_podcast(7), _podcast(8)]);

    final list = await repo.podcastsByGenre(1489);

    expect(list.map((p) => p.id).toList(), [7, 8]);
  });

  test('lista de ids vazia não chama o lookup', () async {
    when(() => chartsApi.topPodcastIds(limit: any(named: 'limit'))).thenAnswer((_) async => []);

    final ranked = await repo.topPodcasts();

    expect(ranked, isEmpty);
    verifyNever(() => searchApi.lookup(any()));
  });
}
