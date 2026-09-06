import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/podcast.dart';
import '../../../data/repositories/podcast_repository.dart';
import 'podcast_detail_state.dart';

part 'podcast_detail_view_model.g.dart';

/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.
@riverpod
class PodcastDetailViewModel extends _$PodcastDetailViewModel {
  @override
  Future<PodcastDetailState> build(Podcast podcast) async {
    final repository = ref.watch(podcastRepositoryProvider);
    final episodes = await repository.episodesFor(podcast);
    return PodcastDetailState(podcast: podcast, episodes: episodes);
  }
}
