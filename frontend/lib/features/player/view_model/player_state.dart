import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';

part 'player_state.freezed.dart';

/// Uma banda do equalizador, do jeito que a UI precisa (Hz + ganho em dB).
typedef EqualizerBand = ({int index, double centerHz, double gain});

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
    @Default(1.0) double volume,
    @Default(false) bool equalizerEnabled,
    @Default(false) bool equalizerAvailable,
    @Default(0.0) double equalizerMinDb,
    @Default(0.0) double equalizerMaxDb,
    @Default(<EqualizerBand>[]) List<EqualizerBand> equalizerBands,
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
