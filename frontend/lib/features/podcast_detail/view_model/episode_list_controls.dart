import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/episode.dart';
import '../../../data/repositories/library_repository.dart';

part 'episode_list_controls.freezed.dart';
part 'episode_list_controls.g.dart';

enum EpisodeFilter { todos, naoOuvidos, ouvidos }

enum EpisodeSort { recentes, antigos, maisLongos }

@freezed
abstract class EpisodeListControlsState with _$EpisodeListControlsState {
  const factory EpisodeListControlsState({
    @Default('') String query,
    @Default(EpisodeFilter.todos) EpisodeFilter filter,
    @Default(EpisodeSort.recentes) EpisodeSort sort,
  }) = _EpisodeListControlsState;
}

/// Busca / filtro / ordenação da lista de episódios do detalhe. `family`
/// por `podcastId` — só estado de UI, não toca em rede.
@riverpod
class EpisodeListControls extends _$EpisodeListControls {
  @override
  EpisodeListControlsState build(int podcastId) => const EpisodeListControlsState();

  void setQuery(String query) => state = state.copyWith(query: query);
  void setFilter(EpisodeFilter filter) => state = state.copyWith(filter: filter);
  void setSort(EpisodeSort sort) => state = state.copyWith(sort: sort);
}

/// Aplica busca, filtro e ordenação a uma lista de episódios. Função pura —
/// sem Flutter, sem Riverpod — pra testar sem widget.
List<Episode> applyEpisodeControls(
  List<Episode> episodes,
  EpisodeListControlsState controls,
  Map<String, EpisodeProgress> progress,
) {
  final query = controls.query.trim().toLowerCase();

  bool matchesFilter(Episode e) {
    final completed = progress[e.guid]?.completed ?? false;
    return switch (controls.filter) {
      EpisodeFilter.todos => true,
      EpisodeFilter.ouvidos => completed,
      EpisodeFilter.naoOuvidos => !completed,
    };
  }

  final filtered = episodes
      .where((e) => query.isEmpty || e.title.toLowerCase().contains(query))
      .where(matchesFilter)
      .toList();

  int byDateDesc(Episode a, Episode b) {
    final ad = a.publishedAt, bd = b.publishedAt;
    if (ad == null && bd == null) return 0;
    if (ad == null) return 1; // sem data vai pro fim
    if (bd == null) return -1;
    return bd.compareTo(ad);
  }

  filtered.sort(switch (controls.sort) {
    EpisodeSort.recentes => byDateDesc,
    EpisodeSort.antigos => (a, b) => -byDateDesc(a, b),
    EpisodeSort.maisLongos => (a, b) {
      final ad = a.duration, bd = b.duration;
      if (ad == null && bd == null) return 0;
      if (ad == null) return 1;
      if (bd == null) return -1;
      return bd.compareTo(ad);
    },
  });

  return filtered;
}
