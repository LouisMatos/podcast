import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/podcast_repository.dart';
import 'podcast_detail_state.dart';

part 'podcast_detail_view_model.g.dart';

/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.
///
/// O status de assinatura NÃO mora nesse estado de propósito: ele vem de
/// `isSubscribedProvider`, que a View observa direto. Se estivesse aqui,
/// assinar/desassinar refaria o fetch inteiro do RSS a cada toque.
@riverpod
class PodcastDetailViewModel extends _$PodcastDetailViewModel {
  @override
  Future<PodcastDetailState> build(Podcast podcast) async {
    final repository = ref.watch(podcastRepositoryProvider);
    try {
      final episodes = await repository.episodesFor(podcast);
      return PodcastDetailState(podcast: podcast, episodes: episodes);
    } catch (error) {
      // Sem rede (ou feed fora do ar): se já tem cache de uma visita
      // anterior — o caso normal de um podcast assinado —, usa ele. É o
      // que faz um episódio baixado continuar acessível em modo avião.
      final cached = await ref.read(libraryRepositoryProvider).cachedEpisodes(podcast.id);
      if (cached.isEmpty) rethrow;
      return PodcastDetailState(podcast: podcast, episodes: cached);
    }
  }

  Future<void> subscribe() async {
    final current = state.value;
    if (current == null) return;
    await ref.read(libraryRepositoryProvider).subscribe(current.podcast, current.episodes);
  }

  Future<void> unsubscribe() async {
    await ref.read(libraryRepositoryProvider).unsubscribe(podcast.id);
  }
}
