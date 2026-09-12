import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/radio_station.dart';

/// Um item da lista de rádios. [isPlaying]/[isBuffering] refletem se esta é
/// a estação tocando agora no `RadioViewModel`.
class RadioStationTile extends StatelessWidget {
  const RadioStationTile({
    super.key,
    required this.station,
    this.isPlaying = false,
    this.isBuffering = false,
    this.isFavorite = false,
    this.onTap,
    this.onPlayTap,
    this.onFavoriteTap,
  });

  final RadioStation station;
  final bool isPlaying;
  final bool isBuffering;
  final bool isFavorite;

  /// Abre a tela de detalhe da rádio.
  final VoidCallback? onTap;

  /// Toca/pausa a rádio direto na lista, sem abrir o detalhe.
  final VoidCallback? onPlayTap;

  /// Favorita/desfavorita a rádio.
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: station.logoUrl == null
                ? _fallback(colors)
                : CachedNetworkImage(
                    imageUrl: station.logoUrl!,
                    width: 56,
                    height: 56,
                    memCacheWidth: (56 * MediaQuery.devicePixelRatioOf(context)).round(),
                    memCacheHeight: (56 * MediaQuery.devicePixelRatioOf(context)).round(),
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
                  station.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_subtitle case final subtitle?) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onFavoriteTap,
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? colors.primary : colors.textMuted,
            ),
          ),
          if (isBuffering)
            const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 2))
          else
            IconButton(
              onPressed: onPlayTap,
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline,
                color: colors.primary,
                size: 32,
              ),
            ),
        ],
      ),
    );
  }

  String? get _subtitle {
    final parts = [station.genre, station.state].nonNulls.toList();
    return parts.isEmpty ? null : parts.join(' • ');
  }

  Widget _fallback(AppColors colors) => Container(
    width: 56,
    height: 56,
    color: colors.primary.withValues(alpha: 0.5),
    child: Icon(Icons.radio, color: colors.textPrimary),
  );
}

class RadioStationTileSkeleton extends StatelessWidget {
  const RadioStationTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SoftCard(
      child: Row(
        children: [
          ShimmerBox(width: 56, height: 56, borderRadius: AppRadii.smAll),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 14),
                SizedBox(height: 6),
                ShimmerBox(width: 80, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
