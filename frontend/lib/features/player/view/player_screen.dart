import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/pill_button.dart';
import '../view_model/player_state.dart';
import '../view_model/player_view_model.dart';

const _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0];
const _sleepOptions = [Duration(minutes: 5), Duration(minutes: 15), Duration(minutes: 30), Duration(minutes: 60)];

/// Player em tela cheia. Aberto a partir do mini-player, em qualquer aba —
/// por isso mora numa rota de topo (`/player`), fora das 3 abas.
class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerViewModelProvider);
    final notifier = ref.read(playerViewModelProvider.notifier);
    final colors = Theme.of(context).extension<AppColors>()!;

    if (player.isIdle) {
      // Não deveria acontecer (só se navegar direto pra rota sem nada
      // tocando), mas evita crash se acontecer.
      return const Scaffold(body: Center(child: Text('Nada tocando')));
    }

    final episode = player.episode!;
    final podcast = player.podcast;
    final artUrl = episode.imageUrl ?? podcast?.artworkUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(podcast?.title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (defaultTargetPlatform == TargetPlatform.android)
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: 'Equalizador',
              onPressed: () => _showEqualizerSheet(context),
            ),
          _SleepTimerButton(remaining: player.sleepTimerRemaining, notifier: notifier),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(),
              Hero(
                tag: 'podcast-artwork-${podcast?.id}',
                child: ClipRRect(
                  borderRadius: AppRadii.surfaceAll,
                  child: artUrl == null
                      ? Container(
                          width: 260,
                          height: 260,
                          color: colors.primary.withValues(alpha: 0.5),
                          child: Icon(Icons.graphic_eq, size: 64, color: colors.textPrimary),
                        )
                      : CachedNetworkImage(imageUrl: artUrl, width: 260, height: 260, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                episode.title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                podcast?.title ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              _SeekBar(player: player, onSeek: notifier.seek),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10),
                    iconSize: 28,
                    tooltip: 'Voltar 15 segundos',
                    onPressed: () => notifier.skipBackward(const Duration(seconds: 15)),
                  ),
                  IconButton(
                    icon: Icon(player.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                    iconSize: 72,
                    color: colors.primary,
                    tooltip: player.isPlaying ? 'Pausar' : 'Tocar',
                    onPressed: player.isBuffering ? null : notifier.togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_30),
                    iconSize: 28,
                    tooltip: 'Avançar 30 segundos',
                    onPressed: () => notifier.skipForward(const Duration(seconds: 30)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.volume_down, color: colors.textMuted, size: 20),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(trackHeight: 3),
                      child: Slider(
                        value: player.volume.clamp(0.0, 1.0),
                        onChanged: notifier.setVolume,
                      ),
                    ),
                  ),
                  Icon(Icons.volume_up, color: colors.textMuted, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SpeedButton(speed: player.speed, onChanged: notifier.setSpeed),
                  if (player.hasNextInQueue) ...[
                    const SizedBox(width: 12),
                    PillButton(
                      label: 'Próximo',
                      icon: Icons.skip_next,
                      variant: PillButtonVariant.ghost,
                      onPressed: notifier.playNextInQueue,
                    ),
                  ],
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeekBar extends StatelessWidget {
  const _SeekBar({required this.player, required this.onSeek});

  final PlayerState player;
  final ValueChanged<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    final duration = player.duration ?? Duration.zero;
    final maxMs = duration.inMilliseconds.toDouble();
    final valueMs = player.position.inMilliseconds.toDouble().clamp(0.0, maxMs <= 0 ? 1.0 : maxMs);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(trackHeight: 3),
          child: Slider(
            min: 0,
            max: maxMs <= 0 ? 1.0 : maxMs,
            value: valueMs,
            onChanged: maxMs <= 0 ? null : (v) => onSeek(Duration(milliseconds: v.round())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_format(player.position), style: Theme.of(context).textTheme.bodyMedium),
              Text(_format(duration), style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}

class _SpeedButton extends StatelessWidget {
  const _SpeedButton({required this.speed, required this.onChanged});

  final double speed;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      initialValue: speed,
      tooltip: 'Velocidade de reprodução',
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final s in _speeds) PopupMenuItem(value: s, child: Text('${s}x')),
      ],
      child: PillButton(
        label: '${speed}x',
        icon: Icons.speed,
        variant: PillButtonVariant.ghost,
        onPressed: null,
      ),
    );
  }
}

void _showEqualizerSheet(BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.surface)),
    ),
    builder: (_) => const _EqualizerSheet(),
  );
}

class _EqualizerSheet extends ConsumerWidget {
  const _EqualizerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerViewModelProvider);
    final notifier = ref.read(playerViewModelProvider.notifier);
    final colors = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Equalizador', style: Theme.of(context).textTheme.titleMedium),
                Switch(
                  value: player.equalizerEnabled,
                  onChanged: (v) => notifier.toggleEqualizer(v),
                ),
              ],
            ),
            if (!player.equalizerAvailable && player.equalizerBands.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Toque um episódio pra ajustar o equalizador.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                ),
              )
            else ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final preset in EqualizerPreset.values)
                    ActionChip(
                      label: Text(_presetLabel(preset)),
                      onPressed: player.equalizerEnabled
                          ? () => notifier.applyEqualizerPreset(preset)
                          : null,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              for (final band in player.equalizerBands)
                Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: Text(
                        _hzLabel(band.centerHz),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.textMuted),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: band.gain.clamp(player.equalizerMinDb, player.equalizerMaxDb),
                        min: player.equalizerMinDb,
                        max: player.equalizerMaxDb,
                        onChanged: player.equalizerEnabled
                            ? (v) => notifier.setEqualizerBand(band.index, v)
                            : null,
                      ),
                    ),
                    SizedBox(
                      width: 44,
                      child: Text(
                        '${band.gain.round()} dB',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.textMuted),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _presetLabel(EqualizerPreset p) => switch (p) {
        EqualizerPreset.flat => 'Flat',
        EqualizerPreset.voz => 'Voz',
        EqualizerPreset.grave => 'Grave',
        EqualizerPreset.agudo => 'Agudo',
      };

  String _hzLabel(double hz) => hz >= 1000 ? '${(hz / 1000).toStringAsFixed(hz % 1000 == 0 ? 0 : 1)}k' : '${hz.round()}';
}

class _SleepTimerButton extends StatelessWidget {
  const _SleepTimerButton({required this.remaining, required this.notifier});

  final Duration? remaining;
  final PlayerViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Duration?>(
      icon: Icon(remaining != null ? Icons.bedtime : Icons.bedtime_outlined),
      tooltip: 'Temporizador para dormir',
      onSelected: (duration) {
        if (duration == null) {
          notifier.cancelSleepTimer();
        } else {
          notifier.startSleepTimer(duration);
        }
      },
      itemBuilder: (context) => [
        for (final option in _sleepOptions)
          PopupMenuItem(value: option, child: Text('${option.inMinutes} min')),
        if (remaining != null) const PopupMenuItem(value: null, child: Text('Cancelar')),
      ],
    );
  }
}
