import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';

part 'subscribe_feed_state.freezed.dart';

@freezed
abstract class SubscribeFeedState with _$SubscribeFeedState {
  const factory SubscribeFeedState({
    @Default(true) bool isLoading,
    Podcast? podcast,
    @Default(<Episode>[]) List<Episode> episodes,
    String? error,
    @Default(false) bool alreadySubscribed,
  }) = _SubscribeFeedState;
}
