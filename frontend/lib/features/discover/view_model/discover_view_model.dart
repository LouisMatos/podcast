import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/podcast_repository.dart';
import 'discover_state.dart';

part 'discover_view_model.g.dart';

/// ViewModel da tela de descoberta. Sem import de Flutter — testável sem
/// widget. A View só chama [onQueryChanged] e lê o [DiscoverState].
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
      state = state.copyWith(results: const [], isLoading: false, error: null);
      return;
    }

    _debounce = Timer(_debounceDelay, () => _search(query));
  }

  Future<void> _search(String query) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(podcastRepositoryProvider);
      final results = await repository.search(query);
      if (state.query != query) return; // usuário já digitou outra coisa
      state = state.copyWith(results: results, isLoading: false);
    } catch (_) {
      if (state.query != query) return;
      state = state.copyWith(isLoading: false, error: 'Não foi possível buscar agora.');
    }
  }
}
