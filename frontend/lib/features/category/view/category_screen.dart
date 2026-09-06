import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/podcast_list_tile.dart';
import '../view_model/category_view_model.dart';

/// Lista de podcasts mais ouvidos numa categoria. Aberta pela grade de
/// categorias da tela Descobrir (`/discover/category`).
class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key, required this.genreId, required this.label});

  final int genreId;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcasts = ref.watch(categoryViewModelProvider(genreId));

    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: SafeArea(
        child: podcasts.when(
          loading: () => ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: 6,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, _) => const PodcastListTileSkeleton(),
          ),
          error: (_, _) => EmptyState(
            icon: Icons.wifi_off,
            title: 'Não foi possível carregar',
            message: 'A lista de $label não veio agora.',
            onRetry: () => ref.read(categoryViewModelProvider(genreId).notifier).refresh(),
          ),
          data: (items) {
            if (items.isEmpty) {
              return const EmptyState(
                icon: Icons.podcasts,
                title: 'Nada por aqui',
                message: 'Nenhum podcast nesta categoria agora.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => PodcastListTile(podcast: items[i]),
            );
          },
        ),
      ),
    );
  }
}
