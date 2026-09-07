import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:podcast_app/core/database/app_database.dart';

/// v4 → v5 (Fase 13): `episode_cache.archived` + colunas de gestão
/// automática em `subscriptions`. Todos os defaults são constantes.
void main() {
  test('migração v4→v5 adiciona colunas com default constante, dados intactos', () async {
    final file = File(
      '${Directory.systemTemp.path}/mig_v5_${DateTime.now().microsecondsSinceEpoch}.db',
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
        podcast_id INTEGER NOT NULL, episode_guid TEXT NOT NULL,
        position_seconds INTEGER NOT NULL DEFAULT 0, completed INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (podcast_id, episode_guid));
      CREATE TABLE downloads (
        podcast_id INTEGER NOT NULL, episode_guid TEXT NOT NULL, task_id TEXT, local_path TEXT,
        status TEXT NOT NULL DEFAULT 'queued', progress INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (podcast_id, episode_guid));
      CREATE TABLE queue_items (
        position INTEGER NOT NULL, podcast_id INTEGER NOT NULL, podcast_title TEXT NOT NULL,
        podcast_author TEXT NOT NULL, podcast_feed_url TEXT NOT NULL, podcast_artwork_url TEXT,
        episode_guid TEXT NOT NULL, episode_title TEXT NOT NULL, audio_url TEXT NOT NULL,
        episode_image_url TEXT, episode_duration_seconds INTEGER, episode_published_at INTEGER,
        added_at INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (podcast_id, episode_guid));
    ''');
    raw.execute("INSERT INTO subscriptions (id, title, author, feed_url) VALUES (1, 'P', 'A', 'u')");
    raw.execute(
      "INSERT INTO episode_cache (podcast_id, guid, title, audio_url) VALUES (1, 'g1', 'E1', 'a1')",
    );
    raw.execute('PRAGMA user_version = 4');
    raw.close();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    final ep = await db.customSelect('SELECT guid, archived FROM episode_cache').getSingle();
    expect(ep.data['guid'], 'g1');
    expect(ep.data['archived'], 0);

    final sub = await db
        .customSelect('SELECT auto_download, auto_download_limit, auto_delete_played_days, '
            'playback_speed_override FROM subscriptions')
        .getSingle();
    expect(sub.data['auto_download'], 'never');
    expect(sub.data['auto_download_limit'], 3);
    expect(sub.data['auto_delete_played_days'], 0);
    expect(sub.data['playback_speed_override'], null);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, 5);
  });
}
