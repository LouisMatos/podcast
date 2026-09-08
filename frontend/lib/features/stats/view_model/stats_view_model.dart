import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';

part 'stats_view_model.g.dart';

/// Estatísticas de escuta (Fase 17) — total, semana, sequência e os últimos
/// 7 dias, recalculadas ao vivo.
@riverpod
class StatsViewModel extends _$StatsViewModel {
  @override
  Stream<ListeningStats> build() {
    return ref.watch(libraryRepositoryProvider).watchListeningStats();
  }
}
