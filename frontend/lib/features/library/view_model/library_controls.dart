import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/prefs/preferences_store.dart';
import '../../../data/repositories/library_repository.dart';

part 'library_controls.freezed.dart';
part 'library_controls.g.dart';

enum LibrarySort { recentes, alfabetico, naoOuvidos }

@freezed
abstract class LibraryControlsState with _$LibraryControlsState {
  const factory LibraryControlsState({
    @Default('') String filter,
    @Default(LibrarySort.recentes) LibrarySort sort,
    @Default(false) bool grid,
  }) = _LibraryControlsState;
}

/// Filtro por nome, ordenação e modo grade/lista da Biblioteca. Só estado de
/// UI — não toca em rede. `grid`/`sort` sobrevivem ao restart via
/// [PreferencesStore]; `filter` é local à sessão. keepAlive porque depende de
/// `preferencesStoreProvider` (keepAlive) e a preferência não deve cair ao
/// sair da aba.
@Riverpod(keepAlive: true)
class LibraryControls extends _$LibraryControls {
  @override
  LibraryControlsState build() {
    final prefs = ref.watch(preferencesStoreProvider);
    return LibraryControlsState(
      sort: _sortFromName(prefs.librarySortName),
      grid: prefs.libraryGrid,
    );
  }

  void setFilter(String filter) => state = state.copyWith(filter: filter);

  void setSort(LibrarySort sort) {
    state = state.copyWith(sort: sort);
    ref.read(preferencesStoreProvider).setLibrarySortName(sort.name);
  }

  void toggleGrid() {
    final next = !state.grid;
    state = state.copyWith(grid: next);
    ref.read(preferencesStoreProvider).setLibraryGrid(next);
  }

  static LibrarySort _sortFromName(String? name) => LibrarySort.values.firstWhere(
        (s) => s.name == name,
        orElse: () => LibrarySort.recentes,
      );
}

/// Aplica filtro por nome e ordenação a uma lista de assinaturas. Função
/// pura — sem Flutter, sem Riverpod — pra testar sem widget.
List<LibrarySubscription> applyLibraryControls(
  List<LibrarySubscription> subs,
  LibraryControlsState c,
) {
  final filter = c.filter.trim().toLowerCase();
  final filtered = filter.isEmpty
      ? [...subs]
      : subs
          .where((s) => s.podcast.title.toLowerCase().contains(filter))
          .toList();

  int byLastPublishedDesc(LibrarySubscription a, LibrarySubscription b) {
    final ad = a.lastPublishedAt, bd = b.lastPublishedAt;
    if (ad == null && bd == null) return 0;
    if (ad == null) return 1; // sem data vai pro fim
    if (bd == null) return -1;
    return bd.compareTo(ad);
  }

  switch (c.sort) {
    case LibrarySort.recentes:
      filtered.sort(byLastPublishedDesc);
    case LibrarySort.alfabetico:
      filtered.sort((a, b) => a.podcast.title
          .toLowerCase()
          .compareTo(b.podcast.title.toLowerCase()));
    case LibrarySort.naoOuvidos:
      filtered.sort((a, b) {
        final byCount = b.unplayedCount.compareTo(a.unplayedCount);
        return byCount != 0 ? byCount : byLastPublishedDesc(a, b);
      });
  }

  return filtered;
}
