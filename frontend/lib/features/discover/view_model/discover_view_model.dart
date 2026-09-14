import 'dart:async';

import 'package:dio/dio.dart';
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
        offline: false,
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
    final repository = ref.read(podcastRepositoryProvider);

    // Pinta o último resultado salvo na hora — a busca de rede roda por
    // trás, sem travar a tela num skeleton enquanto a rede está lenta/fora
    // (Fase 27.4). Só entra skeleton quando não há nada salvo ainda.
    var hasCache = false;
    if (mode == SearchMode.podcasts) {
      final cached = await repository.cachedSearchResults(query);
      if (_stale(query, mode)) return;
      if (cached != null && cached.isNotEmpty) {
        hasCache = true;
        state = state.copyWith(results: cached, episodeResults: const []);
      }
    } else {
      final cached = await repository.cachedEpisodeSearchResults(query);
      if (_stale(query, mode)) return;
      if (cached != null && cached.isNotEmpty) {
        hasCache = true;
        state = state.copyWith(episodeResults: cached, results: const []);
      }
    }

    state = hasCache
        ? state.copyWith(isLoading: false, isRevalidating: true, error: null, offline: false)
        : state.copyWith(isLoading: true, isRevalidating: false, error: null, offline: false);

    try {
      if (mode == SearchMode.podcasts) {
        final results = await repository.search(query);
        if (_stale(query, mode)) return;
        state = state.copyWith(
          results: results,
          episodeResults: const [],
          isLoading: false,
          isRevalidating: false,
        );
      } else {
        final results = await repository.searchEpisodes(query);
        if (_stale(query, mode)) return;
        state = state.copyWith(
          episodeResults: results,
          results: const [],
          isLoading: false,
          isRevalidating: false,
        );
      }
    } catch (e) {
      if (_stale(query, mode)) return;
      state = state.copyWith(
        isLoading: false,
        isRevalidating: false,
        error: 'Não foi possível buscar agora.',
        offline: _isConnectionError(e),
      );
    }
  }

  /// Falha de rede (sem internet / timeout) vs. qualquer outro erro — a View
  /// mostra `EmptyState.offline` só no primeiro caso.
  bool _isConnectionError(Object error) {
    if (error is! DioException) return false;
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }

  /// Resultado obsoleto: usuário já digitou outra coisa ou trocou de modo.
  bool _stale(String query, SearchMode mode) =>
      state.query != query || state.mode != mode;
}
