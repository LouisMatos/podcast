import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/data/models/radio_station.dart';
import 'package:podcast_app/data/repositories/radio_repository.dart';
import 'package:podcast_app/data/sources/radio_browser_api.dart';

class _MockRadioBrowserApi extends Mock implements RadioBrowserApi {}

RadioStation _station(String id) =>
    RadioStation(id: id, name: 'R$id', streamUrl: 'https://x/$id.mp3');

void main() {
  late _MockRadioBrowserApi api;
  late AppDatabase db;
  late RadioRepository repo;

  setUp(() {
    api = _MockRadioBrowserApi();
    db = AppDatabase(NativeDatabase.memory());
    repo = RadioRepository(api: api, db: db);
  });

  tearDown(() => db.close());

  test('sem cache prévio: sucesso escreve no QueryCache', () async {
    when(() => api.fetchBrStations()).thenAnswer((_) async => [_station('1')]);

    expect(await repo.cachedBrStations(), isNull);

    final result = await repo.brStations();

    expect(result.map((s) => s.id), ['1']);
    expect((await repo.cachedBrStations())!.map((s) => s.id), ['1']);
  });

  test('falha com cache prévio: devolve cache, não relança', () async {
    when(() => api.fetchBrStations()).thenAnswer((_) async => [_station('1')]);
    await repo.brStations();

    when(() => api.fetchBrStations()).thenThrow(Exception('rede caiu'));

    final result = await repo.brStations();
    expect(result.map((s) => s.id), ['1']);
  });

  test('falha sem cache prévio: relança', () async {
    when(() => api.fetchBrStations()).thenThrow(Exception('rede caiu'));

    expect(() => repo.brStations(), throwsA(isA<Exception>()));
  });
}
