import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';

part 'home_providers.g.dart';

/// "Continuar ouvindo" — episódios começados e não terminados, cross-assinatura.
@riverpod
Stream<List<ContinueListeningItem>> continueListening(Ref ref) {
  return ref.watch(libraryRepositoryProvider).watchContinueListening();
}

/// "Novos episódios" — episódios recentes de todas as assinaturas.
@riverpod
Stream<List<RecentEpisodeItem>> recentEpisodes(Ref ref) {
  return ref.watch(libraryRepositoryProvider).watchRecentEpisodes();
}
