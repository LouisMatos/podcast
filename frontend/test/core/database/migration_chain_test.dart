import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:podcast_app/core/database/app_database.dart';

/// Cadeia inteira: monta o schema **v2** na mão (o mais antigo que os testes
/// cobrem) e abre com o `AppDatabase` atual — o `onUpgrade` roda v2→v7 de uma
/// vez. Confere que todas as tabelas/colunas novas nasceram e que um dado
/// gravado no v2 sobrevive até o v7.
void main() {
  test('v2 → v7 numa abertura só: schema completo + dado preservado', () async {
    final file = File(
      '${Directory.systemTemp.path}/mig_chain_${DateTime.now().microsecondsSinceEpoch}.db',
    );
    addTearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    // Schema v2 na mão (igual ao de migration_v2_to_v3_test).
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

    // Abrir com o AppDatabase dispara onUpgrade(2 -> 7) em cascata.
    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    // 1) user_version foi pra versão atual do schema.
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, db.schemaVersion);
    expect(db.schemaVersion, 7);

    // 2) Tabelas novas das fases 12/14/17 existem.
    final tables = (await db
            .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
            .get())
        .map((r) => r.data['name'] as String)
        .toSet();
    expect(tables, containsAll(['queue_items', 'chapters', 'listen_history']));

    // 3) Colunas novas de episode_cache (v3, v5, v6).
    final epCols = (await db
            .customSelect("SELECT name FROM pragma_table_info('episode_cache')")
            .get())
        .map((r) => r.data['name'] as String)
        .toSet();
    expect(
      epCols,
      containsAll([
        'added_at',
        'archived',
        'season_number',
        'episode_number',
        'episode_type',
        'link',
        'chapters_url',
      ]),
    );

    // 4) Colunas novas de subscriptions (v3, v5).
    final subCols = (await db
            .customSelect("SELECT name FROM pragma_table_info('subscriptions')")
            .get())
        .map((r) => r.data['name'] as String)
        .toSet();
    expect(
      subCols,
      containsAll([
        'last_refreshed_at',
        'auto_download',
        'auto_download_limit',
        'auto_delete_played_days',
        'playback_speed_override',
      ]),
    );

    // 5) O dado do v2 sobreviveu, e o backfill do v2→v3 preencheu added_at.
    final ep = await db
        .customSelect('SELECT guid, title, published_at, added_at FROM episode_cache')
        .getSingle();
    expect(ep.data['guid'], 'g1');
    expect(ep.data['title'], 'E1');
    expect(ep.data['added_at'], 1700000000);

    // 6) As tabelas novas aceitam escrita/leitura pelo drift já no schema atual.
    await db.into(db.listenHistory).insert(
          ListenHistoryCompanion.insert(
            podcastId: 1,
            episodeGuid: 'g1',
            day: DateTime(2026, 9, 8),
            secondsListened: const Value(90),
          ),
        );
    expect((await db.select(db.listenHistory).getSingle()).secondsListened, 90);
  });
}
