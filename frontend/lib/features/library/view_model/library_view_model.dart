import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';

part 'library_view_model.g.dart';

/// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
/// de novo toda vez que a tabela de assinaturas muda, então a tela nunca
/// precisa dar refresh manual.
@riverpod
class LibraryViewModel extends _$LibraryViewModel {
  @override
  Stream<List<Podcast>> build() {
    return ref.watch(libraryRepositoryProvider).watchSubscriptions();
  }

  Future<void> unsubscribe(int podcastId) {
    return ref.read(libraryRepositoryProvider).unsubscribe(podcastId);
  }
}
