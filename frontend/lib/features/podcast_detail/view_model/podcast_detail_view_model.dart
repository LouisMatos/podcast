import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/episode.dart';
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
    final library = ref.read(libraryRepositoryProvider);

    // Pinta cache salvo na hora e revalida por trás (Fase 27.4) — sem isso
    // o detalhe trava esperando o RSS mesmo pra podcast já visto antes.
    // Assinado usa o cache rico (`LibraryRepository`, filtra arquivado);
    // não-assinado (vindo da busca) usa o cache genérico do próprio
    // `PodcastRepository`, que não tem FK de assinatura.
    final subscribedCache = await library.cachedEpisodes(podcast.id);
    final cached = subscribedCache.isNotEmpty ? subscribedCache : await repository.cachedEpisodesFor(podcast);

    if (cached != null && cached.isNotEmpty) {
      unawaited(_revalidate(podcast, repository, library));
      return PodcastDetailState(podcast: podcast, episodes: cached);
    }

    // Sem cache nenhum (primeira visita): comportamento de sempre, espera
    // a rede e relança se falhar.
    final episodes = await repository.episodesFor(podcast);
    // Feeds vivos (Fase 9): toda visita com rede atualiza o cache local
    // do podcast assinado — é assim que "novos episódios" fica em dia.
    await library.cacheEpisodesIfSubscribed(podcast.id, episodes);
    return PodcastDetailState(podcast: podcast, episodes: episodes);
  }

  Future<void> _revalidate(Podcast podcast, PodcastRepository repository, LibraryRepository library) async {
    final List<Episode> episodes;
    try {
      episodes = await repository.episodesFor(podcast);
    } catch (_) {
      // `episodesFor` já cai pro cache genérico internamente; se chegou
      // aqui é porque nem isso existia — mantém o que já foi pintado.
      return;
    }
    await library.cacheEpisodesIfSubscribed(podcast.id, episodes);
    if (!ref.mounted) return;
    state = AsyncData(PodcastDetailState(podcast: podcast, episodes: episodes));
  }

  Future<void> subscribe() async {
    final current = state.value;
    if (current == null) return;
    await ref.read(libraryRepositoryProvider).subscribe(current.podcast, current.episodes);
  }

  Future<void> unsubscribe() async {
    await ref.read(libraryRepositoryProvider).unsubscribe(podcast.id);
  }

  /// Pull-to-refresh: rebusca o RSS e re-renderiza (o cache é atualizado
  /// dentro do `build`).
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
