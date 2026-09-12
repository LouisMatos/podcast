import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/radio_station.dart';

part 'radio_state.freezed.dart';

@freezed
abstract class RadioState with _$RadioState {
  const factory RadioState({
    @Default(<RadioStation>[]) List<RadioStation> stations,
    @Default('') String query,
    @Default(<String>{}) Set<String> favoriteIds,
    @Default(false) bool isLoading,
    String? error,
    @Default(false) bool offline,
    String? nowPlayingId,
    // Guarda a estação inteira (não só o id) pra dar nome/logo pro
    // mini-player mesmo se a lista de estações mudar por causa de busca.
    RadioStation? nowPlaying,
    @Default(false) bool isPlaying,
    @Default(false) bool isBuffering,
  }) = _RadioState;
}
