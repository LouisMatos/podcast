import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/diagnostics/error_log.dart';
import '../../data/repositories/library_repository.dart';
import 'download_service.dart';

part 'auto_download_service.g.dart';

/// Prazo pro `enqueue` nativo (MethodChannel do `flutter_downloader`)
/// responder. Não cobre o download em si (assíncrono via callback,
/// desacoplado deste `await`) — só o registro da tarefa, que é local e
/// rápido por natureza. Existe só pra não travar `run()` inteiro se o
/// plugin nativo travar (mesma classe de bug do callback perdido).
const _perItemDeadline = Duration(seconds: 8);

/// Gestão automática de downloads (Fase 13). Roda depois de todo refresh de
/// feeds (`startupFeedRefreshProvider` / pull-to-refresh): baixa os N
/// recentes das assinaturas com auto-download e apaga os já ouvidos há
/// tempo demais. Tudo opt-in por podcast — assinatura sem config = no-op.
class AutoDownloadService {
  AutoDownloadService(this._library, this._downloads, this._connectivity);

  final LibraryRepository _library;
  final DownloadService _downloads;
  final Connectivity _connectivity;

  Future<void> run() async {
    final subs = await _library.allSubscriptionsWithSettings();
    if (subs.every((s) => s.settings.autoDownload == AutoDownloadMode.never &&
        s.settings.autoDeletePlayedDays == 0)) {
      return;
    }

    final onWifi = await _isUnmetered();

    for (final entry in subs) {
      final settings = entry.settings;
      final podcastId = entry.podcast.id;

      final wantsDownload = settings.autoDownload == AutoDownloadMode.always ||
          (settings.autoDownload == AutoDownloadMode.wifi && onWifi);
      if (wantsDownload) {
        final candidates = await _library.recentUndownloadedEpisodes(
          podcastId,
          limit: settings.autoDownloadLimit,
        );
        for (final episode in candidates) {
          try {
            await _downloads
                .download(podcastId: podcastId, episode: episode)
                .timeout(_perItemDeadline);
          } catch (error, stack) {
            await ErrorLog.instance.record(error, stack, context: 'AutoDownloadService.download');
          }
        }
      }

      if (settings.autoDeletePlayedDays > 0) {
        final stale = await _library.playedDownloadsToPrune(
          podcastId,
          Duration(days: settings.autoDeletePlayedDays),
        );
        for (final guid in stale) {
          try {
            await _downloads
                .remove(podcastId: podcastId, episodeGuid: guid)
                .timeout(_perItemDeadline);
          } catch (error, stack) {
            await ErrorLog.instance.record(error, stack, context: 'AutoDownloadService.remove');
          }
        }
      }
    }
  }

  Future<bool> _isUnmetered() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }
}

@Riverpod(keepAlive: true)
AutoDownloadService autoDownloadService(Ref ref) {
  return AutoDownloadService(
    ref.watch(libraryRepositoryProvider),
    ref.watch(downloadServiceProvider),
    Connectivity(),
  );
}
