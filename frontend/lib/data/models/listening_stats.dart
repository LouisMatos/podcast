import 'package:freezed_annotation/freezed_annotation.dart';

part 'listening_stats.freezed.dart';

/// Estatísticas de escuta do usuário (Fase 17), derivadas de
/// `listen_history`. Recalculadas ao vivo quando a tabela muda.
@freezed
abstract class ListeningStats with _$ListeningStats {
  const factory ListeningStats({
    /// Tempo total ouvido desde sempre.
    @Default(Duration.zero) Duration total,

    /// Tempo ouvido nesta semana (a partir de segunda 00:00 local).
    @Default(Duration.zero) Duration thisWeek,

    /// Dias consecutivos com registro, terminando hoje ou ontem.
    @Default(0) int streakDays,

    /// Hoje e os 6 dias anteriores, em ordem cronológica; `listened` 0 nos
    /// dias sem registro.
    @Default(<DailyListening>[]) List<DailyListening> last7Days,
  }) = _ListeningStats;
}

/// Tempo ouvido num dia — meia-noite local em [day].
@freezed
abstract class DailyListening with _$DailyListening {
  const factory DailyListening({
    required DateTime day,
    required Duration listened,
  }) = _DailyListening;
}
