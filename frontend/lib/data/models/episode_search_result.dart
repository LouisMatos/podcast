import 'package:freezed_annotation/freezed_annotation.dart';

import 'episode.dart';

part 'episode_search_result.freezed.dart';

/// Resultado de busca de episódio da iTunes (entity=podcastEpisode). Traz o
/// episódio + o mínimo do podcast dono pra abrir a tela de episódio.
@freezed
abstract class EpisodeSearchResult with _$EpisodeSearchResult {
  const factory EpisodeSearchResult({
    /// collectionId iTunes do podcast dono.
    required int collectionId,
    required String collectionName,
    String? feedUrl,
    String? podcastArtworkUrl,
    required Episode episode,
  }) = _EpisodeSearchResult;
}
