import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/podcast_repository.dart';
import 'discover_state.dart';

part 'discover_view_model.g.dart';

/// ViewModel da tela de descoberta. Sem import de Flutter — testável sem
/// widget. A View só chama [onQueryChanged] / [setMode] e lê o [DiscoverState].
@riverpod
class DiscoverViewModel extends _$DiscoverViewModel {
  Timer? _debounce;

  static const _debounceDelay = Duration(milliseconds: 400);

  @override
  DiscoverState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const DiscoverState();
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    state = state.copyWith(query: query);

    if (query.trim().isEmpty) {
      state = state.copyWith(
        results: const [],
        episodeResults: const [],
        isLoading: false,
        error: null,
      );
      return;
    }

    _debounce = Timer(_debounceDelay, () => _search(query));
  }

  /// Troca entre buscar podcasts e episódios. Se já tem query, refaz a busca
  /// na hora (sem esperar debounce).
  void setMode(SearchMode mode) {
    if (state.mode == mode) return;
    state = state.copyWith(mode: mode);

    if (state.query.trim().isEmpty) return;
    _debounce?.cancel();
    _search(state.query);
  }

  /// Refaz a última busca — usado pelo botão "Tentar de novo" quando
  /// [DiscoverState.error] está preenchido.
  void retry() {
    if (state.query.trim().isEmpty) return;
    _debounce?.cancel();
    _search(state.query);
  }

  Future<void> _search(String query) async {
    final mode = state.mode;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(podcastRepositoryProvider);
      if (mode == SearchMode.podcasts) {
        final results = await repository.search(query);
        if (_stale(query, mode)) return;
        state = state.copyWith(
          results: results,
          episodeResults: const [],
          isLoading: false,
        );
      } else {
        final results = await repository.searchEpisodes(query);
        if (_stale(query, mode)) return;
        state = state.copyWith(
          episodeResults: results,
          results: const [],
          isLoading: false,
        );
      }
    } catch (_) {
      if (_stale(query, mode)) return;
      state = state.copyWith(isLoading: false, error: 'Não foi possível buscar agora.');
    }
  }

  /// Resultado obsoleto: usuário já digitou outra coisa ou trocou de modo.
  bool _stale(String query, SearchMode mode) =>
      state.query != query || state.mode != mode;
}
