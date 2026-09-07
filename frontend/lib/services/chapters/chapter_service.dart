import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:drift/drift.dart'
    show BooleanExpressionOperators, InsertMode, OrderingTerm, Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/network/dio_client.dart';
import '../../data/models/chapter.dart';

part 'chapter_service.g.dart';

/// Capítulos de episódio (Fase 14). Baixa o JSON do podcast namespace
/// apontado por `Episode.chaptersUrl`, persiste em `chapters` e expõe a
/// lista ao vivo pro player.
///
/// Formato do JSON (jsonChapters.md do podcast-namespace):
/// `{ "version": "1.2.0", "chapters": [ { "startTime": 0, "title": "...",
/// "img": "..." } ] }` — `startTime` em segundos, podendo ser fracionário.
class ChapterService {
  ChapterService(this._dio, this._db);

  final Dio _dio;
  final AppDatabase _db;

  /// Garante que os capítulos deste episódio estão no banco. No-op se o
  /// episódio não declara capítulos ou se já foram baixados antes — o JSON
  /// é estático, não vale rebuscar a cada play.
  ///
  /// Falha de rede/parse é engolida: capítulo é enfeite, não pode derrubar a
  /// reprodução.
  Future<void> ensureChapters({
    required int podcastId,
    required String episodeGuid,
    required String? chaptersUrl,
  }) async {
    if (chaptersUrl == null || chaptersUrl.trim().isEmpty) return;

    final existing = await (_db.select(_db.chapters)
          ..where((t) => t.podcastId.equals(podcastId) & t.episodeGuid.equals(episodeGuid))
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return;

    final List<Chapter> chapters;
    try {
      // `ResponseType.plain` + `jsonDecode` na mão: vários hosts servem o
      // arquivo como `text/plain`/`application/octet-stream` e o decoder
      // automático do Dio devolveria String mesmo assim.
      final response = await _dio.get<String>(
        chaptersUrl,
        options: Options(responseType: ResponseType.plain),
      );
      final body = response.data;
      if (body == null || body.trim().isEmpty) return;
      chapters = parseJsonChapters(body);
    } catch (error) {
      developer.log('capítulos indisponíveis ($chaptersUrl): $error', name: 'ChapterService');
      return;
    }

    if (chapters.isEmpty) return;

    await _db.batch((batch) {
      batch.insertAll(
        _db.chapters,
        [
          for (final chapter in chapters)
            ChaptersCompanion.insert(
              podcastId: podcastId,
              episodeGuid: episodeGuid,
              startMs: chapter.start.inMilliseconds,
              title: chapter.title,
              imageUrl: Value(chapter.imageUrl),
            ),
        ],
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Capítulos de um episódio, ao vivo e em ordem de início. Emite `[]`
  /// enquanto nada foi baixado.
  Stream<List<Chapter>> watchChapters(int podcastId, String episodeGuid) {
    final query = _db.select(_db.chapters)
      ..where((t) => t.podcastId.equals(podcastId) & t.episodeGuid.equals(episodeGuid))
      ..orderBy([(t) => OrderingTerm.asc(t.startMs)]);
    return query.watch().map(
          (rows) => [
            for (final row in rows)
              Chapter(
                start: Duration(milliseconds: row.startMs),
                title: row.title,
                imageUrl: row.imageUrl,
              ),
          ],
        );
  }
}

/// JSON cru → capítulos ordenados. Entrada sem `title` ou sem `startTime`
/// numérico é descartada (o formato deixa os dois obrigatórios, mas feed
/// mente). Público pra ser testável sem rede.
List<Chapter> parseJsonChapters(String body) {
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic>) return const [];
  final raw = decoded['chapters'];
  if (raw is! List) return const [];

  final chapters = <Chapter>[];
  for (final entry in raw) {
    if (entry is! Map) continue;
    final startTime = entry['startTime'];
    final title = entry['title'];
    if (startTime is! num || title is! String || title.trim().isEmpty) continue;
    final img = entry['img'];
    chapters.add(
      Chapter(
        start: Duration(milliseconds: (startTime * 1000).round()),
        title: title.trim(),
        imageUrl: (img is String && img.trim().isNotEmpty) ? img.trim() : null,
      ),
    );
  }
  chapters.sort((a, b) => a.start.compareTo(b.start));
  return chapters;
}

/// `keepAlive`: só depende de outros `keepAlive` (Dio e banco), e o player
/// vive fora da árvore de widgets.
@Riverpod(keepAlive: true)
ChapterService chapterService(Ref ref) {
  return ChapterService(ref.watch(dioClientProvider), ref.watch(appDatabaseProvider));
}
