import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../../../core/widgets/pastel_chip.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/podcast.dart';
import '../view_model/discover_state.dart';
import '../view_model/discover_view_model.dart';

/// Tela de descoberta: busca podcasts na iTunes Search API
/// (`DiscoverViewModel` cuida do debounce e do estado).
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoverViewModelProvider);
    final notifier = ref.read(discoverViewModelProvider.notifier);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text('Descobrir', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Encontre seu próximo podcast favorito', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          _SearchField(onChanged: notifier.onQueryChanged),
          const SizedBox(height: 24),
          SectionHeader(title: state.query.isEmpty ? 'Descubra podcasts' : 'Resultados'),
          AnimatedSwitcher(
            duration: AppMotion.base,
            switchInCurve: AppMotion.enter,
            switchOutCurve: AppMotion.standard,
            child: _DiscoverBody(key: ValueKey(_bodyKey(state)), state: state),
          ),
        ],
      ),
    );
  }

  String _bodyKey(DiscoverState state) {
    if (state.query.isEmpty) return 'idle';
    if (state.isLoading) return 'loading';
    if (state.error != null) return 'error';
    return 'results-${state.query}-${state.results.length}';
  }
}

class _DiscoverBody extends StatelessWidget {
  const _DiscoverBody({super.key, required this.state});

  final DiscoverState state;

  @override
  Widget build(BuildContext context) {
    if (state.query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
          'Busque por um podcast ou categoria acima.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.isLoading) {
      return Column(
        children: [
          for (var i = 0; i < 3; i++) ...[
            const _PodcastTileSkeleton(),
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    if (state.error case final error?) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(error, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
      );
    }

    if (state.results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
          'Nenhum resultado pra "${state.query}"',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        for (final podcast in state.results) ...[
          _PodcastTile(podcast: podcast),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Buscar podcast ou categoria',
          hintStyle: TextStyle(color: colors.textMuted),
          prefixIcon: Icon(Icons.search, color: colors.textMuted),
          border: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class _PodcastTile extends StatelessWidget {
  const _PodcastTile({required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SoftCard(
      onTap: () => context.push('/discover/podcast', extra: podcast),
      child: Row(
        children: [
          Hero(
            tag: 'podcast-artwork-${podcast.id}',
            child: ClipRRect(
              borderRadius: AppRadii.smAll,
              child: podcast.artworkUrl == null
                  ? _artworkFallback(colors)
                  : CachedNetworkImage(
                      imageUrl: podcast.artworkUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerBox(width: 56, height: 56),
                      errorWidget: (context, url, error) => _artworkFallback(colors),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  podcast.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (podcast.genre case final genre?) ...[
            const SizedBox(width: 12),
            PastelChip(label: genre),
          ],
        ],
      ),
    );
  }

  Widget _artworkFallback(AppColors colors) {
    return Container(
      width: 56,
      height: 56,
      color: colors.primary.withValues(alpha: 0.5),
      child: Icon(Icons.graphic_eq, color: colors.textPrimary),
    );
  }
}

class _PodcastTileSkeleton extends StatelessWidget {
  const _PodcastTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          const ShimmerBox(width: 56, height: 56, borderRadius: AppRadii.smAll),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
