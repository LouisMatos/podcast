import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:sqlite3/sqlite3.dart';
import 'package:podcast_app/core/database/app_database.dart';

/// v5 → v6 (Fase 14): metadados avançados em `episode_cache` (todos
/// nullable, senão o `ADD COLUMN` trava) + tabela `chapters`.
void main() {
  test('migração v5→v6 adiciona colunas nullable e a tabela chapters', () async {
    final file = File(
      '${Directory.systemTemp.path}/mig_v6_${DateTime.now().microsecondsSinceEpoch}.db',
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
    ''');
    raw.execute("INSERT INTO subscriptions (id, title, author, feed_url) VALUES (1, 'P', 'A', 'u')");
    raw.execute(
      'INSERT INTO episode_cache (podcast_id, guid, title, audio_url, description) '
      "VALUES (1, 'g1', 'E1', 'a1', 'desc antiga')",
    );
    raw.execute('PRAGMA user_version = 5');
    raw.close();

    final db = AppDatabase(NativeDatabase(file));
    addTearDown(db.close);

    // Dado antigo sobrevive e as colunas novas vêm nulas.
    final ep = await db
        .customSelect('SELECT guid, title, description, archived, season_number, '
            'episode_number, episode_type, link, chapters_url FROM episode_cache')
        .getSingle();
    expect(ep.data['guid'], 'g1');
    expect(ep.data['title'], 'E1');
    expect(ep.data['description'], 'desc antiga');
    expect(ep.data['archived'], 0);
    expect(ep.data['season_number'], isNull);
    expect(ep.data['episode_number'], isNull);
    expect(ep.data['episode_type'], isNull);
    expect(ep.data['link'], isNull);
    expect(ep.data['chapters_url'], isNull);

    // Assinatura intacta (colunas da v5 preservadas).
    final sub = await db.customSelect('SELECT title, auto_download FROM subscriptions').getSingle();
    expect(sub.data['title'], 'P');
    expect(sub.data['auto_download'], 'never');

    // `chapters` existe e aceita escrita/leitura pelo drift.
    await db.into(db.chapters).insert(
          ChaptersCompanion.insert(
            podcastId: 1,
            episodeGuid: 'g1',
            startMs: 1500,
            title: 'Intro',
          ),
        );
    final chapter = await db.select(db.chapters).getSingle();
    expect(chapter.startMs, 1500);
    expect(chapter.title, 'Intro');
    expect(chapter.imageUrl, isNull);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.first, db.schemaVersion);
  });
}
