import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/podcast.dart';
import '../../../data/repositories/podcast_repository.dart';

part 'episode_search_podcast_provider.g.dart';

/// Resolve o [Podcast] dono de um resultado de busca de episódio pelo
/// `collectionId` iTunes — a busca de episódio só traz o mínimo do podcast, a
/// tela de episódio precisa do modelo completo. `null` = não encontrado.
@riverpod
Future<Podcast?> episodeSearchPodcast(Ref ref, int collectionId) {
  return ref.read(podcastRepositoryProvider).podcastById(collectionId);
}
