import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/data/models/episode.dart';
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
  late AppDatabase db;
  late PodcastRepository repo;

  setUp(() {
    searchApi = _MockSearchApi();
    feedParser = _MockFeedParser();
    chartsApi = _MockChartsApi();
    db = AppDatabase(NativeDatabase.memory());
    repo = PodcastRepository(searchApi: searchApi, feedParser: feedParser, chartsApi: chartsApi, db: db);
  });

  tearDown(() => db.close());

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

  group('cache-aside (Fase 27.2)', () {
    test('search sem cache prévio: sucesso escreve no QueryCache', () async {
      when(() => searchApi.search('cafe')).thenAnswer((_) async => [_podcast(1)]);

      expect(await repo.cachedSearchResults('cafe'), isNull);

      final result = await repo.search('cafe');

      expect(result.map((p) => p.id), [1]);
      final cached = await repo.cachedSearchResults('cafe');
      expect(cached!.map((p) => p.id), [1]);
    });

    test('search: chave normaliza espaço/maiúscula', () async {
      when(() => searchApi.search('Café ')).thenAnswer((_) async => [_podcast(1)]);
      await repo.search('Café ');

      expect(await repo.cachedSearchResults('café'), isNotNull);
    });

    test('search falha com cache prévio: devolve cache, não relança', () async {
      when(() => searchApi.search('cafe')).thenAnswer((_) async => [_podcast(1)]);
      await repo.search('cafe');

      when(() => searchApi.search('cafe')).thenThrow(Exception('rede caiu'));

      final result = await repo.search('cafe');
      expect(result.map((p) => p.id), [1]);
    });

    test('search falha sem cache prévio: relança', () async {
      when(() => searchApi.search('cafe')).thenThrow(Exception('rede caiu'));

      expect(() => repo.search('cafe'), throwsA(isA<Exception>()));
    });

    test('episodesFor cacheia e cai pro cache em falha (cobre podcast não-assinado)', () async {
      final podcast = _podcast(1);
      final ep = Episode(guid: 'g1', title: 'E1', audioUrl: 'a1');
      when(() => feedParser.fetchEpisodes(podcast.feedUrl)).thenAnswer((_) async => [ep]);

      expect(await repo.cachedEpisodesFor(podcast), isNull);
      await repo.episodesFor(podcast);
      expect((await repo.cachedEpisodesFor(podcast))!.single.guid, 'g1');

      when(() => feedParser.fetchEpisodes(podcast.feedUrl)).thenThrow(Exception('offline'));
      final episodes = await repo.episodesFor(podcast);
      expect(episodes.single.guid, 'g1');
    });

    test('topPodcasts cacheia e cai pro cache em falha', () async {
      when(() => chartsApi.topPodcastIds(limit: any(named: 'limit')))
          .thenAnswer((_) async => [10]);
      when(() => searchApi.lookup([10])).thenAnswer((_) async => [_podcast(10)]);
      await repo.topPodcasts();

      expect((await repo.cachedTopPodcasts())!.single.podcast.id, 10);

      when(() => chartsApi.topPodcastIds(limit: any(named: 'limit'))).thenThrow(Exception('offline'));
      final ranked = await repo.topPodcasts();
      expect(ranked.single.podcast.id, 10);
    });
  });
}
