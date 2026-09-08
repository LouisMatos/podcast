import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/podcast_list_tile.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/episode_search_result.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/podcast_repository.dart';
import '../podcast_genres.dart';
import '../view_model/discover_state.dart';
import '../view_model/discover_view_model.dart';
import '../view_model/episode_search_podcast_provider.dart';
import '../view_model/featured_view_model.dart';

/// Tela de descoberta: campo de busca, carrossel "Mais ouvidos no Brasil"
/// e grade de categorias. `DiscoverViewModel` cuida do debounce da busca;
/// `FeaturedViewModel` cuida do carrossel.
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoverViewModelProvider);
    final notifier = ref.read(discoverViewModelProvider.notifier);
    final searching = state.query.isNotEmpty;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text('Descobrir', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Encontre seu próximo podcast favorito', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          SearchField(
            onChanged: notifier.onQueryChanged,
            hintText: 'Buscar podcast ou categoria',
          ),
          const SizedBox(height: 24),
          if (searching) ...[
            SegmentedButton<SearchMode>(
              segments: const [
                ButtonSegment(
                  value: SearchMode.podcasts,
                  icon: Icon(Icons.podcasts),
                  label: Text('Podcasts'),
                ),
                ButtonSegment(
                  value: SearchMode.episodios,
                  icon: Icon(Icons.headphones),
                  label: Text('Episódios'),
                ),
              ],
              selected: {state.mode},
              onSelectionChanged: (selection) => notifier.setMode(selection.first),
            ),
            const SizedBox(height: 16),
          ],
          AnimatedSwitcher(
            duration: AppMotion.base,
            switchInCurve: AppMotion.enter,
            switchOutCurve: AppMotion.standard,
            child: searching
                ? _SearchResults(
                    key: ValueKey(_bodyKey(state)),
                    state: state,
                    onRetry: notifier.retry,
                  )
                : const _DiscoverHome(key: ValueKey('home')),
          ),
        ],
      ),
    );
  }

  String _bodyKey(DiscoverState state) {
    if (state.isLoading) return 'loading-${state.mode.name}';
    if (state.error != null) return 'error-${state.mode.name}';
    final count = state.mode == SearchMode.podcasts
        ? state.results.length
        : state.episodeResults.length;
    return 'results-${state.mode.name}-${state.query}-$count';
  }
}

class _DiscoverHome extends StatelessWidget {
  const _DiscoverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionHeader(title: 'Mais ouvidos no Brasil'),
        _FeaturedCarousel(),
        SizedBox(height: 24),
        SectionHeader(title: 'Categorias'),
        _CategoriesGrid(),
      ],
    );
  }
}

class _FeaturedCarousel extends ConsumerWidget {
  const _FeaturedCarousel();

  static const double _height = 232;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredViewModelProvider);

    return SizedBox(
      height: _height,
      child: featured.when(
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, _) => const _RankedCardSkeleton(),
        ),
        error: (_, _) => _CarouselError(
          onRetry: () => ref.read(featuredViewModelProvider.notifier).refresh(),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text('Nada por aqui.', style: Theme.of(context).textTheme.bodyMedium),
            );
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _RankedPodcastCard(entry: items[i]),
          );
        },
      ),
    );
  }
}

class _RankedPodcastCard extends StatelessWidget {
  const _RankedPodcastCard({required this.entry});

  final RankedPodcast entry;

  static const double _width = 148;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final podcast = entry.podcast;

    return SizedBox(
      width: _width,
      child: SoftCard(
        padding: const EdgeInsets.all(10),
        onTap: () => context.push('/podcast', extra: podcast),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'podcast-artwork-${podcast.id}',
                  child: ClipRRect(
                    borderRadius: AppRadii.smAll,
                    child: podcast.artworkUrl == null
                        ? _artworkFallback(colors)
                        : CachedNetworkImage(
                            imageUrl: podcast.artworkUrl!,
                            width: _width - 20,
                            height: _width - 20,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => _artworkFallback(colors),
                            errorWidget: (_, _, _) => _artworkFallback(colors),
                          ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                    child: Text(
                      '${entry.rank}',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: colors.onAccent, fontWeight: FontWeight.w700),
                    ),
                  ),
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
      ),
    );
  }

  Widget _artworkFallback(AppColors colors) {
    return Container(
      width: _width - 20,
      height: _width - 20,
      color: colors.primary.withValues(alpha: 0.5),
      child: Icon(Icons.graphic_eq, color: colors.textPrimary),
    );
  }
}

class _CarouselError extends StatelessWidget {
  const _CarouselError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Align(
      alignment: Alignment.centerLeft,
      child: SoftCard(
        onTap: onRetry,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, color: colors.textMuted),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'Não deu pra carregar os mais ouvidos.\nTocar pra tentar de novo.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankedCardSkeleton extends StatelessWidget {
  const _RankedCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _RankedPodcastCard._width,
      child: SoftCard(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerBox(width: 128, height: 128, borderRadius: AppRadii.smAll),
            SizedBox(height: 8),
            ShimmerBox(height: 14),
            SizedBox(height: 6),
            ShimmerBox(width: 80, height: 14),
          ],
        ),
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final genre in podcastGenres) _CategoryTile(genre: genre),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.genre});

  final PodcastGenre genre;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final width = (MediaQuery.sizeOf(context).width - 40 - 12) / 2;

    return SizedBox(
      width: width,
      child: SoftCard(
        onTap: () => context.push('/discover/category', extra: (id: genre.id, label: genre.label)),
        child: Row(
          children: [
            Icon(genre.icon, color: colors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                genre.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({super.key, required this.state, required this.onRetry});

  final DiscoverState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Column(
        children: [
          for (var i = 0; i < 3; i++) ...[
            const PodcastListTileSkeleton(),
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    if (state.error case final error?) {
      if (state.offline) {
        return EmptyState.offline(onRetry: onRetry);
      }
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Não foi possível buscar',
        message: error,
        onRetry: onRetry,
      );
    }

    final isEmpty = state.mode == SearchMode.podcasts
        ? state.results.isEmpty
        : state.episodeResults.isEmpty;
    if (isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
          'Nenhum resultado pra "${state.query}"',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.mode == SearchMode.episodios) {
      return Column(
        children: [
          for (final result in state.episodeResults) ...[
            _EpisodeResultTile(result: result),
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    return Column(
      children: [
        for (final podcast in state.results) ...[
          PodcastListTile(podcast: podcast),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

/// Tile de um episódio vindo da busca. Ao tocar, resolve o [Podcast] dono
/// (iTunes lookup) e abre `/episode`; enquanto resolve, fica desabilitado.
class _EpisodeResultTile extends ConsumerStatefulWidget {
  const _EpisodeResultTile({required this.result});

  final EpisodeSearchResult result;

  @override
  ConsumerState<_EpisodeResultTile> createState() => _EpisodeResultTileState();
}

class _EpisodeResultTileState extends ConsumerState<_EpisodeResultTile> {
  bool _opening = false;

  Future<void> _open() async {
    if (_opening) return;
    setState(() => _opening = true);

    final result = widget.result;
    Podcast? podcast;
    try {
      podcast = await ref.read(episodeSearchPodcastProvider(result.collectionId).future);
    } catch (_) {
      podcast = null;
    }

    if (!mounted) return;
    setState(() => _opening = false);

    if (podcast == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir')),
      );
      return;
    }

    unawaited(
      context.push(
        '/episode',
        extra: (
          podcast: podcast,
          episode: result.episode,
          queue: <Episode>[result.episode],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final result = widget.result;
    final episode = result.episode;
    final artUrl = episode.imageUrl ?? result.podcastArtworkUrl;

    return Opacity(
      opacity: _opening ? 0.5 : 1,
      child: SoftCard(
        onTap: _opening ? null : _open,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppRadii.smAll,
              child: artUrl == null
                  ? _fallback(colors)
                  : CachedNetworkImage(
                      imageUrl: artUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const ShimmerBox(width: 56, height: 56),
                      errorWidget: (_, _, _) => _fallback(colors),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle(result),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (_opening)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _subtitle(EpisodeSearchResult result) {
    final date = result.episode.publishedAt;
    final parts = [
      result.collectionName,
      if (date != null)
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
    ];
    return parts.join(' • ');
  }

  Widget _fallback(AppColors colors) => Container(
    width: 56,
    height: 56,
    color: colors.primary.withValues(alpha: 0.5),
    child: Icon(Icons.graphic_eq, color: colors.textPrimary),
  );
}
