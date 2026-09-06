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
}
