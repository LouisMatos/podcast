import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/podcast.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'pastel_chip.dart';
import 'shimmer_box.dart';
import 'soft_card.dart';

/// Linha de podcast reutilizável (resultados de busca, lista por categoria):
/// capa 48 com Hero, título + autor, chip de gênero. Toca → detalhe.
class PodcastListTile extends StatelessWidget {
  const PodcastListTile({super.key, required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SoftCard(
      onTap: () => context.push('/podcast', extra: podcast),
      child: Row(
        children: [
          Hero(
            tag: 'podcast-artwork-${podcast.id}',
            // Capa decorativa: título e autor ao lado já dão o contexto.
            child: ExcludeSemantics(
              child: ClipRRect(
                borderRadius: AppRadii.smAll,
                child: podcast.artworkUrl == null
                    ? _artworkFallback(colors)
                    : CachedNetworkImage(
                        imageUrl: podcast.artworkUrl!,
                        width: 48,
                        height: 48,
                        memCacheWidth: (48 * MediaQuery.devicePixelRatioOf(context)).round(),
                        memCacheHeight: (48 * MediaQuery.devicePixelRatioOf(context)).round(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const ShimmerBox(width: 48, height: 48),
                        errorWidget: (context, url, error) =>
                            _artworkFallback(colors),
                      ),
              ),
            ),
          ),
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
                  const SizedBox(height: 2),
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
          if (podcast.genre case final genre?) ...[
            const SizedBox(width: 12),
            PastelChip(label: genre),
          ],
        ],
      ),
    );
  }

  Widget _artworkFallback(AppColors colors) {
    return Container(
      width: 48,
      height: 48,
      color: colors.primary.withValues(alpha: 0.5),
      child: Icon(Icons.graphic_eq, color: colors.textPrimary),
    );
  }
}

/// Skeleton de [PodcastListTile] pra estados de carregamento.
class PodcastListTileSkeleton extends StatelessWidget {
  const PodcastListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: const [
          ShimmerBox(width: 48, height: 48, borderRadius: AppRadii.smAll),
          SizedBox(width: 16),
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
