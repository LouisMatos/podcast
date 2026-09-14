import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/database/app_database.dart';

void main() {
  test('instalação nova (onCreate) já tem queryCache utilizável', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.into(db.queryCache).insert(
          QueryCacheCompanion.insert(
            cacheKey: 'podcast_search:cafe',
            category: 'podcast_search',
            payloadJson: '[]',
          ),
        );

    final row = await (db.select(db.queryCache)
          ..where((t) => t.cacheKey.equals('podcast_search:cafe')))
        .getSingle();
    expect(row.category, 'podcast_search');
  });
}
