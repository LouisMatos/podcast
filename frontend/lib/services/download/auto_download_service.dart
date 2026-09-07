import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/library_repository.dart';
import 'download_service.dart';

part 'auto_download_service.g.dart';

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
          await _downloads.download(podcastId: podcastId, episode: episode);
        }
      }

      if (settings.autoDeletePlayedDays > 0) {
        final stale = await _library.playedDownloadsToPrune(
          podcastId,
          Duration(days: settings.autoDeletePlayedDays),
        );
        for (final guid in stale) {
          await _downloads.remove(podcastId: podcastId, episodeGuid: guid);
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
