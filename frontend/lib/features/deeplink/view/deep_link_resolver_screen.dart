import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/episode.dart';
import '../../../services/deeplinks/deep_link_service.dart';
import '../../podcast_detail/view_model/podcast_by_id_provider.dart';
import '../../subscribe_feed/view/subscribe_feed_screen.dart';
import '../view_model/deep_link_resolution.dart';

/// Tela-ponte de um deep link: spinner enquanto resolve o alvo, então
/// `pushReplacement` pra tela real. `DeepLinkFeed` não resolve nada —
/// renderiza a tela de "assinar feed" direto.
class DeepLinkResolverScreen extends ConsumerStatefulWidget {
  const DeepLinkResolverScreen({super.key, required this.target});

  final DeepLinkTarget target;

  @override
  ConsumerState<DeepLinkResolverScreen> createState() => _DeepLinkResolverScreenState();
}

class _DeepLinkResolverScreenState extends ConsumerState<DeepLinkResolverScreen> {
  bool _handled = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    switch (widget.target) {
      case DeepLinkFeed(:final url):
        return SubscribeFeedScreen(feedUrl: url);

      case DeepLinkPodcast(:final id):
        final async = ref.watch(podcastByIdProvider(id));
        _consume(
          async,
          onData: (podcast) => podcast == null
              ? _fail('Podcast não encontrado')
              : _replace('/podcast', podcast),
          failMessage: 'Não foi possível abrir o podcast',
        );

      case DeepLinkEpisode(:final podcastId, :final guid):
        final async = ref.watch(resolvedDeepLinkEpisodeProvider(podcastId, guid));
        _consume(
          async,
          onData: (resolved) => resolved == null
              ? _fail('Episódio não encontrado')
              : _replace('/episode', (
                  podcast: resolved.podcast,
                  episode: resolved.episode,
                  queue: <Episode>[resolved.episode],
                )),
          failMessage: 'Não foi possível abrir o episódio',
        );

      case DeepLinkUnknown():
        _after(() => _leave());
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(child: CircularProgressIndicator(color: colors.primary)),
    );
  }

  /// Age uma vez quando o [AsyncValue] sai de `loading` — navega no `data`,
  /// mostra erro no `error`.
  void _consume<T>(
    AsyncValue<T> async, {
    required void Function(T value) onData,
    required String failMessage,
  }) {
    if (_handled) return;
    async.when(
      loading: () {},
      data: (value) {
        _handled = true;
        _after(() => onData(value));
      },
      error: (_, _) {
        _handled = true;
        _after(() => _fail(failMessage));
      },
    );
  }

  void _after(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) fn();
    });
  }

  void _replace(String location, Object extra) {
    if (!mounted) return;
    context.pushReplacement(location, extra: extra);
  }

  void _fail(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    _leave();
  }

  void _leave() {
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }
}
