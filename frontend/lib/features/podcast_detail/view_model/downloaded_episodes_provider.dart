import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/episode.dart';
import '../../../data/repositories/library_repository.dart';

part 'downloaded_episodes_provider.g.dart';

/// Episódios de um podcast com download concluído, ao vivo — pra aba
/// "Baixados" do detalhe.
@riverpod
Stream<List<Episode>> downloadedEpisodes(Ref ref, int podcastId) {
  return ref.watch(libraryRepositoryProvider).watchDownloadedEpisodes(podcastId);
}
