import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/podcast_repository.dart';
import '../../podcast_detail/view_model/podcast_by_id_provider.dart';

part 'deep_link_resolution.g.dart';

/// Podcast + episódio resolvidos de um deep link `podcastapp://episode/...`.
typedef ResolvedDeepLinkEpisode = ({Podcast podcast, Episode episode});

/// Orquestra os dois awaits de um deep link de episódio: resolve o podcast
/// (assinatura ou iTunes) e depois casa o episódio por `guid` — primeiro no
/// cache local, senão no RSS ao vivo. `null` se qualquer um dos dois falhar.
@riverpod
Future<ResolvedDeepLinkEpisode?> resolvedDeepLinkEpisode(
  Ref ref,
  int podcastId,
  String guid,
) async {
  final podcast = await ref.watch(podcastByIdProvider(podcastId).future);
  if (podcast == null) return null;

  Episode? match;
  for (final episode in await ref.read(libraryRepositoryProvider).cachedEpisodes(
        podcastId,
        includeArchived: true,
      )) {
    if (episode.guid == guid) {
      match = episode;
      break;
    }
  }

  if (match == null) {
    for (final episode in await ref.read(podcastRepositoryProvider).episodesFor(podcast)) {
      if (episode.guid == guid) {
        match = episode;
        break;
      }
    }
  }

  return match == null ? null : (podcast: podcast, episode: match);
}
