import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_bottom_bar.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/motion.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/icon_toggle_button.dart';
import '../../../core/widgets/pastel_chip.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';
import '../../downloads/widgets/download_button.dart';
import '../../library/view_model/is_subscribed_provider.dart';
import '../../player/view_model/player_view_model.dart';
import '../../player/widgets/episode_swipe_actions.dart';
import '../../player/widgets/queue_menu_button.dart';
import '../view_model/downloaded_episodes_provider.dart';
import '../view_model/episode_list_controls.dart';
import '../view_model/episode_progress_provider.dart';
import '../view_model/podcast_detail_view_model.dart';
import '../view_model/subscription_settings_provider.dart';
import 'subscription_settings_sheet.dart';

class PodcastDetailScreen extends ConsumerWidget {
  const PodcastDetailScreen({super.key, required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(podcastDetailViewModelProvider(podcast));
    final notifier = ref.read(podcastDetailViewModelProvider(podcast).notifier);

    final isSubscribed =
        ref.watch(isSubscribedProvider(podcast.id)).value ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          podcast.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (isSubscribed)
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: 'Ajustes do podcast',
              onPressed: () => showSubscriptionSettings(context, podcast.id),
            ),
        ],
      ),
      // Rota de topo (fora da casca) — monta o próprio mini-player + abas,
      // igual à tela de episódio, pra navegação não sumir.
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentShellTabIndex,
        builder: (context, index, _) => AppBottomBar(
          selectedIndex: index,
          onDestinationSelected: (i) => goToShellTab(context, i),
        ),
      ),
      body: SafeArea(
        top: false,
        child: detail.when(
          loading: () => _PodcastDetailBody(
            podcast: podcast,
            episodes: null,
            onSubscribe: notifier.subscribe,
            onUnsubscribe: notifier.unsubscribe,
          ),
          // Erro só na lista de episódios — header/artwork/subscribe/tabs
          // continuam visíveis e usáveis, igual ao caminho de loading.
          error: (error, _) => _PodcastDetailBody(
            podcast: podcast,
            episodes: null,
            episodesError: true,
            onEpisodesRetry: () =>
                ref.invalidate(podcastDetailViewModelProvider(podcast)),
            onSubscribe: notifier.subscribe,
            onUnsubscribe: notifier.unsubscribe,
          ),
          data: (state) => _PodcastDetailBody(
            podcast: state.podcast,
            episodes: state.episodes,
            onSubscribe: notifier.subscribe,
            onUnsubscribe: notifier.unsubscribe,
          ),
        ),
      ),
    );
  }
}

class _PodcastDetailBody extends ConsumerStatefulWidget {
  const _PodcastDetailBody({
    required this.podcast,
    required this.episodes,
    required this.onSubscribe,
    required this.onUnsubscribe,
    this.episodesError = false,
    this.onEpisodesRetry,
  });

  final Podcast podcast;

  /// `null` enquanto carrega (ou em erro, ver [episodesError]) — usado pra
  /// mostrar o skeleton.
  final List<Episode>? episodes;

  /// Erro de rede ao buscar episódios sem cache local pra cair. Só afeta a
  /// aba Episódios — header/artwork/subscribe/tabs continuam normais.
  final bool episodesError;
  final VoidCallback? onEpisodesRetry;

  final Future<void> Function() onSubscribe;
  final Future<void> Function() onUnsubscribe;

  @override
  ConsumerState<_PodcastDetailBody> createState() =>
      _PodcastDetailBodyState();
}

class _PodcastDetailBodyState extends ConsumerState<_PodcastDetailBody>
    with SingleTickerProviderStateMixin {
  // Altura da barra de busca colapsada — fixa, layout simples e conhecido.
  // A altura do header cheio varia (título pode quebrar linha) e por isso é
  // medida de verdade via `_headerKey`, nunca cortada.
  static const double _collapsedHeight = 76;

  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _headerKey = GlobalKey();
  // 0 = header cheio, 1 = totalmente colapsado (busca fixa). Atualizado a
  // cada pixel rolado — a suavidade vem do próprio gesto de scroll, sem
  // AnimationController: mais barato pro J5 que animar via ticker.
  final ValueNotifier<double> _collapseFraction = ValueNotifier(0);
  // Chute inicial até a primeira medição real do header (primeiro frame).
  double _headerHeight = 160;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  // Só colapsa na aba Episódios — Baixados não tem busca, o header fica
  // sempre visível lá.
  void _onTabChanged() {
    if (_tabController.index != 0) {
      _collapseFraction.value = 0;
    }
  }

  void _onScroll() {
    if (_tabController.index != 0) return;
    final range = _headerHeight - _collapsedHeight;
    if (range <= 0) return;
    _collapseFraction.value = (_scrollController.offset / range).clamp(
      0.0,
      1.0,
    );
  }

  void _measureHeader() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = _headerKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      if ((box.size.height - _headerHeight).abs() > 0.5) {
        setState(() => _headerHeight = box.size.height);
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _collapseFraction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isSubscribed =
        ref.watch(isSubscribedProvider(widget.podcast.id)).value ?? false;
    final controlsNotifier = ref.read(
      episodeListControlsProvider(widget.podcast.id).notifier,
    );
    _measureHeader();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<double>(
          valueListenable: _collapseFraction,
          builder: (context, t, _) {
            final height =
                _headerHeight -
                (_headerHeight - _collapsedHeight) * t;
            return SizedBox(
              height: height,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topCenter,
                  minHeight: 0,
                  maxHeight: double.infinity,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Opacity(
                        opacity: (1 - t * 1.6).clamp(0.0, 1.0),
                        child: IgnorePointer(
                          ignoring: t > 0.5,
                          child: Padding(
                            key: _headerKey,
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                            child: _Header(
                              podcast: widget.podcast,
                              isSubscribed: isSubscribed,
                              onSubscribe: widget.onSubscribe,
                              onUnsubscribe: widget.onUnsubscribe,
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: ((t - 0.4) / 0.6).clamp(0.0, 1.0),
                        child: IgnorePointer(
                          ignoring: t < 0.5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                            child: SearchField(
                              hintText: 'Buscar episódio',
                              onChanged: controlsNotifier.setQuery,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: colors.primary,
          labelColor: colors.textPrimary,
          unselectedLabelColor: colors.textMuted,
          tabs: const [
            Tab(text: 'Episódios'),
            Tab(text: 'Baixados'),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _EpisodesTab(
                podcast: widget.podcast,
                episodes: widget.episodes,
                isSubscribed: isSubscribed,
                scrollController: _scrollController,
                hasError: widget.episodesError,
                onRetry: widget.onEpisodesRetry,
              ),
              _DownloadsTab(podcast: widget.podcast),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.podcast,
    required this.isSubscribed,
    required this.onSubscribe,
    required this.onUnsubscribe,
  });

  final Podcast podcast;
  final bool isSubscribed;
  final Future<void> Function() onSubscribe;
  final Future<void> Function() onUnsubscribe;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'podcast-artwork-${podcast.id}',
              child: ClipRRect(
                borderRadius: AppRadii.mdAll,
                child: podcast.artworkUrl == null
                    ? _artworkFallback(colors, size: 96)
                    : CachedNetworkImage(
                        imageUrl: podcast.artworkUrl!,
                        width: 96,
                        height: 96,
                        memCacheWidth: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                        memCacheHeight: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const ShimmerBox(width: 96, height: 96),
                        errorWidget: (context, url, error) =>
                            _artworkFallback(colors, size: 96),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    podcast.author,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (podcast.genre case final genre?)
                        PastelChip(label: genre),
                      PastelChip(
                        label: podcast.episodeCount == 1
                            ? '1 episódio'
                            : '${podcast.episodeCount} episódios',
                        color: colors.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconToggleButton(
              selected: isSubscribed,
              iconSelected: Icons.check,
              iconUnselected: Icons.add,
              tooltipSelected: 'Assinado, toque pra cancelar',
              tooltipUnselected: 'Assinar',
              onPressed: () =>
                  isSubscribed ? onUnsubscribe() : onSubscribe(),
            ),
          ],
        ),
      ],
    );
  }
}

class _EpisodesTab extends ConsumerWidget {
  const _EpisodesTab({
    required this.podcast,
    required this.episodes,
    required this.isSubscribed,
    required this.scrollController,
    this.hasError = false,
    this.onRetry,
  });

  final Podcast podcast;
  final List<Episode>? episodes;
  final bool isSubscribed;
  final ScrollController scrollController;
  final bool hasError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (hasError) {
      return EmptyState(
        icon: Icons.wifi_off,
        title: 'Não foi possível carregar os episódios',
        message: 'Verifique sua conexão e tente de novo.',
        onRetry: onRetry,
      );
    }

    if (episodes == null) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          for (var i = 0; i < 4; i++) ...[
            const _EpisodeSkeleton(),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      );
    }

    if (episodes!.isEmpty) {
      return const EmptyState(
        icon: Icons.podcasts_outlined,
        title: 'Nenhum episódio encontrado',
        message: 'Esse feed não trouxe episódios dessa vez.',
      );
    }

    final controls = ref.watch(episodeListControlsProvider(podcast.id));
    final controlsNotifier = ref.read(
      episodeListControlsProvider(podcast.id).notifier,
    );
    final progress =
        ref.watch(episodeProgressProvider(podcast.id)).value ?? const {};
    final archived =
        ref.watch(archivedGuidsProvider(podcast.id)).value ?? const <String>{};
    final visible = applyEpisodeControls(
      episodes!,
      controls,
      progress,
      archivedGuids: archived,
    );

    // Item 0 = filtros/chips (rola junto da lista, igual ao comportamento
    // anterior); demais itens = episódios (ou o aviso de lista vazia).
    final itemCount = 1 + (visible.isEmpty ? 1 : visible.length);

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(podcastDetailViewModelProvider(podcast).notifier).refresh(),
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _EpisodeFilters(
                controls: controls,
                controlsNotifier: controlsNotifier,
                isSubscribed: isSubscribed,
                hasArchived: archived.isNotEmpty,
              ),
            );
          }
          if (visible.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Nenhum episódio com esse filtro.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          final episode = visible[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _EpisodeTile(
              podcast: podcast,
              episode: episode,
              queue: visible,
              isSubscribed: isSubscribed,
              progress: progress[episode.guid],
              isArchived: archived.contains(episode.guid),
            ),
          );
        },
      ),
    );
  }
}

class _EpisodeFilters extends StatelessWidget {
  const _EpisodeFilters({
    required this.controls,
    required this.controlsNotifier,
    required this.isSubscribed,
    required this.hasArchived,
  });

  final EpisodeListControlsState controls;
  final EpisodeListControls controlsNotifier;
  final bool isSubscribed;
  final bool hasArchived;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final f in EpisodeFilter.values) ...[
                      _SelectableChip(
                        label: _filterLabel(f),
                        selected: controls.filter == f,
                        onTap: () => controlsNotifier.setFilter(f),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ),
            _SortButton(
              current: controls.sort,
              onSelected: controlsNotifier.setSort,
            ),
          ],
        ),
        if (isSubscribed && (controls.showArchived || hasArchived)) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: _SelectableChip(
              label: controls.showArchived
                  ? 'Vendo arquivados'
                  : 'Mostrar arquivados',
              selected: controls.showArchived,
              onTap: controlsNotifier.toggleShowArchived,
            ),
          ),
        ],
      ],
    );
  }

  String _filterLabel(EpisodeFilter f) => switch (f) {
    EpisodeFilter.todos => 'Todos',
    EpisodeFilter.naoOuvidos => 'Não ouvidos',
    EpisodeFilter.ouvidos => 'Ouvidos',
  };
}

class _DownloadsTab extends ConsumerWidget {
  const _DownloadsTab({required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloaded = ref.watch(downloadedEpisodesProvider(podcast.id));
    final progress =
        ref.watch(episodeProgressProvider(podcast.id)).value ?? const {};

    return downloaded.when(
      loading: () => ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: const [
          _EpisodeSkeleton(),
          SizedBox(height: AppSpacing.sm),
          _EpisodeSkeleton(),
        ],
      ),
      error: (_, _) => const EmptyState(
        icon: Icons.error_outline,
        title: 'Não foi possível carregar',
        message: 'Os downloads desse podcast não vieram agora.',
      ),
      data: (episodes) {
        if (episodes.isEmpty) {
          return const EmptyState(
            icon: Icons.download_outlined,
            title: 'Nenhum episódio baixado',
            message: 'Baixe um episódio na aba ao lado pra ouvir sem internet.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final episode = episodes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _EpisodeTile(
                podcast: podcast,
                episode: episode,
                queue: episodes,
                isSubscribed: true,
                progress: progress[episode.guid],
                isArchived: false,
              ),
            );
          },
        );
      },
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          boxShadow: selected
              ? null
              : [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: selected ? colors.onAccent : colors.textMuted),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.current, required this.onSelected});

  final EpisodeSort current;
  final ValueChanged<EpisodeSort> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return PopupMenuButton<EpisodeSort>(
      initialValue: current,
      tooltip: 'Ordenar episódios',
      icon: Icon(Icons.sort, color: colors.textMuted),
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final s in EpisodeSort.values)
          PopupMenuItem(value: s, child: Text(_sortLabel(s))),
      ],
    );
  }

  String _sortLabel(EpisodeSort s) => switch (s) {
    EpisodeSort.recentes => 'Mais recentes',
    EpisodeSort.antigos => 'Mais antigos',
    EpisodeSort.maisLongos => 'Mais longos',
  };
}

class _EpisodeTile extends ConsumerWidget {
  const _EpisodeTile({
    required this.podcast,
    required this.episode,
    required this.queue,
    required this.isSubscribed,
    required this.isArchived,
    this.progress,
  });

  final Podcast podcast;
  final Episode episode;
  final List<Episode> queue;
  final bool isSubscribed;
  final bool isArchived;
  final EpisodeProgress? progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final player = ref.watch(playerViewModelProvider);
    final isCurrent = player.episode?.guid == episode.guid;

    return EpisodeSwipeActions(
      podcast: podcast,
      episode: episode,
      // Fila / marcar ouvido só valem pra assinatura.
      enabled: isSubscribed,
      child: SoftCard(
        // Tocar no tile abre a descrição do episódio — NÃO toca (Fase 8.3).
        // O play rápido fica no ícone à esquerda.
        onTap: () => context.push(
          '/episode',
          extra: (podcast: podcast, episode: episode, queue: queue),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EpisodeArtworkPlayButton(
              podcast: podcast,
              episode: episode,
              isCurrent: isCurrent,
              isPlaying: player.isPlaying,
              colors: colors,
              onPressed: () {
                final n = ref.read(playerViewModelProvider.notifier);
                if (isCurrent) {
                  n.togglePlayPause();
                } else {
                  unawaited(n.playEpisode(podcast, episode, autoPlay: true));
                }
              },
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _meta(episode),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (progress case final p?) ...[
                    const SizedBox(height: 8),
                    _EpisodeProgressLine(
                      progress: p,
                      duration: episode.duration,
                    ),
                  ],
                ],
              ),
            ),
            QueueMenuButton(
              podcast: podcast,
              episode: episode,
              manage: isSubscribed
                  ? (
                      isCompleted: progress?.completed ?? false,
                      isArchived: isArchived,
                      onToggleCompleted: () => ref
                          .read(libraryRepositoryProvider)
                          .setEpisodeCompleted(
                            podcast.id,
                            episode.guid,
                            !(progress?.completed ?? false),
                          ),
                      onToggleArchived: () => ref
                          .read(libraryRepositoryProvider)
                          .setEpisodeArchived(
                            podcast.id,
                            episode.guid,
                            !isArchived,
                          ),
                    )
                  : null,
            ),
            if (isSubscribed)
              DownloadButton(podcast: podcast, episode: episode),
          ],
        ),
      ),
    );
  }

  String _meta(Episode episode) {
    final parts = <String>[
      if (episode.publishedAt case final date?) _formatDate(date),
      if (episode.duration case final duration?) _formatDuration(duration),
    ];
    return parts.isEmpty ? 'Sem informações' : parts.join(' • ');
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h${minutes.toString().padLeft(2, '0')}min';
    return '${minutes}min';
  }
}

/// Capa do episódio (48x48) com o botão de play/pause sobreposto de forma
/// translúcida — mantém a capa visível por baixo do controle.
class _EpisodeArtworkPlayButton extends StatelessWidget {
  const _EpisodeArtworkPlayButton({
    required this.podcast,
    required this.episode,
    required this.isCurrent,
    required this.isPlaying,
    required this.colors,
    required this.onPressed,
  });

  final Podcast podcast;
  final Episode episode;
  final bool isCurrent;
  final bool isPlaying;
  final AppColors colors;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final artUrl = episode.imageUrl ?? podcast.artworkUrl;
    final playing = isCurrent && isPlaying;

    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: artUrl == null
                ? _fallback()
                : CachedNetworkImage(
                    imageUrl: artUrl,
                    width: 48,
                    height: 48,
                    memCacheWidth: (48 * MediaQuery.devicePixelRatioOf(context)).round(),
                    memCacheHeight: (48 * MediaQuery.devicePixelRatioOf(context)).round(),
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        const ShimmerBox(width: 48, height: 48),
                    errorWidget: (_, _, _) => _fallback(),
                  ),
          ),
          IconButton(
            icon: Icon(
              playing ? Icons.pause_circle_filled : Icons.play_circle_outline,
              color: Colors.white.withValues(alpha: 0.75),
              size: 32,
            ),
            tooltip: playing ? 'Pausar' : 'Tocar',
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  Widget _fallback() => Container(
    width: 48,
    height: 48,
    color: colors.primary.withValues(alpha: 0.5),
    child: Icon(Icons.graphic_eq, color: colors.textPrimary),
  );
}

/// Barra de progresso + selo "ouvido" abaixo do meta do episódio. Só
/// aparece quando existe progresso salvo (podcast assinado + já tocado).
class _EpisodeProgressLine extends StatelessWidget {
  const _EpisodeProgressLine({required this.progress, required this.duration});

  final EpisodeProgress progress;
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    // Texto/ícone de status = `textMuted` (contraste AA sobre o card). O
    // `secondary` (menta) só na barra de progresso — token de preenchimento,
    // não de texto.
    final style = Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: colors.textMuted);

    if (progress.completed) {
      return Row(
        children: [
          Icon(Icons.check_circle, size: 14, color: colors.textMuted),
          const SizedBox(width: 4),
          Text('Ouvido', style: style),
        ],
      );
    }

    if (progress.positionSeconds <= 0) return const SizedBox.shrink();

    final total = duration?.inSeconds ?? 0;
    final fraction = total > 0
        ? (progress.positionSeconds / total).clamp(0.0, 1.0)
        : null;
    final remaining = total > 0
        ? Duration(seconds: total - progress.positionSeconds)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 3,
            backgroundColor: colors.background,
            valueColor: AlwaysStoppedAnimation(colors.secondary),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          remaining == null ? 'Começado' : 'Faltam ${_minutes(remaining)}',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: colors.textMuted),
        ),
      ],
    );
  }

  String _minutes(Duration d) {
    final m = d.inMinutes;
    if (m >= 60) {
      return '${d.inHours}h${(m % 60).toString().padLeft(2, '0')}min';
    }
    return '${m}min';
  }
}

class _EpisodeSkeleton extends StatelessWidget {
  const _EpisodeSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          const ShimmerBox(
            width: 32,
            height: 32,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 16),
                SizedBox(height: 8),
                ShimmerBox(width: 120, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _artworkFallback(AppColors colors, {required double size}) {
  return Container(
    width: size,
    height: size,
    color: colors.primary.withValues(alpha: 0.5),
    child: Icon(Icons.graphic_eq, color: colors.textPrimary),
  );
}
