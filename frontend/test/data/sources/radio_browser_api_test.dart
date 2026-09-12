import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/sources/radio_browser_api.dart';

class _MockDio extends Mock implements Dio {}

const _endpoint = 'https://de1.api.radio-browser.info/json/stations/bycountrycodeexact/BR';

void main() {
  late _MockDio dio;
  late RadioBrowserApi api;

  setUp(() {
    dio = _MockDio();
    api = RadioBrowserApi(dio);
  });

  void stubBody(List<dynamic> body) {
    when(() => dio.get<List<dynamic>>(any())).thenAnswer(
      (_) async => Response<List<dynamic>>(data: body, requestOptions: RequestOptions(path: _endpoint)),
    );
  }

  test('parseia estação válida e mapeia campos', () async {
    stubBody([
      {
        'stationuuid': 'abc-123',
        'name': 'Rádio Teste',
        'url_resolved': 'https://stream.example.com/live',
        'favicon': 'https://example.com/logo.png',
        'tags': 'pop,rock',
        'state': 'SP',
        'lastcheckok': 1,
      },
    ]);

    final stations = await api.fetchBrStations();

    expect(stations, hasLength(1));
    final s = stations.single;
    expect(s.id, 'abc-123');
    expect(s.name, 'Rádio Teste');
    expect(s.streamUrl, 'https://stream.example.com/live');
    expect(s.logoUrl, 'https://example.com/logo.png');
    expect(s.genre, 'pop,rock');
    expect(s.state, 'SP');
  });

  test('descarta estação com lastcheckok != 1 (stream fora do ar)', () async {
    stubBody([
      {
        'stationuuid': 'dead-1',
        'name': 'Morta',
        'url_resolved': 'https://stream.example.com/dead',
        'lastcheckok': 0,
      },
      {
        'stationuuid': 'ok-1',
        'name': 'Viva',
        'url_resolved': 'https://stream.example.com/ok',
        'lastcheckok': 1,
      },
    ]);

    final stations = await api.fetchBrStations();

    expect(stations, hasLength(1));
    expect(stations.single.id, 'ok-1');
  });

  test('descarta estação sem url_resolved', () async {
    stubBody([
      {'stationuuid': 'no-url', 'name': 'Sem URL', 'url_resolved': '', 'lastcheckok': 1},
    ]);

    expect(await api.fetchBrStations(), isEmpty);
  });

  test('campos opcionais vazios viram null', () async {
    stubBody([
      {
        'stationuuid': 'x',
        'name': 'X',
        'url_resolved': 'https://x.com/live',
        'favicon': '',
        'tags': '',
        'state': '',
        'lastcheckok': 1,
      },
    ]);

    final s = (await api.fetchBrStations()).single;
    expect(s.logoUrl, isNull);
    expect(s.genre, isNull);
    expect(s.state, isNull);
  });

  test('resposta vazia devolve lista vazia', () async {
    stubBody([]);
    expect(await api.fetchBrStations(), isEmpty);
  });
}
