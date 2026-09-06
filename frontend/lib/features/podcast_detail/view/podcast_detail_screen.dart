import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pastel_chip.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../view_model/podcast_detail_view_model.dart';

class PodcastDetailScreen extends ConsumerWidget {
  const PodcastDetailScreen({super.key, required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(podcastDetailViewModelProvider(podcast));

    return Scaffold(
      appBar: AppBar(title: Text(podcast.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SafeArea(
        top: false,
        child: detail.when(
          loading: () => _PodcastDetailBody(podcast: podcast, episodes: null),
          error: (error, _) => EmptyState(
            icon: Icons.error_outline,
            title: 'Não foi possível carregar os episódios',
            message: '$error',
          ),
          data: (state) => _PodcastDetailBody(podcast: state.podcast, episodes: state.episodes),
        ),
      ),
    );
  }
}

class _PodcastDetailBody extends StatelessWidget {
  const _PodcastDetailBody({required this.podcast, required this.episodes});

  final Podcast podcast;

  /// `null` enquanto carrega — usado pra mostrar o skeleton.
  final List<Episode>? episodes;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'podcast-artwork-${podcast.id}',
              child: ClipRRect(
                borderRadius: AppRadii.mdAll,
                child: podcast.artworkUrl == null
                    ? _artworkFallback(colors, size: 96)
                    : CachedNetworkImage(
                        imageUrl: podcast.artworkUrl!,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const ShimmerBox(width: 96, height: 96),
                        errorWidget: (context, url, error) => _artworkFallback(colors, size: 96),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(podcast.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(podcast.author, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (podcast.genre case final genre?) PastelChip(label: genre),
                      PastelChip(
                        label: podcast.episodeCount == 1 ? '1 episódio' : '${podcast.episodeCount} episódios',
                        color: colors.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Episódios', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        if (episodes == null)
          for (var i = 0; i < 4; i++) ...[
            const _EpisodeSkeleton(),
            const SizedBox(height: 12),
          ]
        else if (episodes!.isEmpty)
          const EmptyState(
            icon: Icons.podcasts_outlined,
            title: 'Nenhum episódio encontrado',
            message: 'Esse feed não trouxe episódios dessa vez.',
          )
        else
          for (final episode in episodes!) ...[
            _EpisodeTile(episode: episode),
            const SizedBox(height: 12),
          ],
      ],
    );
  }

  Widget _artworkFallback(AppColors colors, {required double size}) {
    return Container(
      width: size,
      height: size,
      color: colors.primary.withValues(alpha: 0.5),
      child: Icon(Icons.graphic_eq, color: colors.textPrimary),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SoftCard(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.play_circle_outline, color: colors.primary, size: 32),
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
                const SizedBox(height: 4),
                Text(_meta(episode), style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _meta(Episode episode) {
    final parts = <String>[
      if (episode.publishedAt case final date?) _formatDate(date),
      if (episode.duration case final duration?) _formatDuration(duration),
    ];
    return parts.isEmpty ? 'Sem informações' : parts.join(' • ');
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h${minutes.toString().padLeft(2, '0')}min';
    return '${minutes}min';
  }
}

class _EpisodeSkeleton extends StatelessWidget {
  const _EpisodeSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          const ShimmerBox(width: 32, height: 32, borderRadius: BorderRadius.all(Radius.circular(16))),
          const SizedBox(width: 12),
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
