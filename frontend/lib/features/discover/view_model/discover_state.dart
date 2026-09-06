import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/podcast.dart';

part 'discover_state.freezed.dart';

@freezed
abstract class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default('') String query,
    @Default(false) bool isLoading,
    @Default(<Podcast>[]) List<Podcast> results,
    String? error,
  }) = _DiscoverState;
}
