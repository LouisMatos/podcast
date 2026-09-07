import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:podcast_app/core/database/app_database.dart';

/// Cobre o bug que travou a tela no shimmer: `ADD COLUMN NOT NULL` com
/// default de expressão não é aceito pelo SQLite, então a migração v2→v3
/// falhava e o banco nunca abria. Agora as colunas novas são nullable.
void main() {
  test('migração v2→v3 adiciona colunas nullable e preserva os dados', () async {
    final file = File(
      '${Directory.systemTemp.path}/mig_v3_${DateTime.now().microsecondsSinceEpoch}.db',
    );
    addTearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    // Schema v2 na mão (o essencial pras 2 tabelas que a migração toca).
    final raw = sqlite3.open(file.path);
    raw.execute('''
      CREATE TABLE subscriptions (
        id INTEGER NOT NULL PRIMARY KEY, title TEXT NOT NULL, author TEXT NOT NULL,
        feed_url TEXT NOT NULL, artwork_url TEXT, genre TEXT,
        episode_count INTEGER NOT NULL DEFAULT 0, subscribed_at INTEGER NOT NULL DEFAULT 0);
      CREATE TABLE episode_cache (
        podcast_id INTEGER NOT NULL REFERENCES subscriptions (id) ON DELETE CASCADE,
        guid TEXT NOT NULL, title TEXT NOT NULL, audio_url TEXT NOT NULL,
        description TEXT, image_url TEXT, duration_seconds INTEGER, published_at INTEGER,
        PRIMARY KEY (podcast_id, guid));
      CREATE TABLE playback_progress (
        podcast_id INTEGER NOT NULL REFERENCES subscriptions (id) ON DELETE CASCADE,
        episode_guid TEXT NOT NULL, position_seconds INTEGER NOT NULL DEFAULT 0,
        completed INTEGER NOT NULL DEFAULT 0, updated_at INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (podcast_id, episode_guid));
      CREATE TABLE downloads (
        podcast_id INTEGER NOT NULL REFERENCES subscriptions (id) ON DELETE CASCADE,
        episode_guid TEXT NOT NULL, task_id TEXT, local_path TEXT,
        status TEXT NOT NULL DEFAULT 'queued', progress INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (podcast_id, episode_guid));
    ''');
    raw.execute("INSERT INTO subscriptions (id, title, author, feed_url) VALUES (1, 'P', 'A', 'u')");
    raw.execute(
      'INSERT INTO episode_cache (podcast_id, guid, title, audio_url, published_at) '
      "VALUES (1, 'g1', 'E1', 'a1', 1700000000)",
    );
    raw.execute('PRAGMA user_version = 2');
    raw.close();

    // Abrir com o AppDatabase dispara onUpgrade(2 -> 3).
    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    // Query que toca `episode_cache.added_at` — se a migração tivesse
    // falhado, isto explodiria (ou o banco nem abriria).
    final rows = await db.customSelect(
      'SELECT guid, added_at FROM episode_cache',
    ).get();
    expect(rows.map((r) => r.data['guid']), ['g1']);
    // backfill: added_at recebeu o published_at do episódio existente
    expect(rows.single.data['added_at'], 1700000000);

    // Abrir com o schema atual roda v2→3→4 em sequência.
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 5);

    final subCols = await db
        .customSelect("SELECT name FROM pragma_table_info('subscriptions')")
        .get();
    expect(subCols.map((r) => r.data['name']), contains('last_refreshed_at'));
  });
}
