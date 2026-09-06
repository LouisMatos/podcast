import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/download.dart';
import '../../../data/repositories/download_repository.dart';

part 'download_status_provider.g.dart';

/// Status de download de um episódio, ao vivo — usado pelo botão de
/// download na lista de episódios. `null` quer dizer "nunca foi baixado".
@riverpod
Stream<Download?> downloadStatus(Ref ref, int podcastId, String episodeGuid) {
  return ref.watch(downloadRepositoryProvider).watchForEpisode(podcastId, episodeGuid);
}
