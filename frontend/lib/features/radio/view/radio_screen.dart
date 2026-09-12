import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/search_field.dart';
import '../../../data/models/radio_station.dart';
import '../view_model/radio_state.dart';
import '../view_model/radio_view_model.dart' show radioViewModelProvider, filterStations;
import 'radio_station_tile.dart';

/// Tela da aba Rádio: lista de rádios brasileiras ao vivo, tocando via
/// `PodcastAudioHandler` compartilhado (fora do fluxo de fila de podcast).
/// Abas "Todas"/"Favoritas", busca compartilhada entre as duas.
class RadioScreen extends ConsumerWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(radioViewModelProvider);
    final notifier = ref.read(radioViewModelProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rádio', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('Rádios brasileiras ao vivo', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            SearchField(hintText: 'Buscar rádio', onChanged: notifier.setQuery),
            const SizedBox(height: 12),
            Expanded(
              child: _Body(
                state: state,
                onRetry: notifier.retry,
                onTapStation: (station) => context.push('/radio-detail', extra: station),
                onPlayTap: notifier.play,
                onFavoriteTap: (station) => notifier.toggleFavorite(station.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.onRetry,
    required this.onTapStation,
    required this.onPlayTap,
    required this.onFavoriteTap,
  });

  final RadioState state;
  final VoidCallback onRetry;
  final ValueChanged<RadioStation> onTapStation;
  final ValueChanged<RadioStation> onPlayTap;
  final ValueChanged<RadioStation> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          for (var i = 0; i < 4; i++) ...[
            const RadioStationTileSkeleton(),
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    if (state.error case final error?) {
      if (state.offline) return EmptyState.offline(onRetry: onRetry);
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Não foi possível carregar',
        message: error,
        onRetry: onRetry,
      );
    }

    final filtered = filterStations(state.stations, state.query);
    final favorites = filtered.where((s) => state.favoriteIds.contains(s.id)).toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).extension<AppColors>()!.primary,
            tabs: const [Tab(text: 'Todas'), Tab(text: 'Favoritas')],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _StationsList(
                  stations: filtered,
                  state: state,
                  onTapStation: onTapStation,
                  onPlayTap: onPlayTap,
                  onFavoriteTap: onFavoriteTap,
                ),
                _StationsList(
                  stations: favorites,
                  state: state,
                  onTapStation: onTapStation,
                  onPlayTap: onPlayTap,
                  onFavoriteTap: onFavoriteTap,
                  emptyTitle: 'Nenhuma rádio favoritada',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StationsList extends StatelessWidget {
  const _StationsList({
    required this.stations,
    required this.state,
    required this.onTapStation,
    required this.onPlayTap,
    required this.onFavoriteTap,
    this.emptyTitle = 'Nenhuma rádio encontrada',
  });

  final List<RadioStation> stations;
  final RadioState state;
  final ValueChanged<RadioStation> onTapStation;
  final ValueChanged<RadioStation> onPlayTap;
  final ValueChanged<RadioStation> onFavoriteTap;
  final String emptyTitle;

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return EmptyState(icon: Icons.radio_outlined, title: emptyTitle);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: stations.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final station = stations[index];
        return RadioStationTile(
          station: station,
          isPlaying: state.nowPlayingId == station.id && state.isPlaying,
          isBuffering: state.nowPlayingId == station.id && state.isBuffering,
          isFavorite: state.favoriteIds.contains(station.id),
          onTap: () => onTapStation(station),
          onPlayTap: () => onPlayTap(station),
          onFavoriteTap: () => onFavoriteTap(station),
        );
      },
    );
  }
}
