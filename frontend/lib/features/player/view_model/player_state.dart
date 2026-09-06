import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';

part 'player_state.freezed.dart';

/// Estado do player, pronto pra UI — sem nenhum tipo do `audio_service` ou
/// do `just_audio` vazando pra fora do `PlayerViewModel`.
@freezed
abstract class PlayerState with _$PlayerState {
  const factory PlayerState({
    Podcast? podcast,
    Episode? episode,
    @Default(<Episode>[]) List<Episode> queue,
    @Default(false) bool isPlaying,
    @Default(false) bool isBuffering,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration bufferedPosition,
    Duration? duration,
    @Default(1.0) double speed,
    Duration? sleepTimerRemaining,
  }) = _PlayerState;

  const PlayerState._();

  /// Nada tocando ainda — é o estado inicial, antes do primeiro episódio.
  bool get isIdle => episode == null;

  bool get hasNextInQueue {
    if (episode == null) return false;
    final index = queue.indexWhere((e) => e.guid == episode!.guid);
    return index != -1 && index < queue.length - 1;
  }
}
