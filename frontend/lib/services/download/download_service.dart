import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/download_status.dart';
import '../../data/models/episode.dart';
import '../../data/repositories/download_repository.dart';

part 'download_service.g.dart';

/// Nome do port usado pra falar com o isolate de background do
/// `flutter_downloader`. Precisa bater com o usado em [downloadCallback].
const downloadPortName = 'podcast_app_download_events';

/// Ponte com o `flutter_downloader` — o único lugar do app que sabe que
/// esse pacote existe. Toda mudança de status/progresso vira uma escrita
/// no drift via [DownloadRepository]; a UI só observa o repositório.
class DownloadService {
  DownloadService(this._repository) {
    _bind();
  }

  final DownloadRepository _repository;
  final ReceivePort _port = ReceivePort();

  void _bind() {
    var ok = IsolateNameServer.registerPortWithName(_port.sendPort, downloadPortName);
    if (!ok) {
      IsolateNameServer.removePortNameMapping(downloadPortName);
      ok = IsolateNameServer.registerPortWithName(_port.sendPort, downloadPortName);
    }
    _port.listen(_onIsolateMessage);
  }

  Future<void> _onIsolateMessage(dynamic message) async {
    final data = message as List<dynamic>;
    final taskId = data[0] as String;
    final status = DownloadTaskStatus.fromInt(data[1] as int);
    final progress = data[2] as int;

    String? localPath;
    if (status == DownloadTaskStatus.complete) {
      localPath = await _resolveLocalPath(taskId);
    }

    await _repository.updateByTaskId(
      taskId: taskId,
      status: _toDomainStatus(status),
      progress: progress,
      localPath: localPath,
    );
  }

  /// O `flutter_downloader` guarda o nome de arquivo final (que pode ter
  /// sido ajustado pra evitar conflito) na própria tarefa — mais seguro
  /// do que recalcular o nome na mão.
  Future<String?> _resolveLocalPath(String taskId) async {
    final tasks = await FlutterDownloader.loadTasks();
    for (final task in tasks ?? const <DownloadTask>[]) {
      if (task.taskId == taskId && task.filename != null) {
        return '${task.savedDir}/${task.filename}';
      }
    }
    return null;
  }

  DownloadStatus _toDomainStatus(DownloadTaskStatus status) {
    return switch (status) {
      DownloadTaskStatus.undefined => DownloadStatus.failed,
      DownloadTaskStatus.enqueued => DownloadStatus.queued,
      DownloadTaskStatus.running => DownloadStatus.running,
      DownloadTaskStatus.complete => DownloadStatus.complete,
      DownloadTaskStatus.failed => DownloadStatus.failed,
      DownloadTaskStatus.canceled => DownloadStatus.canceled,
      DownloadTaskStatus.paused => DownloadStatus.paused,
    };
  }

  /// Baixa [episode] pra ouvir offline. Cada podcast tem sua própria
  /// subpasta — facilita apagar tudo de um podcast só de uma vez, se um
  /// dia precisar.
  Future<void> download({required int podcastId, required Episode episode}) async {
    final dir = await _directoryFor(podcastId);
    final fileName = _fileNameFor(episode);

    final taskId = await FlutterDownloader.enqueue(
      url: episode.audioUrl,
      savedDir: dir.path,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: false,
    );
    if (taskId == null) return;

    await _repository.enqueueRecord(podcastId: podcastId, episodeGuid: episode.guid, taskId: taskId);
  }

  /// Chamado no boot: se o app foi morto no meio de um download, o callback
  /// do isolate do `flutter_downloader` nunca chegou e a linha fica presa em
  /// `queued`/`running`/`paused` no drift pra sempre, mesmo reabrindo o app.
  /// O plugin mantém seu próprio registro de tarefas (sobrevive ao restart);
  /// aqui a gente sincroniza o status real de volta pro drift.
  Future<void> reconcileStuckDownloads() async {
    final pending = await _repository.pendingRecords();
    if (pending.isEmpty) return;

    final tasks = await FlutterDownloader.loadTasks() ?? const <DownloadTask>[];
    final taskById = {for (final task in tasks) task.taskId: task};

    for (final download in pending) {
      final taskId = download.taskId;
      if (taskId == null) continue;
      final task = taskById[taskId];
      if (task == null) {
        // Tarefa não existe mais nem no plugin — sem como retomar.
        await _repository.updateByTaskId(
          taskId: taskId,
          status: DownloadStatus.failed,
          progress: download.progress,
        );
        continue;
      }
      var status = _toDomainStatus(task.status);
      var progress = task.progress;
      if (status == DownloadStatus.paused) {
        // Retomável sem perder o que já baixou.
        await FlutterDownloader.resume(taskId: taskId);
        status = DownloadStatus.running;
      } else if (status == DownloadStatus.running || status == DownloadStatus.queued) {
        // O app morreu, então nada está de fato rodando — o plugin só não
        // teve chance de marcar como falho. Falha explícita, sem tentar
        // adivinhar se dá pra retomar; usuário baixa de novo se quiser.
        status = DownloadStatus.failed;
      }
      final localPath =
          status == DownloadStatus.complete && task.filename != null ? '${task.savedDir}/${task.filename}' : null;
      await _repository.updateByTaskId(taskId: taskId, status: status, progress: progress, localPath: localPath);
    }
  }

  Future<void> cancel({required int podcastId, required String episodeGuid}) async {
    final taskId = await _repository.taskIdFor(podcastId, episodeGuid);
    if (taskId != null) await FlutterDownloader.cancel(taskId: taskId);
    await _repository.deleteRecord(podcastId, episodeGuid);
  }

  /// Cancela se ainda estiver baixando, apaga o arquivo se já tiver
  /// terminado, e some com a linha no banco — vale pros dois casos.
  Future<void> remove({required int podcastId, required String episodeGuid}) async {
    final taskId = await _repository.taskIdFor(podcastId, episodeGuid);
    if (taskId != null) {
      await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
    }
    await _repository.deleteRecord(podcastId, episodeGuid);
  }

  Future<Directory> _directoryFor(int podcastId) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/downloads/$podcastId');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  String _fileNameFor(Episode episode) {
    final safeGuid = episode.guid.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return '$safeGuid${_extensionFrom(episode.audioUrl)}';
  }

  String _extensionFrom(String url) {
    final path = Uri.tryParse(url)?.path ?? '';
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) return '.mp3';
    final extension = path.substring(dot);
    return extension.length <= 5 ? extension : '.mp3';
  }
}

@Riverpod(keepAlive: true)
DownloadService downloadService(Ref ref) {
  return DownloadService(ref.watch(downloadRepositoryProvider));
}

/// Roda no isolate de background do `flutter_downloader` — não pode
/// referenciar nada do isolate principal além de mandar uma mensagem pelo
/// `SendPort` registrado em [DownloadService._bind]. Registrado uma vez em
/// `main.dart`, antes do primeiro `runApp`.
@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  IsolateNameServer.lookupPortByName(downloadPortName)?.send([id, status, progress]);
}
