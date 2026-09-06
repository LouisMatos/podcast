import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/podcast.dart';
import '../view_model/library_view_model.dart';

/// Biblioteca do usuário — assinaturas reais, vindas do SQLite local via
/// `LibraryViewModel`. Atualiza sozinha quando o usuário assina/desassina
/// em qualquer tela, porque o ViewModel observa um `Stream` do drift.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptions = ref.watch(libraryViewModelProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text('Biblioteca', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Seus podcasts assinados', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Assinaturas'),
          AnimatedSwitcher(
            duration: AppMotion.base,
            switchInCurve: AppMotion.enter,
            switchOutCurve: AppMotion.standard,
            child: subscriptions.when(
              loading: () => const Column(
                key: ValueKey('loading'),
                children: [
                  _SubscriptionTileSkeleton(),
                  SizedBox(height: 12),
                  _SubscriptionTileSkeleton(),
                ],
              ),
              error: (error, _) => EmptyState(
                key: const ValueKey('error'),
                icon: Icons.error_outline,
                title: 'Não foi possível carregar sua biblioteca',
                onRetry: () => ref.invalidate(libraryViewModelProvider),
              ),
              data: (podcasts) => podcasts.isEmpty
                  ? const Padding(
                      key: ValueKey('empty'),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: EmptyState(
                        icon: Icons.library_music_outlined,
                        title: 'Nenhuma assinatura ainda',
                        message: 'Podcasts que você assinar aparecem aqui.',
                      ),
                    )
                  : Column(
                      key: ValueKey('subscriptions-${podcasts.length}'),
                      children: [
                        for (final podcast in podcasts) ...[
                          _SubscriptionTile(podcast: podcast),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionTile extends ConsumerWidget {
  const _SubscriptionTile({required this.podcast});

  final Podcast podcast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SoftCard(
      onTap: () => context.push('/library/podcast', extra: podcast),
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
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ShimmerBox(width: 48, height: 48),
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
                Text(
                  podcast.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: colors.primary),
            tooltip: 'Desassinar',
            onPressed: () => ref.read(libraryViewModelProvider.notifier).unsubscribe(podcast.id),
          ),
        ],
      ),
    );
  }

  Widget _artworkFallback(AppColors colors) {
    return Container(
      width: 48,
      height: 48,
      color: colors.secondary.withValues(alpha: 0.5),
      child: Icon(Icons.podcasts, color: colors.textPrimary),
    );
  }
}

class _SubscriptionTileSkeleton extends StatelessWidget {
  const _SubscriptionTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          const ShimmerBox(width: 48, height: 48, borderRadius: AppRadii.smAll),
          const SizedBox(width: 16),
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
