import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';
import '../view_model/library_controls.dart';
import '../view_model/library_view_model.dart';

/// Biblioteca do usuário — assinaturas reais, vindas do SQLite local via
/// `LibraryViewModel`. Atualiza sozinha quando o usuário assina/desassina
/// em qualquer tela (o ViewModel observa um `Stream` do drift). A barra de
/// controles (busca, ordenação, grade/lista) fica no `LibraryControls`.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptions = ref.watch(libraryViewModelProvider);
    final controls = ref.watch(libraryControlsProvider);
    final controlsNotifier = ref.read(libraryControlsProvider.notifier);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref
            .read(libraryRepositoryProvider)
            .refreshAllSubscriptions(force: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Text(
              'Biblioteca',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Seus podcasts assinados',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SearchField(
                    onChanged: controlsNotifier.setFilter,
                    hintText: 'Filtrar por nome',
                  ),
                ),
                const SizedBox(width: 8),
                _SortMenu(
                  value: controls.sort,
                  onSelected: controlsNotifier.setSort,
                ),
                IconButton(
                  icon: Icon(controls.grid ? Icons.view_list : Icons.grid_view),
                  tooltip: controls.grid ? 'Ver em lista' : 'Ver em grade',
                  onPressed: controlsNotifier.toggleGrid,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SoftCard(
              onTap: () => context.push('/library/search'),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).extension<AppColors>()!.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Buscar episódios na biblioteca',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Assinaturas'),
            AnimatedSwitcher(
              duration: AppMotion.base,
              switchInCurve: AppMotion.enter,
              switchOutCurve: AppMotion.standard,
              child: subscriptions.when(
                loading: () => Column(
                  key: const ValueKey('loading'),
                  children: const [
                    _SubscriptionTileSkeleton(),
                    SizedBox(height: 12),
                    _SubscriptionTileSkeleton(),
                  ],
                ),
                error: (error, _) => EmptyState(
                  key: const ValueKey('error'),
                  icon: Icons.error_outline,
                  title: 'Não foi possível carregar sua biblioteca',
                  onRetry: () => ref.invalidate(libraryViewModelProvider),
                ),
                data: (subs) {
                  if (subs.isEmpty) {
                    return const Padding(
                      key: ValueKey('empty'),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: EmptyState(
                        icon: Icons.library_music_outlined,
                        title: 'Nenhuma assinatura ainda',
                        message: 'Podcasts que você assinar aparecem aqui.',
                      ),
                    );
                  }
                  final visible = applyLibraryControls(subs, controls);
                  if (visible.isEmpty) {
                    return const Padding(
                      key: ValueKey('no-match'),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: EmptyState(
                        icon: Icons.search_off,
                        title: 'Nenhum podcast com esse nome',
                      ),
                    );
                  }
                  return controls.grid
                      ? _SubscriptionsGrid(
                          key: ValueKey('grid-${visible.length}'),
                          subs: visible,
                        )
                      : Column(
                          key: ValueKey('list-${visible.length}'),
                          children: [
                            for (final sub in visible) ...[
                              _SubscriptionTile(sub: sub),
                              const SizedBox(height: 12),
                            ],
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.value, required this.onSelected});

  final LibrarySort value;
  final ValueChanged<LibrarySort> onSelected;

  static const _labels = {
    LibrarySort.recentes: 'Episódio mais recente',
    LibrarySort.alfabetico: 'Ordem alfabética',
    LibrarySort.naoOuvidos: 'Mais não-ouvidos',
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<LibrarySort>(
      icon: const Icon(Icons.sort),
      tooltip: 'Ordenar',
      initialValue: value,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final entry in _labels.entries)
          PopupMenuItem(value: entry.key, child: Text(entry.value)),
      ],
    );
  }
}

/// Selo pastel arredondado com a contagem de episódios não-ouvidos. Some
/// quando não há nenhum.
class _UnplayedBadge extends StatelessWidget {
  const _UnplayedBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final colors = Theme.of(context).extension<AppColors>()!;

    return Semantics(
      label:
          '$count ${count == 1 ? 'episódio não ouvido' : 'episódios não ouvidos'}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: Text(
          '$count',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({required this.podcast, required this.size});

  final Podcast podcast;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    Widget fallback() => Container(
      width: size,
      height: size,
      color: colors.secondary.withValues(alpha: 0.5),
      child: Icon(Icons.podcasts, color: colors.textPrimary),
    );

    return Hero(
      tag: 'podcast-artwork-${podcast.id}',
      // Capa decorativa: o título do podcast é lido junto ao tile.
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: AppRadii.smAll,
          child: podcast.artworkUrl == null
              ? fallback()
              : CachedNetworkImage(
                  imageUrl: podcast.artworkUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => ShimmerBox(width: size, height: size),
                  errorWidget: (_, _, _) => fallback(),
                ),
        ),
      ),
    );
  }
}

class _SubscriptionTile extends ConsumerWidget {
  const _SubscriptionTile({required this.sub});

  final LibrarySubscription sub;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final podcast = sub.podcast;

    return SoftCard(
      onTap: () => context.push('/podcast', extra: podcast),
      child: Row(
        children: [
          _Artwork(podcast: podcast, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    podcast.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (sub.unplayedCount > 0) ...[
            _UnplayedBadge(count: sub.unplayedCount),
            const SizedBox(width: 4),
          ],
          IconButton(
            icon: Icon(Icons.favorite, color: colors.primary),
            tooltip: 'Desassinar ${podcast.title}',
            onPressed: () => ref
                .read(libraryViewModelProvider.notifier)
                .unsubscribe(podcast.id),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionsGrid extends StatelessWidget {
  const _SubscriptionsGrid({super.key, required this.subs});

  final List<LibrarySubscription> subs;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.78,
      children: [for (final sub in subs) _SubscriptionGridCard(sub: sub)],
    );
  }
}

class _SubscriptionGridCard extends StatelessWidget {
  const _SubscriptionGridCard({required this.sub});

  final LibrarySubscription sub;

  @override
  Widget build(BuildContext context) {
    final podcast = sub.podcast;
    final width = (MediaQuery.sizeOf(context).width - 40 - 12) / 2 - 20;

    return SoftCard(
      padding: const EdgeInsets.all(10),
      onTap: () => context.push('/podcast', extra: podcast),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _Artwork(podcast: podcast, size: width < 0 ? 0 : width),
              if (sub.unplayedCount > 0)
                Positioned(
                  top: 6,
                  left: 6,
                  child: _UnplayedBadge(count: sub.unplayedCount),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            podcast.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class _SubscriptionTileSkeleton extends StatelessWidget {
  const _SubscriptionTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          const ShimmerBox(width: 48, height: 48, borderRadius: AppRadii.smAll),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 16),
                SizedBox(height: 8),
                ShimmerBox(width: 120, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
