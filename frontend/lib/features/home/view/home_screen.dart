import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';
import '../view_model/home_providers.dart';

/// Tela inicial (v2 Fase 11): "Continuar ouvindo" + "Novos episódios" das
/// assinaturas. É a landing do app.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueAsync = ref.watch(continueListeningProvider);
    final recentAsync = ref.watch(recentEpisodesProvider);

    final continueItems = continueAsync.value ?? const [];
    final recentItems = recentAsync.value ?? const [];
    final loaded = continueAsync.hasValue && recentAsync.hasValue;
    final vazio = loaded && continueItems.isEmpty && recentItems.isEmpty;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.read(libraryRepositoryProvider).refreshAllSubscriptions(force: true),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Text('Início', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'De onde você parou e o que saiu de novo',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            if (vazio)
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: EmptyState(
                  icon: Icons.podcasts,
                  title: 'Nada por aqui ainda',
                  message: 'Assine podcasts na aba Descobrir e eles aparecem aqui.',
                ),
              )
            else ...[
              if (continueItems.isNotEmpty) ...[
                const SectionHeader(title: 'Continuar ouvindo'),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: continueItems.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => _ContinueCard(item: continueItems[i]),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              const SectionHeader(title: 'Novos episódios'),
              if (!loaded && recentItems.isEmpty)
                for (var i = 0; i < 4; i++) ...[
                  const _EpisodeRowSkeleton(),
                  const SizedBox(height: 12),
                ]
              else if (recentItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Nenhum episódio novo das suas assinaturas.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                for (final item in recentItems) ...[
                  _RecentEpisodeRow(item: item),
                  const SizedBox(height: 12),
                ],
            ],
          ],
        ),
      ),
    );
  }
}

void _openEpisode(BuildContext context, Podcast podcast, Episode episode) {
  context.push('/episode', extra: (podcast: podcast, episode: episode, queue: <Episode>[episode]));
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.item});

  final ContinueListeningItem item;

  static const double _width = 150;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final total = item.episode.duration?.inSeconds ?? 0;
    final fraction = total > 0 ? (item.positionSeconds / total).clamp(0.0, 1.0) : null;
    final artUrl = item.episode.imageUrl ?? item.podcast.artworkUrl;

    return SizedBox(
      width: _width,
      child: SoftCard(
        padding: const EdgeInsets.all(10),
        onTap: () => _openEpisode(context, item.podcast, item.episode),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppRadii.smAll,
              child: artUrl == null
                  ? _fallback(colors)
                  : CachedNetworkImage(
                      imageUrl: artUrl,
                      width: _width - 20,
                      height: _width - 20,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => _fallback(colors),
                      errorWidget: (_, _, _) => _fallback(colors),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              item.episode.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 3,
                backgroundColor: colors.background,
                valueColor: AlwaysStoppedAnimation(colors.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback(AppColors colors) => Container(
        width: _width - 20,
        height: _width - 20,
        color: colors.primary.withValues(alpha: 0.5),
        child: Icon(Icons.graphic_eq, color: colors.textPrimary),
      );
}

class _RecentEpisodeRow extends StatelessWidget {
  const _RecentEpisodeRow({required this.item});

  final RecentEpisodeItem item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final artUrl = item.episode.imageUrl ?? item.podcast.artworkUrl;

    return SoftCard(
      onTap: () => _openEpisode(context, item.podcast, item.episode),
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
                  item.episode.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _fallback(AppColors colors) => Container(
        width: 56,
        height: 56,
        color: colors.primary.withValues(alpha: 0.5),
        child: Icon(Icons.graphic_eq, color: colors.textPrimary),
      );
}

class _EpisodeRowSkeleton extends StatelessWidget {
  const _EpisodeRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: const [
          ShimmerBox(width: 56, height: 56, borderRadius: AppRadii.smAll),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 16),
                SizedBox(height: 8),
                ShimmerBox(width: 140, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

