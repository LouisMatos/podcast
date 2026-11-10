import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/data/models/download_status.dart';
import 'package:podcast_app/data/repositories/download_repository.dart';

void main() {
  late AppDatabase db;
  late DownloadRepository repo;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = DownloadRepository(db);
    tempDir = await Directory.systemTemp.createTemp('download_repository_test');
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  Future<void> markComplete(String taskId, int podcastId, String guid, String localPath) async {
    await repo.enqueueRecord(podcastId: podcastId, episodeGuid: guid, taskId: taskId);
    await repo.updateByTaskId(
      taskId: taskId,
      status: DownloadStatus.complete,
      progress: 100,
      localPath: localPath,
    );
  }

  test('inclui só downloads cujo arquivo ainda existe em disco', () async {
    final alive = File('${tempDir.path}/alive.mp3')..writeAsStringSync('x');
    final deadPath = '${tempDir.path}/deleted.mp3';

    await markComplete('t1', 1, 'g-alive', alive.path);
    await markComplete('t2', 1, 'g-dead', deadPath);

    final paths = await repo.completedPathsForPodcast(1);

    expect(paths, {'g-alive': alive.path});
    expect(paths.containsKey('g-dead'), isFalse);
  });

  test('sem downloads completos devolve mapa vazio', () async {
    final paths = await repo.completedPathsForPodcast(1);
    expect(paths, isEmpty);
  });
}
