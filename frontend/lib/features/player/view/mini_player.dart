import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../view_model/player_state.dart';
import '../view_model/player_view_model.dart';
import 'player_sheet.dart';

/// Barra fina persistente acima da navegação — só aparece depois que algo
/// já tocou pelo menos uma vez. Toque nela abre o player cheio.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerViewModelProvider);
    final colors = Theme.of(context).extension<AppColors>()!;

    return AnimatedSize(
      duration: AppMotion.effective(context, AppMotion.base),
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
        : (player.position.inMilliseconds / player.duration!.inMilliseconds)
              .clamp(0.0, 1.0);

    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: () => showPlayerSheet(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 2,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: progress),
                duration: AppMotion.effective(context, AppMotion.fast),
                curve: AppMotion.standard,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  backgroundColor: colors.background,
                  valueColor: AlwaysStoppedAnimation(colors.primary),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Hero(
                    tag: 'podcast-artwork-${podcast?.id}',
                    // Capa decorativa: o título ao lado já é lido.
                    child: ExcludeSemantics(
                      child: ClipRRect(
                        borderRadius: AppRadii.smAll,
                        child: (episode.imageUrl ?? podcast?.artworkUrl) == null
                            ? Container(
                                width: 40,
                                height: 40,
                                color: colors.primary.withValues(alpha: 0.5),
                                child: Icon(
                                  Icons.graphic_eq,
                                  color: colors.textPrimary,
                                  size: 20,
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl:
                                    (episode.imageUrl ?? podcast!.artworkUrl)!,
                                width: 40,
                                height: 40,
                                memCacheWidth: (40 * MediaQuery.devicePixelRatioOf(context)).round(),
                                memCacheHeight: (40 * MediaQuery.devicePixelRatioOf(context)).round(),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // Hero da capa fica fora do switcher — dentro dele briga
                    // por tag duplicada durante a transição.
                    child: AnimatedSwitcher(
                      duration: AppMotion.effective(context, AppMotion.base),
                      switchInCurve: AppMotion.enter,
                      child: Text(
                        episode.title,
                        key: ValueKey(episode.guid),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      player.isBuffering
                          ? Icons.hourglass_empty
                          : player.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: colors.primary,
                      size: 32,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    tooltip: player.isBuffering
                        ? 'Carregando'
                        : (player.isPlaying ? 'Pausar' : 'Tocar'),
                    onPressed: player.isBuffering
                        ? null
                        : () => ref
                              .read(playerViewModelProvider.notifier)
                              .togglePlayPause(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: colors.textMuted,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    tooltip: 'Fechar player',
                    onPressed: () => ref
                        .read(playerViewModelProvider.notifier)
                        .dismiss(),
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
