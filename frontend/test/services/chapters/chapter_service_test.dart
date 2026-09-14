import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/data/models/chapter.dart';
import 'package:podcast_app/services/chapters/chapter_service.dart';

class _MockDio extends Mock implements Dio {}

const _url = 'https://example.com/chapters.json';

const _validJson = '''
{
  "version": "1.2.0",
  "chapters": [
    { "startTime": 120.5, "title": "Assunto 1" },
    { "startTime": 0, "title": "Intro", "img": "https://example.com/intro.png" },
    { "startTime": 300, "title": "  " },
    { "title": "sem startTime" },
    { "startTime": 600 }
  ]
}
''';

void main() {
  late AppDatabase db;
  late _MockDio dio;
  late ChapterService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dio = _MockDio();
    service = ChapterService(dio, db);
  });

  tearDown(() => db.close());

  void respondWith(String body) {
    when(() => dio.get<String>(
          any(),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer(
      (_) async => Response<String>(data: body, requestOptions: RequestOptions(path: _url)),
    );
  }

  Future<List<ChapterRow>> rows() =>
      (db.select(db.chapters)..orderBy([(t) => OrderingTerm.asc(t.startMs)])).get();

  test('JSON válido vira linhas ordenadas, com segundos convertidos em ms', () async {
    respondWith(_validJson);

    await service.ensureChapters(podcastId: 1, episodeGuid: 'g1', chaptersUrl: _url);

    final saved = await rows();
    expect(saved.map((r) => r.title), ['Intro', 'Assunto 1']);
    expect(saved.map((r) => r.startMs), [0, 120500]);
    expect(saved.first.imageUrl, 'https://example.com/intro.png');
    expect(saved.last.imageUrl, isNull);
  });

  test('chaptersUrl nulo é no-op (não toca a rede)', () async {
    await service.ensureChapters(podcastId: 1, episodeGuid: 'g1', chaptersUrl: null);

    verifyNever(() => dio.get<String>(
          any(),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        ));
    expect(await rows(), isEmpty);
  });

  test('segunda chamada não rebaixa o JSON', () async {
    respondWith(_validJson);

    await service.ensureChapters(podcastId: 1, episodeGuid: 'g1', chaptersUrl: _url);
    await service.ensureChapters(podcastId: 1, episodeGuid: 'g1', chaptersUrl: _url);

    verify(() => dio.get<String>(
          any(),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        )).called(1);
    expect((await rows()).length, 2);
  });

  test('erro de rede não lança e não grava nada', () async {
    when(() => dio.get<String>(
          any(),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        ))
        .thenThrow(DioException(requestOptions: RequestOptions(path: _url)));

    await service.ensureChapters(podcastId: 1, episodeGuid: 'g1', chaptersUrl: _url);

    expect(await rows(), isEmpty);
  });

  test('JSON inválido não lança e não grava nada', () async {
    respondWith('isso não é json');

    await service.ensureChapters(podcastId: 1, episodeGuid: 'g1', chaptersUrl: _url);

    expect(await rows(), isEmpty);
  });

  test('watchChapters emite ordenado e só do episódio pedido', () async {
    respondWith(_validJson);
    await service.ensureChapters(podcastId: 1, episodeGuid: 'g1', chaptersUrl: _url);
    await service.ensureChapters(podcastId: 1, episodeGuid: 'g2', chaptersUrl: _url);

    final chapters = await service.watchChapters(1, 'g1').first;
    expect(chapters, const [
      Chapter(
        start: Duration.zero,
        title: 'Intro',
        imageUrl: 'https://example.com/intro.png',
      ),
      Chapter(start: Duration(milliseconds: 120500), title: 'Assunto 1'),
    ]);
  });

  test('watchChapters emite vazio quando não há capítulos', () async {
    expect(await service.watchChapters(1, 'g1').first, isEmpty);
  });
}
