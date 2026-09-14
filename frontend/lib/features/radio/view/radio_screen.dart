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
class RadioScreen extends ConsumerStatefulWidget {
  const RadioScreen({super.key});

  @override
  ConsumerState<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends ConsumerState<RadioScreen> {
  final GlobalKey _titleKey = GlobalKey();
  final ScrollController _allController = ScrollController();
  final ScrollController _favController = ScrollController();
  final ValueNotifier<double> _collapseFraction = ValueNotifier(0);
  // Chute inicial até a primeira medição real do bloco título (primeiro
  // frame) — evita corte de conteúdo antes de medir.
  double _titleHeight = 76;

  @override
  void initState() {
    super.initState();
    _allController.addListener(_onScroll);
    _favController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_titleHeight <= 0) return;
    final offset = _allController.hasClients && _allController.position.hasPixels
        ? _allController.offset
        : (_favController.hasClients && _favController.position.hasPixels
              ? _favController.offset
              : 0.0);
    _collapseFraction.value = (offset / _titleHeight).clamp(0.0, 1.0);
  }

  void _measureTitle() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = _titleKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      if ((box.size.height - _titleHeight).abs() > 0.5) {
        setState(() => _titleHeight = box.size.height);
      }
    });
  }

  @override
  void dispose() {
    _allController.removeListener(_onScroll);
    _allController.dispose();
    _favController.removeListener(_onScroll);
    _favController.dispose();
    _collapseFraction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(radioViewModelProvider);
    final notifier = ref.read(radioViewModelProvider.notifier);
    _measureTitle();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: _collapseFraction,
              builder: (context, t, _) {
                final height = _titleHeight * (1 - t);
                return ClipRect(
                  child: SizedBox(
                    height: height,
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      minHeight: 0,
                      maxHeight: double.infinity,
                      child: Opacity(
                        opacity: (1 - t * 1.6).clamp(0.0, 1.0),
                        child: Column(
                          key: _titleKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rádio',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rádios brasileiras ao vivo',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SearchField(hintText: 'Buscar rádio', onChanged: notifier.setQuery),
            const SizedBox(height: 12),
            Expanded(
              child: _Body(
                state: state,
                allController: _allController,
                favController: _favController,
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
    required this.allController,
    required this.favController,
    required this.onRetry,
    required this.onTapStation,
    required this.onPlayTap,
    required this.onFavoriteTap,
  });

  final RadioState state;
  final ScrollController allController;
  final ScrollController favController;
  final VoidCallback onRetry;
  final ValueChanged<RadioStation> onTapStation;
  final ValueChanged<RadioStation> onPlayTap;
  final ValueChanged<RadioStation> onFavoriteTap;

  // TabBar sempre visível/tocável, mesmo durante loading/erro — só o
  // conteúdo de cada aba (skeleton, erro ou lista) muda independente. Antes,
  // loading/erro trocavam TabBar+TabBarView inteiros por um só bloco,
  // escondendo "Todas"/"Favoritas" e a troca de aba enquanto carregava.
  Widget _tabContent(
    List<RadioStation> stations,
    ScrollController controller, {
    String emptyTitle = 'Nenhuma rádio encontrada',
  }) {
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

    return _StationsList(
      stations: stations,
      state: state,
      scrollController: controller,
      onTapStation: onTapStation,
      onPlayTap: onPlayTap,
      onFavoriteTap: onFavoriteTap,
      emptyTitle: emptyTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasData = !state.isLoading && state.error == null;
    final filtered = hasData ? filterStations(state.stations, state.query) : const <RadioStation>[];
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
                _tabContent(filtered, allController),
                _tabContent(favorites, favController, emptyTitle: 'Nenhuma rádio favoritada'),
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
    required this.scrollController,
    required this.onTapStation,
    required this.onPlayTap,
    required this.onFavoriteTap,
    this.emptyTitle = 'Nenhuma rádio encontrada',
  });

  final List<RadioStation> stations;
  final RadioState state;
  final ScrollController scrollController;
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
      controller: scrollController,
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
