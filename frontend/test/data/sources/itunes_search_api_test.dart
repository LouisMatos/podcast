import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/sources/itunes_search_api.dart';

class _MockDio extends Mock implements Dio {}

const _endpoint = 'https://itunes.apple.com/search';

void main() {
  late _MockDio dio;
  late ItunesSearchApi api;

  setUp(() {
    dio = _MockDio();
    api = ItunesSearchApi(dio);
  });

  void stubBody(String body) {
    when(
      () => dio.get<String>(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => Response<String>(data: body, requestOptions: RequestOptions(path: _endpoint)));
  }

  test('decodifica manualmente mesmo com Content-Type text/javascript', () async {
    // A API real devolve texto puro, não application/json — o parser
    // automático do Dio não entraria em ação de qualquer forma, já que
    // pedimos ResponseType.plain; aqui simulamos exatamente esse body cru.
    stubBody('''
{
  "resultCount": 1,
  "results": [
    {
      "collectionId": 123,
      "collectionName": "Podcast de Teste",
      "artistName": "Autor Teste",
      "feedUrl": "https://example.com/feed.xml",
      "artworkUrl600": "https://example.com/capa600.png",
      "artworkUrl100": "https://example.com/capa100.png",
      "primaryGenreName": "Tecnologia",
      "trackCount": 42
    }
  ]
}
''');

    final podcasts = await api.search('teste');

    expect(podcasts, hasLength(1));
    final podcast = podcasts.single;
    expect(podcast.id, 123);
    expect(podcast.title, 'Podcast de Teste');
    expect(podcast.author, 'Autor Teste');
    expect(podcast.feedUrl, 'https://example.com/feed.xml');
    expect(podcast.genre, 'Tecnologia');
    expect(podcast.episodeCount, 42);
  });

  test('prefere artworkUrl600, cai pra artworkUrl100 quando não tem', () async {
    stubBody('''
{"results": [
  {"collectionId": 1, "collectionName": "A", "feedUrl": "https://x.com/a.xml", "artworkUrl600": "600.png", "artworkUrl100": "100.png"},
  {"collectionId": 2, "collectionName": "B", "feedUrl": "https://x.com/b.xml", "artworkUrl100": "100.png"}
]}
''');

    final podcasts = await api.search('teste');

    expect(podcasts.firstWhere((p) => p.id == 1).artworkUrl, '600.png');
    expect(podcasts.firstWhere((p) => p.id == 2).artworkUrl, '100.png');
  });

  test('descarta resultado sem feedUrl (não dá pra assinar sem RSS)', () async {
    stubBody('''
{"results": [
  {"collectionId": 1, "collectionName": "Sem feed"},
  {"collectionId": 2, "collectionName": "Com feed", "feedUrl": "https://x.com/b.xml"}
]}
''');

    final podcasts = await api.search('teste');

    expect(podcasts, hasLength(1));
    expect(podcasts.single.id, 2);
  });

  test('resposta sem campo results devolve lista vazia', () async {
    stubBody('{"resultCount": 0}');
    final podcasts = await api.search('nada');
    expect(podcasts, isEmpty);
  });

  group('searchEpisodes', () {
    // Resposta real de entity=podcastEpisode: um resultado completo e um sem
    // episodeUrl (deve ser descartado). Content-Type text/javascript é
    // tolerado porque pedimos ResponseType.plain e decodificamos na mão.
    const fixture = '''
{
  "resultCount": 2,
  "results": [
    {
      "wrapperType": "podcastEpisode",
      "collectionId": 999,
      "collectionName": "Podcast Dono",
      "feedUrl": "https://example.com/feed.xml",
      "trackId": 555,
      "trackName": "Episódio Válido",
      "episodeGuid": "guid-abc",
      "episodeUrl": "https://example.com/ep1.mp3",
      "description": "Descrição longa",
      "shortDescription": "curta",
      "trackTimeMillis": 1830000,
      "releaseDate": "2026-01-15T12:00:00Z",
      "artworkUrl600": "https://example.com/a600.png",
      "artworkUrl160": "https://example.com/a160.png"
    },
    {
      "wrapperType": "podcastEpisode",
      "collectionId": 999,
      "collectionName": "Podcast Dono",
      "trackId": 556,
      "trackName": "Sem Áudio",
      "episodeGuid": "guid-def"
    }
  ]
}
''';

    test('parseia campos e descarta episódio sem episodeUrl', () async {
      stubBody(fixture);

      final results = await api.searchEpisodes('teste');

      expect(results, hasLength(1));
      final r = results.single;
      expect(r.collectionId, 999);
      expect(r.collectionName, 'Podcast Dono');
      expect(r.feedUrl, 'https://example.com/feed.xml');
      expect(r.podcastArtworkUrl, 'https://example.com/a600.png');

      final ep = r.episode;
      expect(ep.guid, 'guid-abc');
      expect(ep.title, 'Episódio Válido');
      expect(ep.audioUrl, 'https://example.com/ep1.mp3');
      expect(ep.description, 'Descrição longa');
      expect(ep.imageUrl, 'https://example.com/a600.png');
      expect(ep.duration, const Duration(milliseconds: 1830000));
      expect(ep.publishedAt, DateTime.utc(2026, 1, 15, 12));
    });

    test('guid sintético a partir do trackId quando não há episodeGuid', () async {
      stubBody('''
{"results": [
  {"collectionId": 1, "collectionName": "P", "trackId": 42, "trackName": "T", "episodeUrl": "https://x.com/e.mp3"}
]}
''');

      final results = await api.searchEpisodes('teste');

      expect(results.single.episode.guid, 'itunes:42');
    });

    test('cai pra shortDescription e artworkUrl160/60', () async {
      stubBody('''
{"results": [
  {"collectionId": 1, "collectionName": "P", "trackId": 7, "trackName": "T",
   "episodeUrl": "https://x.com/e.mp3", "shortDescription": "só a curta",
   "artworkUrl60": "https://x.com/a60.png"}
]}
''');

      final r = (await api.searchEpisodes('teste')).single;
      expect(r.episode.description, 'só a curta');
      expect(r.episode.imageUrl, 'https://x.com/a60.png');
      expect(r.podcastArtworkUrl, 'https://x.com/a60.png');
    });

    test('resposta sem results devolve lista vazia', () async {
      stubBody('{"resultCount": 0}');
      expect(await api.searchEpisodes('nada'), isEmpty);
    });
  });
}
