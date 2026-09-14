import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/episode.dart';
import '../../data/models/podcast.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'shimmer_box.dart';
import 'soft_card.dart';

/// Linha de episódio reutilizável (histórico, busca na biblioteca, resultados
/// de busca de episódio, Home, Podcast Detail): capa 48 (ou [leading]
/// customizado), título 2 linhas, subtítulo livre, [progress] opcional
/// abaixo do subtítulo e um widget opcional à direita ([trailing] — pode ser
/// um `Row` com múltiplos botões). Toca → callback.
class EpisodeRow extends StatelessWidget {
  const EpisodeRow({
    super.key,
    required this.podcast,
    required this.episode,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.leading,
    this.progress,
  });

  final Podcast podcast;
  final Episode episode;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  /// Substitui a capa padrão quando presente (ex.: capa com botão de
  /// play/pause sobreposto no Podcast Detail). Espera-se 48x48.
  final Widget? leading;

  /// Widget opcional renderizado abaixo do subtítulo (ex.: barra de
  /// progresso de reprodução).
  final Widget? progress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final artUrl = episode.imageUrl ?? podcast.artworkUrl;

    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          // Capa decorativa: título/subtítulo ao lado já dão o contexto.
          ExcludeSemantics(
            child: leading ??
                ClipRRect(
                  borderRadius: AppRadii.smAll,
                  child: artUrl == null
                      ? _fallback(colors)
                      : CachedNetworkImage(
                          imageUrl: artUrl,
                          width: 48,
                          height: 48,
                          memCacheWidth: (48 * MediaQuery.devicePixelRatioOf(context)).round(),
                          memCacheHeight: (48 * MediaQuery.devicePixelRatioOf(context)).round(),
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              const ShimmerBox(width: 48, height: 48),
                          errorWidget: (_, _, _) => _fallback(colors),
                        ),
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MergeSemantics(
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
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  ?progress,
                ],
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  Widget _fallback(AppColors colors) => Container(
    width: 48,
    height: 48,
    color: colors.primary.withValues(alpha: 0.5),
    child: Icon(Icons.graphic_eq, color: colors.textPrimary),
  );
}

/// Skeleton de [EpisodeRow].
class EpisodeRowSkeleton extends StatelessWidget {
  const EpisodeRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: const [
          ShimmerBox(width: 48, height: 48, borderRadius: AppRadii.smAll),
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
