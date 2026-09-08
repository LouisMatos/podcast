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
    @Default(SearchMode.podcasts) SearchMode mode,
    @Default(<Podcast>[]) List<Podcast> results,
    @Default(<EpisodeSearchResult>[]) List<EpisodeSearchResult> episodeResults,
    String? error,
  }) = _DiscoverState;
}
