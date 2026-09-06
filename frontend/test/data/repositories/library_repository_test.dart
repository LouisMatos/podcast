import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';

void main() {
  late AppDatabase db;
  late LibraryRepository repo;

  const podcast = Podcast(id: 1, title: 'P', author: 'A', feedUrl: 'https://x/f.xml');

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LibraryRepository(db);
  });

  tearDown(() => db.close());

  test('watchProgressForPodcast reage a savePlaybackPosition', () async {
    await repo.subscribe(podcast, [
      Episode(guid: 'g1', title: 'E1', audioUrl: 'u1'),
      Episode(guid: 'g2', title: 'E2', audioUrl: 'u2'),
    ]);

    expect(await repo.watchProgressForPodcast(1).first, isEmpty);

    await repo.savePlaybackPosition(
      podcastId: 1,
      episodeGuid: 'g1',
      position: const Duration(seconds: 90),
      completed: false,
    );
    await repo.savePlaybackPosition(
      podcastId: 1,
      episodeGuid: 'g2',
      position: const Duration(seconds: 100),
      completed: true,
    );

    final map = await repo.watchProgressForPodcast(1).first;
    expect(map['g1'], (positionSeconds: 90, completed: false));
    expect(map['g2'], (positionSeconds: 100, completed: true));
  });

  test('watchDownloadedEpisodes só devolve episódio com download completo', () async {
    await repo.subscribe(podcast, [
      Episode(guid: 'g1', title: 'Baixado', audioUrl: 'u1'),
      Episode(guid: 'g2', title: 'Baixando', audioUrl: 'u2'),
      Episode(guid: 'g3', title: 'Nada', audioUrl: 'u3'),
    ]);

    await db.into(db.downloads).insert(DownloadsCompanion.insert(
          podcastId: 1,
          episodeGuid: 'g1',
          status: const Value('complete'),
          localPath: const Value('/tmp/g1.mp3'),
        ));
    await db.into(db.downloads).insert(DownloadsCompanion.insert(
          podcastId: 1,
          episodeGuid: 'g2',
          status: const Value('running'),
        ));

    final eps = await repo.watchDownloadedEpisodes(1).first;
    expect(eps.map((e) => e.guid), ['g1']);
  });
}
