import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../services/share/episode_share.dart';
import '../view_model/player_view_model.dart';

/// Ações extras de "marcar ouvido" / "arquivar" (Fase 13), só pra episódio
/// de podcast assinado. `null` = menu só com as ações de fila.
typedef EpisodeManageActions = ({
  bool isCompleted,
  bool isArchived,
  Future<void> Function() onToggleCompleted,
  Future<void> Function() onToggleArchived,
});

enum _Action { playNext, addToEnd, share, toggleCompleted, toggleArchived }

/// Menu "⋮" nos tiles de episódio: enfileirar sem sair da tela (Fase 12) +
/// marcar ouvido / arquivar (Fase 13).
class QueueMenuButton extends ConsumerWidget {
  const QueueMenuButton({
    super.key,
    required this.podcast,
    required this.episode,
    this.manage,
  });

  final Podcast podcast;
  final Episode episode;
  final EpisodeManageActions? manage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return PopupMenuButton<_Action>(
      icon: Icon(Icons.more_vert, color: colors.textMuted),
      tooltip: 'Mais',
      onSelected: (action) {
        final notifier = ref.read(playerViewModelProvider.notifier);
        final messenger = ScaffoldMessenger.of(context);
        switch (action) {
          case _Action.playNext:
            notifier.playNext(podcast, episode);
            messenger.showSnackBar(const SnackBar(content: Text('Toca a seguir')));
          case _Action.addToEnd:
            notifier.enqueue(podcast, episode);
            messenger.showSnackBar(const SnackBar(content: Text('Adicionado à fila')));
          case _Action.share:
            shareEpisode(episode: episode, podcast: podcast);
          case _Action.toggleCompleted:
            manage!.onToggleCompleted();
            messenger.showSnackBar(SnackBar(
              content: Text(manage!.isCompleted ? 'Marcado como não ouvido' : 'Marcado como ouvido'),
            ));
          case _Action.toggleArchived:
            manage!.onToggleArchived();
            messenger.showSnackBar(SnackBar(
              content: Text(manage!.isArchived ? 'Desarquivado' : 'Arquivado'),
            ));
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _Action.playNext,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.playlist_play),
            title: Text('Tocar a seguir'),
          ),
        ),
        const PopupMenuItem(
          value: _Action.addToEnd,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.playlist_add),
            title: Text('Adicionar à fila'),
          ),
        ),
        const PopupMenuItem(
          value: _Action.share,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.ios_share),
            title: Text('Compartilhar'),
          ),
        ),
        if (manage case final m?) ...[
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _Action.toggleCompleted,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(m.isCompleted ? Icons.unpublished_outlined : Icons.check_circle_outline),
              title: Text(m.isCompleted ? 'Marcar como não ouvido' : 'Marcar como ouvido'),
            ),
          ),
          PopupMenuItem(
            value: _Action.toggleArchived,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(m.isArchived ? Icons.unarchive_outlined : Icons.archive_outlined),
              title: Text(m.isArchived ? 'Desarquivar' : 'Arquivar'),
            ),
          ),
        ],
      ],
    );
  }
}
