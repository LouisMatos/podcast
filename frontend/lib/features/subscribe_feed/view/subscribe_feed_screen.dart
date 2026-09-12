import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_bottom_bar.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../view_model/subscribe_feed_state.dart';
import '../view_model/subscribe_feed_view_model.dart';

/// Tela "assinar este feed RSS", aberta por um deep link `http(s)://…`
/// (intent VIEW de outro app apontando pra um feed).
class SubscribeFeedScreen extends ConsumerWidget {
  const SubscribeFeedScreen({super.key, required this.feedUrl});

  final String feedUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscribeFeedViewModelProvider(feedUrl));
    final notifier = ref.read(subscribeFeedViewModelProvider(feedUrl).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Assinar feed')),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentShellTabIndex,
        builder: (context, index, _) => AppBottomBar(
          selectedIndex: index,
          onDestinationSelected: (i) => goToShellTab(context, i),
        ),
      ),
      body: SafeArea(
        top: false,
        child: _body(context, state, notifier),
      ),
    );
  }

  Widget _body(BuildContext context, SubscribeFeedState state, SubscribeFeedViewModel notifier) {
    if (state.isLoading) return const _LoadingCard();

    if (state.error case final error?) {
      return EmptyState(
        icon: Icons.rss_feed,
        title: 'Feed indisponível',
        message: error,
      );
    }

    final podcast = state.podcast;
    if (podcast == null) {
      return const EmptyState(icon: Icons.rss_feed, title: 'Feed indisponível');
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        _FeedCard(
          title: podcast.title,
          artworkUrl: podcast.artworkUrl,
          episodeCount: state.episodes.length,
        ),
        const SizedBox(height: 24),
        Center(
          child: state.alreadySubscribed
              ? const PillButton(
                  label: 'Já assinado',
                  icon: Icons.check,
                  variant: PillButtonVariant.secondary,
                  onPressed: null,
                )
              : PillButton(
                  label: 'Assinar',
                  icon: Icons.add,
                  onPressed: () async {
                    await notifier.subscribe();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text('Assinado')));
                    context.go('/library');
                  },
                ),
        ),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({required this.title, required this.artworkUrl, required this.episodeCount});

  final String title;
  final String? artworkUrl;
  final int episodeCount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SoftCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: artworkUrl == null
                ? _fallback(colors)
                : CachedNetworkImage(
                    imageUrl: artworkUrl!,
                    width: 96,
                    height: 96,
                    memCacheWidth: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                    memCacheHeight: (96 * MediaQuery.devicePixelRatioOf(context)).round(),
                    fit: BoxFit.cover,
                    placeholder: (_, _) => _fallback(colors),
                    errorWidget: (_, _, _) => _fallback(colors),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  episodeCount == 1 ? '1 episódio' : '$episodeCount episódios',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback(AppColors colors) {
    return Container(
      width: 96,
      height: 96,
      color: colors.primary.withValues(alpha: 0.5),
      child: Icon(Icons.rss_feed, color: colors.textPrimary),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: const [
        SoftCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 96, height: 96, borderRadius: AppRadii.smAll),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 16),
                    SizedBox(height: 8),
                    ShimmerBox(width: 100, height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
