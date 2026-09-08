import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/podcast_repository.dart';

part 'podcast_by_id_provider.g.dart';

/// Resolve um [Podcast] pelo `id` (collectionId iTunes). Usado pelo
/// resolvedor de deep link — o link só traz o id, a tela de detalhe precisa
/// do modelo completo.
///
/// Primeiro tenta as assinaturas (offline, instantâneo); só cai na iTunes
/// Search API se não estiver assinado. `null` = não encontrado.
@riverpod
Future<Podcast?> podcastById(Ref ref, int id) async {
  final subs = await ref.read(libraryRepositoryProvider).watchSubscriptions().first;
  for (final podcast in subs) {
    if (podcast.id == id) return podcast;
  }
  return ref.read(podcastRepositoryProvider).podcastById(id);
}
