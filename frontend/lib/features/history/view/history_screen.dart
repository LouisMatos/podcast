import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/episode_row.dart';
import '../../../data/models/episode.dart';
import '../view_model/history_view_model.dart';

/// Tudo que o usuário já ouviu (Fase 17). Cada linha leva pro detalhe do
/// episódio.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de escuta')),
      body: SafeArea(
        top: false,
        child: history.when(
          loading: () => ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: const [
              EpisodeRowSkeleton(),
              SizedBox(height: 12),
              EpisodeRowSkeleton(),
              SizedBox(height: 12),
              EpisodeRowSkeleton(),
            ],
          ),
          error: (_, _) => EmptyState(
            icon: Icons.error_outline,
            title: 'Não foi possível carregar o histórico',
            onRetry: () => ref.invalidate(historyViewModelProvider),
          ),
          data: (items) => items.isEmpty
              ? const EmptyState(
                  icon: Icons.history,
                  title: 'Nada no histórico ainda',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return EpisodeRow(
                      podcast: item.podcast,
                      episode: item.episode,
                      subtitle:
                          '${item.podcast.title} • ${item.listened.inMinutes}min • ${_relativeDay(item.lastPlayedDay)}',
                      onTap: () => context.push(
                        '/episode',
                        extra: (
                          podcast: item.podcast,
                          episode: item.episode,
                          queue: <Episode>[item.episode],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

/// "hoje" / "ontem" / "há N dias" a partir de um dia (meia-noite local).
String _relativeDay(DateTime day) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(day.year, day.month, day.day);
  final diff = today.difference(d).inDays;
  if (diff <= 0) return 'hoje';
  if (diff == 1) return 'ontem';
  return 'há $diff dias';
}
