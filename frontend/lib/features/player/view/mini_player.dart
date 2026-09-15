import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../../../data/models/radio_station.dart';
import '../../radio/view_model/radio_state.dart';
import '../../radio/view_model/radio_view_model.dart';
import '../view_model/player_state.dart';
import '../view_model/player_view_model.dart';
import 'player_sheet.dart';

/// Barra fina persistente acima da navegação — só aparece depois que algo
/// já tocou pelo menos uma vez. Toque nela abre o player cheio (podcast) ou
/// o detalhe da estação (rádio). Rádio tem prioridade quando as duas
/// "tocam" ao mesmo tempo — é o que está de fato audível, já que ambas
/// usam o mesmo `PodcastAudioHandler`.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radio = ref.watch(radioViewModelProvider);
    final player = ref.watch(playerViewModelProvider);
    final colors = Theme.of(context).extension<AppColors>()!;
    final station = radio.nowPlaying;

    final Widget? bar = station != null
        ? _RadioBar(radio: radio, station: station, colors: colors)
        : (player.isIdle ? null : _Bar(player: player, colors: colors));

    return AnimatedSize(
      duration: AppMotion.effective(context, AppMotion.base),
      curve: AppMotion.transform,
      alignment: Alignment.bottomCenter,
      child: bar ?? const SizedBox(width: double.infinity),
    );
  }
}

class _RadioBar extends ConsumerWidget {
  const _RadioBar({required this.radio, required this.station, required this.colors});

  final RadioState radio;
  final RadioStation station;
  final AppColors colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: () => context.push('/radio-detail', extra: station),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadii.smAll,
                child: station.logoUrl == null
                    ? Container(
                        width: 40,
                        height: 40,
                        color: colors.primary.withValues(alpha: 0.5),
                        child: Icon(Icons.radio, color: colors.textPrimary, size: 20),
                      )
                    : CachedNetworkImage(
                        imageUrl: station.logoUrl!,
                        width: 40,
                        height: 40,
                        memCacheWidth: (40 * MediaQuery.devicePixelRatioOf(context)).round(),
                        memCacheHeight: (40 * MediaQuery.devicePixelRatioOf(context)).round(),
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      station.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Rádio ao vivo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  radio.isBuffering
                      ? Icons.hourglass_empty
                      : radio.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: colors.primary,
                  size: 32,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                tooltip: radio.isBuffering
                    ? 'Carregando'
                    : (radio.isPlaying ? 'Pausar' : 'Tocar'),
                onPressed: radio.isBuffering
                    ? null
                    : () => ref.read(radioViewModelProvider.notifier).togglePlayPause(),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colors.textMuted, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                tooltip: 'Fechar rádio',
                onPressed: () => ref.read(radioViewModelProvider.notifier).stop(),
              ),
            ],
          ),
        ),
      ),
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
                    // Tag própria, não `podcast-artwork-<id>` — o mini-player
                    // fica montado o tempo todo (shell persistente), então
                    // compartilhar a tag com PodcastListTile/DiscoverScreen/
                    // PodcastDetailScreen colide ("multiple heroes share
                    // the same tag") sempre que o podcast tocando também
                    // aparece na tela atual.
                    tag: 'mini-player-artwork-${podcast?.id}',
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
