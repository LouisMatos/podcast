import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/repositories/library_repository.dart';

part 'library_search_state.freezed.dart';

@freezed
abstract class LibrarySearchState with _$LibrarySearchState {
  const factory LibrarySearchState({
    @Default('') String query,
    @Default(false) bool isLoading,
    @Default(<RecentEpisodeItem>[]) List<RecentEpisodeItem> results,
    String? error,
  }) = _LibrarySearchState;
}
