import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/episode_search_result.dart';
import '../../../data/models/podcast.dart';

part 'discover_state.freezed.dart';

/// Modo da busca de Descobrir: por podcast ou por episódio.
enum SearchMode { podcasts, episodios }

@freezed
abstract class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default('') String query,
    @Default(false) bool isLoading,

    /// `true` enquanto mostra resultado salvo (Fase 27) e busca de novo por
    /// trás — a View pode usar isso pra um indicador sutil, sem skeleton.
    @Default(false) bool isRevalidating,
    @Default(SearchMode.podcasts) SearchMode mode,
    @Default(<Podcast>[]) List<Podcast> results,
    @Default(<EpisodeSearchResult>[]) List<EpisodeSearchResult> episodeResults,
    String? error,
    @Default(false) bool offline,
  }) = _DiscoverState;
}
