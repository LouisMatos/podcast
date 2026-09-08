import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/listening_stats.dart';
import '../stats_format.dart';
import '../view_model/stats_view_model.dart';

const _weekdayLabels = ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'];

/// Cartão de estatísticas de escuta, pra embutir na tela de Ajustes (Fase 17):
/// total, semana, sequência e um gráfico dos últimos 7 dias.
class StatsCard extends ConsumerWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsViewModelProvider);
    return stats.when(
      loading: () => const _StatsCardSkeleton(),
      // Sem histórico ainda ou falha de leitura: mostra tudo zerado, sem erro.
      error: (_, _) => const _StatsCardBody(stats: ListeningStats()),
      data: (data) => _StatsCardBody(stats: data),
    );
  }
}

class _StatsCardBody extends StatelessWidget {
  const _StatsCardBody({required this.stats});

  final ListeningStats stats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Tempo total',
                  value: formatListenDuration(stats.total),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Esta semana',
                  value: formatListenDuration(stats.thisWeek),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Sequência: ${stats.streakDays} ${stats.streakDays == 1 ? 'dia' : 'dias'}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _Last7DaysChart(days: _resolveDays(stats.last7Days)),
        ],
      ),
    );
  }

  static List<DailyListening> _resolveDays(List<DailyListening> days) {
    if (days.length == 7) return days;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(
      7,
      (i) => DailyListening(
        day: DateTime(today.year, today.month, today.day - (6 - i)),
        listened: Duration.zero,
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(label, style: textTheme.bodyMedium?.copyWith(color: colors.textMuted)),
      ],
    );
  }
}

class _Last7DaysChart extends StatelessWidget {
  const _Last7DaysChart({required this.days});

  final List<DailyListening> days;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final maxSeconds = days
        .map((d) => d.listened.inSeconds)
        .fold<int>(0, (a, b) => math.max(a, b));

    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final d in days)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          heightFactor: maxSeconds == 0
                              ? 0.0
                              : (d.listened.inSeconds / maxSeconds).clamp(0.03, 1.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: _sameDay(d.day, today)
                                  ? colors.primary
                                  : colors.secondary,
                              borderRadius: AppRadii.smAll,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _weekdayLabels[d.day.weekday - 1],
                      style: textTheme.bodySmall?.copyWith(
                        color: _sameDay(d.day, today)
                            ? colors.textPrimary
                            : colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _StatsCardSkeleton extends StatelessWidget {
  const _StatsCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Expanded(child: ShimmerBox(width: 80, height: 20)),
              SizedBox(width: 16),
              Expanded(child: ShimmerBox(width: 80, height: 20)),
            ],
          ),
          SizedBox(height: 14),
          ShimmerBox(width: 120, height: 12),
          SizedBox(height: 18),
          ShimmerBox(height: 84),
        ],
      ),
    );
  }
}
