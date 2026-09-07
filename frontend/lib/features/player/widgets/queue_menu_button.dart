import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../view_model/player_view_model.dart';

enum _QueueAction { playNext, addToEnd }

/// Menu "⋮" nos tiles de episódio: enfileirar sem sair da tela (Fase 12).
class QueueMenuButton extends ConsumerWidget {
  const QueueMenuButton({super.key, required this.podcast, required this.episode});

  final Podcast podcast;
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return PopupMenuButton<_QueueAction>(
      icon: Icon(Icons.more_vert, color: colors.textMuted),
      tooltip: 'Fila',
      onSelected: (action) {
        final notifier = ref.read(playerViewModelProvider.notifier);
        final messenger = ScaffoldMessenger.of(context);
        switch (action) {
          case _QueueAction.playNext:
            notifier.playNext(podcast, episode);
            messenger.showSnackBar(const SnackBar(content: Text('Toca a seguir')));
          case _QueueAction.addToEnd:
            notifier.enqueue(podcast, episode);
            messenger.showSnackBar(const SnackBar(content: Text('Adicionado à fila')));
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _QueueAction.playNext,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.playlist_play),
            title: Text('Tocar a seguir'),
          ),
        ),
        PopupMenuItem(
          value: _QueueAction.addToEnd,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.playlist_add),
            title: Text('Adicionar à fila'),
          ),
        ),
      ],
    );
  }
}
