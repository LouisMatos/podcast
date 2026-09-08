import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';

part 'library_view_model.g.dart';

/// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
/// de novo toda vez que a tabela de assinaturas (ou o progresso/cache) muda,
/// então a tela nunca precisa dar refresh manual. Cada item já vem com os
/// metadados que a lista precisa (não-ouvidos, data do último episódio).
@riverpod
class LibraryViewModel extends _$LibraryViewModel {
  @override
  Stream<List<LibrarySubscription>> build() {
    return ref.watch(libraryRepositoryProvider).watchSubscriptionsWithMeta();
  }

  Future<void> unsubscribe(int podcastId) {
    return ref.read(libraryRepositoryProvider).unsubscribe(podcastId);
  }
}
