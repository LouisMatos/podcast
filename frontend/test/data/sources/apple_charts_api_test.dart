import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/sources/apple_charts_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late AppleChartsApi api;

  setUp(() {
    dio = _MockDio();
    api = AppleChartsApi(dio);
  });

  void stubBody(String body) {
    when(
      () => dio.get<String>(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer(
      (_) async => Response<String>(data: body, requestOptions: RequestOptions(path: '')),
    );
  }

  String? capturedUrl() {
    final call = verify(
      () => dio.get<String>(
        captureAny(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
        cancelToken: any(named: 'cancelToken'),
      ),
    );
    return call.captured.single as String?;
  }

  test('formato novo (Marketing Tools): extrai ids na ordem do ranking', () async {
    stubBody('''
{"feed": {"results": [
  {"id": "111", "name": "Primeiro"},
  {"id": "222", "name": "Segundo"},
  {"id": "333", "name": "Terceiro"}
]}}
''');

    final ids = await api.topPodcastIds(limit: 3);

    expect(ids, [111, 222, 333]);
    expect(capturedUrl(), contains('/br/podcasts/top/3/podcasts.json'));
  });

  test('formato legado (RSS por gênero): lê im:id e usa o endpoint com genre', () async {
    stubBody('''
{"feed": {"entry": [
  {"id": {"attributes": {"im:id": "900"}}},
  {"id": {"attributes": {"im:id": "901"}}}
]}}
''');

    final ids = await api.topPodcastIds(limit: 50, genreId: 1310);

    expect(ids, [900, 901]);
    expect(capturedUrl(), contains('genre=1310'));
  });

  test('corpo vazio devolve lista vazia', () async {
    stubBody('');
    expect(await api.topPodcastIds(), isEmpty);
  });
}
