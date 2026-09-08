import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';
import 'library_search_state.dart';

part 'library_search_view_model.g.dart';

/// Busca de episódios dentro da biblioteca (só assinaturas). Sem import de
/// Flutter — testável sem widget. Debounce de 400ms, igual `DiscoverViewModel`.
@riverpod
class LibrarySearchViewModel extends _$LibrarySearchViewModel {
  Timer? _debounce;

  static const _debounceDelay = Duration(milliseconds: 400);

  @override
  LibrarySearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const LibrarySearchState();
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    state = state.copyWith(query: query);

    if (query.trim().isEmpty) {
      state = state.copyWith(results: const [], isLoading: false, error: null);
      return;
    }

    _debounce = Timer(_debounceDelay, () => _search(query));
  }

  Future<void> _search(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results =
          await ref.read(libraryRepositoryProvider).searchLibraryEpisodes(query);
      if (state.query != query) return; // usuário já digitou outra coisa
      state = state.copyWith(results: results, isLoading: false);
    } catch (_) {
      if (state.query != query) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Não foi possível buscar agora.',
      );
    }
  }
}
