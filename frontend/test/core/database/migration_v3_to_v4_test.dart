import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:podcast_app/core/database/app_database.dart';

/// v3 → v4 (Fase 12): cria a tabela `queue_items` da fila persistente sem
/// tocar em nada que já existe.
void main() {
  test('migração v3→v4 cria queue_items e preserva os dados', () async {
    final file = File(
      '${Directory.systemTemp.path}/mig_v4_${DateTime.now().microsecondsSinceEpoch}.db',
    );
    addTearDown(() {
      if (file.existsSync()) file.deleteSync();
    });

    final raw = sqlite3.open(file.path);
    raw.execute('''
      CREATE TABLE subscriptions (
        id INTEGER NOT NULL PRIMARY KEY, title TEXT NOT NULL, author TEXT NOT NULL,
        feed_url TEXT NOT NULL, artwork_url TEXT, genre TEXT,
        episode_count INTEGER NOT NULL DEFAULT 0, subscribed_at INTEGER NOT NULL DEFAULT 0,
        last_refreshed_at INTEGER);
      CREATE TABLE episode_cache (
        podcast_id INTEGER NOT NULL REFERENCES subscriptions (id) ON DELETE CASCADE,
        guid TEXT NOT NULL, title TEXT NOT NULL, audio_url TEXT NOT NULL,
        description TEXT, image_url TEXT, duration_seconds INTEGER, published_at INTEGER,
        added_at INTEGER, PRIMARY KEY (podcast_id, guid));
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
      'INSERT INTO episode_cache (podcast_id, guid, title, audio_url) '
      "VALUES (1, 'g1', 'E1', 'a1')",
    );
    raw.execute('PRAGMA user_version = 3');
    raw.close();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    // A tabela nova existe e é usável.
    await db.customStatement(
      'INSERT INTO queue_items (position, podcast_id, podcast_title, podcast_author, '
      'podcast_feed_url, episode_guid, episode_title, audio_url) '
      "VALUES (0, 1, 'P', 'A', 'u', 'g1', 'E1', 'a1')",
    );
    final queued = await db.customSelect('SELECT episode_guid FROM queue_items').get();
    expect(queued.map((r) => r.data['episode_guid']), ['g1']);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 4);

    // dado antigo intacto
    final eps = await db.customSelect('SELECT guid FROM episode_cache').get();
    expect(eps.map((r) => r.data['guid']), ['g1']);
  });
}
