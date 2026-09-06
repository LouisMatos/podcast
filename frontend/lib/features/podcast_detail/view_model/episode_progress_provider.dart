import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';

part 'episode_progress_provider.g.dart';

/// Progresso de escuta de cada episódio de um podcast, ao vivo. Mapa por
/// `episodeGuid` — guid ausente quer dizer que nunca tocou.
@riverpod
Stream<Map<String, EpisodeProgress>> episodeProgress(Ref ref, int podcastId) {
  return ref.watch(libraryRepositoryProvider).watchProgressForPodcast(podcastId);
}
