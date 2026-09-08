import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/episode_row.dart';
import '../../../core/widgets/search_field.dart';
import '../../../data/models/episode.dart';
import '../../../data/repositories/library_repository.dart';
import '../view_model/library_search_state.dart';
import '../view_model/library_search_view_model.dart';

/// Busca de episódios só nas assinaturas. Debounce no ViewModel; a tela só
/// desenha os estados (carregando / vazio / erro / resultados).
class LibrarySearchScreen extends ConsumerWidget {
  const LibrarySearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(librarySearchViewModelProvider);
    final notifier = ref.read(librarySearchViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar episódios')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: SearchField(
                onChanged: notifier.onQueryChanged,
                hintText: 'Buscar episódios na biblioteca',
              ),
            ),
            Expanded(child: _Results(state: state)),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.state});

  final LibrarySearchState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, _) => const EpisodeRowSkeleton(),
      );
    }

    if (state.error case final error?) {
      return EmptyState(
        icon: Icons.wifi_off,
        title: 'Não foi possível buscar',
        message: error,
      );
    }

    if (state.query.trim().isEmpty) {
      return const EmptyState(
        icon: Icons.search,
        title: 'Busque um episódio',
        message: 'Procura pelo título entre todos os seus podcasts assinados.',
      );
    }

    if (state.results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Nenhum episódio pra "${state.query}"',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: state.results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final item = state.results[i];
        return EpisodeRow(
          podcast: item.podcast,
          episode: item.episode,
          subtitle: _subtitle(item),
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
    );
  }

  String _subtitle(RecentEpisodeItem item) {
    final date = item.episode.publishedAt;
    final parts = [
      item.podcast.title,
      if (date != null)
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
    ];
    return parts.join(' • ');
  }
}
