import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:podcast_app/core/database/app_database.dart';

/// v6 → v7 (Fase 17): tabela nova `listen_history` (sem FK — sobrevive a
/// desassinar o podcast). Nenhuma coluna nova em tabela existente.
void main() {
  test('migração v6→v7 cria listen_history e preserva o dado antigo', () async {
    final file = File(
      '${Directory.systemTemp.path}/mig_v7_${DateTime.now().microsecondsSinceEpoch}.db',
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
        last_refreshed_at INTEGER,
        auto_download TEXT NOT NULL DEFAULT 'never',
        auto_download_limit INTEGER NOT NULL DEFAULT 3,
        auto_delete_played_days INTEGER NOT NULL DEFAULT 0,
        playback_speed_override REAL);
      CREATE TABLE episode_cache (
        podcast_id INTEGER NOT NULL REFERENCES subscriptions (id) ON DELETE CASCADE,
        guid TEXT NOT NULL, title TEXT NOT NULL, audio_url TEXT NOT NULL,
        description TEXT, image_url TEXT, duration_seconds INTEGER, published_at INTEGER,
        added_at INTEGER, archived INTEGER NOT NULL DEFAULT 0,
        season_number INTEGER, episode_number INTEGER, episode_type TEXT, link TEXT,
        chapters_url TEXT,
        PRIMARY KEY (podcast_id, guid));
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
      CREATE TABLE chapters (
        podcast_id INTEGER NOT NULL, episode_guid TEXT NOT NULL, start_ms INTEGER NOT NULL,
        title TEXT NOT NULL, image_url TEXT,
        PRIMARY KEY (podcast_id, episode_guid, start_ms));
    ''');
    raw.execute("INSERT INTO subscriptions (id, title, author, feed_url) VALUES (1, 'P', 'A', 'u')");
    raw.execute(
      'INSERT INTO episode_cache (podcast_id, guid, title, audio_url, description) '
      "VALUES (1, 'g1', 'E1', 'a1', 'desc antiga')",
    );
    raw.execute('PRAGMA user_version = 6');
    raw.close();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    // Dado antigo sobrevive.
    final ep = await db
        .customSelect('SELECT guid, title, description FROM episode_cache')
        .getSingle();
    expect(ep.data['guid'], 'g1');
    expect(ep.data['description'], 'desc antiga');
    final sub = await db.customSelect('SELECT title FROM subscriptions').getSingle();
    expect(sub.data['title'], 'P');

    // `listen_history` existe e aceita escrita/leitura pelo drift.
    final day = DateTime(2026, 9, 8);
    await db.into(db.listenHistory).insert(
          ListenHistoryCompanion.insert(
            podcastId: 1,
            episodeGuid: 'g1',
            day: day,
            secondsListened: const Value(120),
          ),
        );
    final hist = await db.select(db.listenHistory).getSingle();
    expect(hist.podcastId, 1);
    expect(hist.episodeGuid, 'g1');
    expect(hist.day, day);
    expect(hist.secondsListened, 120);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, db.schemaVersion);
  });
}
