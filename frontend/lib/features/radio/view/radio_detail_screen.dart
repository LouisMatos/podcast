import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_bottom_bar.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/icon_toggle_button.dart';
import '../../../data/models/radio_station.dart';
import '../../player/view_model/player_view_model.dart';
import '../view_model/radio_view_model.dart';

/// Detalhe de uma rádio: logo, nome, gênero/estado e play/pause. Sem grade de
/// programação — Radio Browser API não fornece isso, e ICY metadata (única
/// alternativa técnica) só dá "tocando agora", não a grade do dia.
class RadioDetailScreen extends ConsumerWidget {
  const RadioDetailScreen({super.key, required this.station});

  final RadioStation station;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(radioViewModelProvider);
    final notifier = ref.read(radioViewModelProvider.notifier);
    final volume = ref.watch(playerViewModelProvider.select((s) => s.volume));
    final playerNotifier = ref.read(playerViewModelProvider.notifier);
    final colors = Theme.of(context).extension<AppColors>()!;

    final isPlaying = state.nowPlayingId == station.id && state.isPlaying;
    final isBuffering = state.nowPlayingId == station.id && state.isBuffering;

    return Scaffold(
      appBar: AppBar(title: Text(station.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentShellTabIndex,
        builder: (context, index, _) =>
            AppBottomBar(selectedIndex: index, onDestinationSelected: (i) => goToShellTab(context, i)),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: AppRadii.surfaceAll,
                  child: station.logoUrl == null
                      ? _fallback(colors)
                      : CachedNetworkImage(
                          imageUrl: station.logoUrl!,
                          width: 220,
                          height: 220,
                          memCacheWidth: (220 * MediaQuery.devicePixelRatioOf(context)).round(),
                          memCacheHeight: (220 * MediaQuery.devicePixelRatioOf(context)).round(),
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => _fallback(colors),
                        ),
                ),
                const SizedBox(height: 24),
                Text(
                  station.name,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: colors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                if (_subtitle case final subtitle?) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
                const SizedBox(height: 12),
                IconToggleButton(
                  selected: state.favoriteIds.contains(station.id),
                  iconSelected: Icons.star,
                  iconUnselected: Icons.star_border,
                  tooltipSelected: 'Favorita, toque pra remover',
                  tooltipUnselected: 'Favoritar',
                  onPressed: () => notifier.toggleFavorite(station.id),
                ),
                const SizedBox(height: 20),
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withValues(alpha: 0.12),
                  ),
                  child: IconButton(
                    iconSize: 64,
                    color: colors.primary,
                    onPressed: isBuffering ? null : () => notifier.play(station),
                    icon: isBuffering
                        ? const SizedBox(width: 48, height: 48, child: CircularProgressIndicator(strokeWidth: 3))
                        : Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Icon(Icons.volume_down, color: colors.textMuted, size: 20),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(trackHeight: 3),
                        child: Slider(
                          value: volume.clamp(0.0, 1.0),
                          label: 'Volume',
                          semanticFormatterCallback: (v) => 'Volume: ${(v * 100).round()}%',
                          onChanged: playerNotifier.setVolume,
                        ),
                      ),
                    ),
                    Icon(Icons.volume_up, color: colors.textMuted, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? get _subtitle {
    final parts = [station.genre, station.state].nonNulls.toList();
    return parts.isEmpty ? null : parts.join(' • ');
  }

  Widget _fallback(AppColors colors) => Container(
    width: 220,
    height: 220,
    color: colors.primary.withValues(alpha: 0.5),
    child: Icon(Icons.radio, color: colors.textPrimary, size: 72),
  );
}
