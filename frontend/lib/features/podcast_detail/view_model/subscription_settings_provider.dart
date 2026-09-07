import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';

part 'subscription_settings_provider.g.dart';

/// Guids arquivados de um podcast, ao vivo (Fase 13). A lista do detalhe
/// vem do RSS; o filtro de arquivados é aplicado na View com este conjunto.
@riverpod
Stream<Set<String>> archivedGuids(Ref ref, int podcastId) {
  return ref.watch(libraryRepositoryProvider).watchArchivedGuids(podcastId);
}

/// Config de gestão automática do podcast (auto-download / limpeza / velocidade).
@riverpod
Stream<SubscriptionSettings> subscriptionSettings(Ref ref, int podcastId) {
  return ref.watch(libraryRepositoryProvider).watchSubscriptionSettings(podcastId);
}
