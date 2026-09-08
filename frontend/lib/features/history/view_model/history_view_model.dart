import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';

part 'history_view_model.g.dart';

/// Histórico de escuta (Fase 17) — episódios já ouvidos, agregados por
/// episódio, do mais recente pro mais antigo.
@riverpod
class HistoryViewModel extends _$HistoryViewModel {
  @override
  Stream<List<ListenHistoryItem>> build() {
    return ref.watch(libraryRepositoryProvider).watchListenHistory();
  }
}
