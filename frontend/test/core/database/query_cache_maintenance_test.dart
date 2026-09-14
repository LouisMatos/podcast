import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/core/database/query_cache_maintenance.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> insertRow(String key, DateTime fetchedAt) {
    return db.into(db.queryCache).insert(
          QueryCacheCompanion.insert(
            cacheKey: key,
            category: 'podcast_search',
            payloadJson: '[]',
            fetchedAt: Value(fetchedAt),
          ),
        );
  }

  test('remove só entradas mais velhas que maxAge, preserva o resto', () async {
    final now = DateTime.now();
    await insertRow('velho', now.subtract(const Duration(days: 31)));
    await insertRow('recente', now.subtract(const Duration(days: 1)));

    final removed = await pruneStaleQueryCache(db, maxAge: const Duration(days: 30));

    expect(removed, 1);
    final remaining = await db.select(db.queryCache).get();
    expect(remaining.map((r) => r.cacheKey), ['recente']);
  });

  test('cache vazio: não remove nada, não lança', () async {
    final removed = await pruneStaleQueryCache(db);
    expect(removed, 0);
  });
}
