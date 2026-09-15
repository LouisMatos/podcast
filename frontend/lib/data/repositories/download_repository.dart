import 'dart:io' show File;

import 'package:drift/drift.dart' show BooleanExpressionOperators, OrderingTerm, Value, innerJoin;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../models/download.dart';
import '../models/download_status.dart';
import '../models/downloaded_episode.dart';

part 'download_repository.g.dart';

/// Downloads de episódios. Um ViewModel nunca fala com `AppDatabase` nem
/// com `flutter_downloader` direto — só com este repositório e com o
/// `DownloadService` (que é quem chama os métodos de escrita daqui).
class DownloadRepository {
  DownloadRepository(this._db);

  final AppDatabase _db;

  /// Status de download de UM episódio — pro botão de download na lista
  /// de episódios e pro player decidir se toca o arquivo local.
  Stream<Download?> watchForEpisode(int podcastId, String episodeGuid) {
    final query = _db.select(_db.downloads)
      ..where((t) => t.podcastId.equals(podcastId) & t.episodeGuid.equals(episodeGuid));
    return query.watchSingleOrNull().map((row) => row == null ? null : _toDownload(row));
  }

  /// Todos os downloads, com título do episódio/podcast já resolvido —
  /// pra tela de Downloads.
  Stream<List<DownloadedEpisode>> watchAll() {
    final query = _db.select(_db.downloads).join([
      innerJoin(
        _db.episodeCache,
        _db.episodeCache.podcastId.equalsExp(_db.downloads.podcastId) &
            _db.episodeCache.guid.equalsExp(_db.downloads.episodeGuid),
      ),
      innerJoin(_db.subscriptions, _db.subscriptions.id.equalsExp(_db.downloads.podcastId)),
    ])
      ..orderBy([OrderingTerm.desc(_db.downloads.updatedAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final download = row.readTable(_db.downloads);
        final episode = row.readTable(_db.episodeCache);
        final podcast = row.readTable(_db.subscriptions);
        return DownloadedEpisode(
          podcastId: download.podcastId,
          episodeGuid: download.episodeGuid,
          episodeTitle: episode.title,
          podcastTitle: podcast.title,
          artworkUrl: episode.imageUrl ?? podcast.artworkUrl,
          localPath: download.localPath,
          status: _statusFromString(download.status),
          progress: download.progress,
        );
      }).toList();
    });
  }

  /// Caminho local de cada episódio já baixado de um podcast — usado pelo
  /// player pra tocar offline sempre que existir um arquivo, sem precisar
  /// consultar episódio por episódio.
  ///
  /// Confirma que o arquivo ainda existe em disco — reinstalar o app ou
  /// limpar o storage deixa a linha `complete` no banco mas o arquivo
  /// sumido; sem essa checagem o player recebia um path morto em vez de
  /// cair pro stream de rede.
  Future<Map<String, String>> completedPathsForPodcast(int podcastId) async {
    final query = _db.select(_db.downloads)
      ..where((t) => t.podcastId.equals(podcastId) & t.status.equals(DownloadStatus.complete.name));
    final rows = await query.get();
    return {
      for (final row in rows)
        if (row.localPath != null && File(row.localPath!).existsSync()) row.episodeGuid: row.localPath!,
    };
  }

  Future<void> enqueueRecord({
    required int podcastId,
    required String episodeGuid,
    required String taskId,
  }) {
    return _db.into(_db.downloads).insertOnConflictUpdate(
          DownloadsCompanion.insert(
            podcastId: podcastId,
            episodeGuid: episodeGuid,
            taskId: Value(taskId),
            status: Value(DownloadStatus.queued.name),
            progress: const Value(0),
            localPath: const Value(null),
          ),
        );
  }

  Future<void> updateByTaskId({
    required String taskId,
    required DownloadStatus status,
    required int progress,
    String? localPath,
  }) {
    return (_db.update(_db.downloads)..where((t) => t.taskId.equals(taskId))).write(
      DownloadsCompanion(
        status: Value(status.name),
        progress: Value(progress),
        localPath: localPath == null ? const Value.absent() : Value(localPath),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Downloads presos em não-terminal (`queued`/`running`/`paused`) — usado
  /// no boot pra reconciliar com o status real do `flutter_downloader`
  /// quando o app foi morto no meio de um download (o callback do isolate
  /// nunca chega, e a UI ficaria travada mostrando progresso pra sempre).
  Future<List<Download>> pendingRecords() async {
    final nonTerminal = [
      DownloadStatus.queued.name,
      DownloadStatus.running.name,
      DownloadStatus.paused.name,
    ];
    final query = _db.select(_db.downloads)..where((t) => t.status.isIn(nonTerminal));
    final rows = await query.get();
    return rows.map(_toDownload).toList();
  }

  Future<String?> taskIdFor(int podcastId, String episodeGuid) async {
    final query = _db.select(_db.downloads)
      ..where((t) => t.podcastId.equals(podcastId) & t.episodeGuid.equals(episodeGuid));
    final row = await query.getSingleOrNull();
    return row?.taskId;
  }

  Future<void> deleteRecord(int podcastId, String episodeGuid) {
    return (_db.delete(_db.downloads)
          ..where((t) => t.podcastId.equals(podcastId) & t.episodeGuid.equals(episodeGuid)))
        .go();
  }

  Download _toDownload(DownloadRow row) {
    return Download(
      podcastId: row.podcastId,
      episodeGuid: row.episodeGuid,
      taskId: row.taskId,
      localPath: row.localPath,
      status: _statusFromString(row.status),
      progress: row.progress,
    );
  }

  DownloadStatus _statusFromString(String value) {
    return DownloadStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => DownloadStatus.failed,
    );
  }
}

@Riverpod(keepAlive: true)
DownloadRepository downloadRepository(Ref ref) {
  return DownloadRepository(ref.watch(appDatabaseProvider));
}
