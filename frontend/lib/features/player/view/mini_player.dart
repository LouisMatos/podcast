import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../view_model/player_state.dart';
import '../view_model/player_view_model.dart';

/// Barra fina persistente acima da navegação — só aparece depois que algo
/// já tocou pelo menos uma vez. Toque nela abre o player cheio.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerViewModelProvider);
    final colors = Theme.of(context).extension<AppColors>()!;

    return AnimatedSize(
      duration: AppMotion.base,
      curve: AppMotion.transform,
      alignment: Alignment.bottomCenter,
      child: player.isIdle
          ? const SizedBox(width: double.infinity)
          : _Bar(player: player, colors: colors),
    );
  }
}

class _Bar extends ConsumerWidget {
  const _Bar({required this.player, required this.colors});

  final PlayerState player;
  final AppColors colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episode = player.episode!;
    final podcast = player.podcast;
    final progress = player.duration == null || player.duration == Duration.zero
        ? 0.0
        : (player.position.inMilliseconds / player.duration!.inMilliseconds).clamp(0.0, 1.0);

    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: () => context.push('/player'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: colors.background,
                valueColor: AlwaysStoppedAnimation(colors.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Hero(
                    tag: 'podcast-artwork-${podcast?.id}',
                    child: ClipRRect(
                      borderRadius: AppRadii.smAll,
                      child: (episode.imageUrl ?? podcast?.artworkUrl) == null
                          ? Container(
                              width: 40,
                              height: 40,
                              color: colors.primary.withValues(alpha: 0.5),
                              child: Icon(Icons.graphic_eq, color: colors.textPrimary, size: 20),
                            )
                          : CachedNetworkImage(
                              imageUrl: (episode.imageUrl ?? podcast!.artworkUrl)!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      episode.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      player.isBuffering
                          ? Icons.hourglass_empty
                          : player.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                      color: colors.primary,
                      size: 36,
                    ),
                    onPressed: player.isBuffering
                        ? null
                        : () => ref.read(playerViewModelProvider.notifier).togglePlayPause(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
