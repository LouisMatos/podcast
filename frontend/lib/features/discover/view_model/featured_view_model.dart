import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/podcast_repository.dart';

part 'featured_view_model.g.dart';

/// Carrossel "Mais ouvidos no Brasil" da tela Descobrir. Separado do
/// [DiscoverViewModel] de propósito: não deve refazer a busca debounced
/// quando o usuário digita, nem sumir quando a busca começa.
///
/// `keepAlive` — o ranking muda pouco; cachear pela sessão evita rede à toa
/// ao voltar pra aba.
@Riverpod(keepAlive: true)
class FeaturedViewModel extends _$FeaturedViewModel {
  @override
  Future<List<RankedPodcast>> build() {
    return ref.watch(podcastRepositoryProvider).topPodcasts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(podcastRepositoryProvider).topPodcasts());
  }
}
