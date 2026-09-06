import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/downloaded_episode.dart';
import '../../../data/repositories/download_repository.dart';
import '../../../services/download/download_service.dart';

part 'downloads_view_model.g.dart';

/// ViewModel da tela de Downloads. Reativo — remover um download em
/// qualquer lugar do app atualiza essa lista sozinho.
@riverpod
class DownloadsViewModel extends _$DownloadsViewModel {
  @override
  Stream<List<DownloadedEpisode>> build() {
    return ref.watch(downloadRepositoryProvider).watchAll();
  }

  Future<void> remove(int podcastId, String episodeGuid) {
    return ref.read(downloadServiceProvider).remove(podcastId: podcastId, episodeGuid: episodeGuid);
  }
}
