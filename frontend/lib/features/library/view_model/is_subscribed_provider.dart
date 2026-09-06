import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';

part 'is_subscribed_provider.g.dart';

/// Se um podcast está assinado, ao vivo — usado pelo botão de
/// assinar/desassinar no detalhe do podcast. Fica reativo porque a
/// assinatura pode mudar em outra tela (ex: desassinar pela Biblioteca).
@riverpod
Stream<bool> isSubscribed(Ref ref, int podcastId) {
  return ref.watch(libraryRepositoryProvider).watchIsSubscribed(podcastId);
}
