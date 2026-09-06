import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';

part 'podcast_detail_state.freezed.dart';

@freezed
abstract class PodcastDetailState with _$PodcastDetailState {
  const factory PodcastDetailState({
    required Podcast podcast,
    @Default(<Episode>[]) List<Episode> episodes,
  }) = _PodcastDetailState;
}
