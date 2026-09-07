import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../downloads/widgets/download_button.dart';
import '../../library/view_model/is_subscribed_provider.dart';
import '../../player/view/mini_player.dart';
import '../../player/view_model/player_view_model.dart';

/// Tela de descrição de um episódio. Aberta ao selecionar um episódio na
/// lista — o player fica minimizado (mini-player no rodapé) e o áudio só
/// começa quando o usuário toca em "Tocar". "Abrir player" leva pra tela
/// cheia.
class EpisodeDetailScreen extends ConsumerWidget {
  const EpisodeDetailScreen({
    super.key,
    required this.podcast,
    required this.episode,
    required this.queue,
  });

  final Podcast podcast;
  final Episode episode;
  final List<Episode> queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final player = ref.watch(playerViewModelProvider);
    final isCurrent = player.episode?.guid == episode.guid;
    final isPlaying = isCurrent && player.isPlaying;
    final isSubscribed = ref.watch(isSubscribedProvider(podcast.id)).value ?? false;
    final artUrl = episode.imageUrl ?? podcast.artworkUrl;

    return Scaffold(
      appBar: AppBar(title: Text(podcast.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      bottomNavigationBar: const MiniPlayer(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Center(
              child: Hero(
                tag: 'episode-artwork-${episode.guid}',
                child: ClipRRect(
                  borderRadius: AppRadii.surfaceAll,
                  child: artUrl == null
                      ? Container(
                          width: 200,
                          height: 200,
                          color: colors.primary.withValues(alpha: 0.5),
                          child: Icon(Icons.graphic_eq, size: 56, color: colors.textPrimary),
                        )
                      : CachedNetworkImage(
                          imageUrl: artUrl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(episode.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              _meta(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PillButton(
                    label: isPlaying ? 'Pausar' : (isCurrent ? 'Retomar' : 'Tocar'),
                    icon: isPlaying ? Icons.pause : Icons.play_arrow,
                    onPressed: () {
                      final n = ref.read(playerViewModelProvider.notifier);
                      if (isCurrent) {
                        n.togglePlayPause();
                      } else {
                        n.playEpisode(podcast, episode, autoPlay: true);
                      }
                    },
                  ),
                ),
                if (isSubscribed) ...[
                  const SizedBox(width: 8),
                  DownloadButton(podcast: podcast, episode: episode),
                ],
              ],
            ),
            const SizedBox(height: 8),
            PillButton(
              label: 'Abrir player',
              icon: Icons.open_in_full,
              variant: PillButtonVariant.ghost,
              onPressed: () => context.push('/player'),
            ),
            const SizedBox(height: 8),
            _QueueActions(podcast: podcast, episode: episode, followingUp: _following()),
            const SizedBox(height: 20),
            SoftCard(
              child: _Description(html: episode.description),
            ),
          ],
        ),
      ),
    );
  }

  /// Episódios depois deste na lista de onde a tela foi aberta — pro
  /// "enfileirar os próximos".
  List<Episode> _following() {
    final i = queue.indexWhere((e) => e.guid == episode.guid);
    if (i < 0 || i + 1 >= queue.length) return const [];
    return queue.sublist(i + 1);
  }

  String _meta() {
    final parts = <String>[
      if (episode.publishedAt case final d?)
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}',
      if (episode.duration case final dur?) _formatDuration(dur),
    ];
    return parts.isEmpty ? 'Sem informações' : parts.join(' • ');
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h${m.toString().padLeft(2, '0')}min';
    return '${m}min';
  }
}

/// Ações de fila da tela de episódio (Fase 12). "Enfileirar próximos" só
/// aparece quando a tela foi aberta a partir de uma lista com episódios
/// depois deste.
class _QueueActions extends ConsumerWidget {
  const _QueueActions({required this.podcast, required this.episode, required this.followingUp});

  final Podcast podcast;
  final Episode episode;
  final List<Episode> followingUp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(playerViewModelProvider.notifier);

    void toast(String msg) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        PillButton(
          label: 'Tocar a seguir',
          icon: Icons.playlist_play,
          variant: PillButtonVariant.ghost,
          onPressed: () {
            n.playNext(podcast, episode);
            toast('Toca a seguir');
          },
        ),
        PillButton(
          label: 'Adicionar à fila',
          icon: Icons.playlist_add,
          variant: PillButtonVariant.ghost,
          onPressed: () {
            n.enqueue(podcast, episode);
            toast('Adicionado à fila');
          },
        ),
        if (followingUp.isNotEmpty)
          PillButton(
            label: 'Enfileirar próximos (${followingUp.length})',
            icon: Icons.queue_music,
            variant: PillButtonVariant.ghost,
            onPressed: () {
              n.enqueueAll(podcast, followingUp);
              toast('${followingUp.length} episódios na fila');
            },
          ),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.html});

  final String? html;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    if (html == null || html!.trim().isEmpty) {
      return Text(
        'Esse episódio não trouxe uma descrição.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
      );
    }

    return HtmlWidget(
      html!,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      onTapUrl: (url) => launchInBrowser(context, url),
    );
  }

  /// Sem `url_launcher` no projeto — links da descrição não abrem por
  /// enquanto, mas não quebram o layout. (Backlog.)
  bool launchInBrowser(BuildContext context, String url) => false;
}
