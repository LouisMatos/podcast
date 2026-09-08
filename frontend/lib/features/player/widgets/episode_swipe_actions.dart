import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/queue_repository.dart';

/// Envolve um tile de episódio com gestos de swipe (Fase 15):
/// → adiciona à fila (fim), ← marca como ouvido. Nenhum gesto remove o
/// tile — cada um é uma ação, com `SnackBar` de "Desfazer"; o `Dismissible`
/// volta pro lugar sozinho (`confirmDismiss` sempre retorna `false`).
class EpisodeSwipeActions extends ConsumerWidget {
  const EpisodeSwipeActions({
    super.key,
    required this.podcast,
    required this.episode,
    required this.child,
    this.enabled = true,
  });

  final Podcast podcast;
  final Episode episode;
  final Widget child;

  /// Só faz sentido pra podcast assinado (fila / marcar ouvido). Quando
  /// `false`, devolve o [child] direto, sem `Dismissible`.
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled) return child;

    final colors = Theme.of(context).extension<AppColors>()!;
    final noAnim = MediaQuery.disableAnimationsOf(context);

    return Dismissible(
      key: ValueKey('ep-swipe-${episode.guid}'),
      movementDuration: noAnim ? Duration.zero : AppMotion.fast,
      // Nunca some de fato — a ação roda no confirmDismiss e ele retorna
      // false, então o resize de remoção não acontece.
      resizeDuration: null,
      background: _SwipeBackground(
        color: colors.secondary,
        foreground: colors.onAccent,
        icon: Icons.playlist_add,
        label: 'Fila',
        toStart: true,
      ),
      secondaryBackground: _SwipeBackground(
        color: colors.accent,
        foreground: colors.onAccent,
        icon: Icons.check_circle,
        label: 'Ouvido',
        toStart: false,
      ),
      confirmDismiss: (direction) async {
        final messenger = ScaffoldMessenger.of(context);
        unawaited(HapticFeedback.selectionClick());

        final toQueue = direction == DismissDirection.startToEnd;
        if (toQueue) {
          await ref.read(queueRepositoryProvider).addToEnd(podcast, episode);
        } else {
          await ref
              .read(libraryRepositoryProvider)
              .setEpisodeCompleted(podcast.id, episode.guid, true);
        }

        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                toQueue ? 'Adicionado à fila' : 'Marcado como ouvido',
              ),
              action: SnackBarAction(
                label: 'Desfazer',
                onPressed: () {
                  if (toQueue) {
                    unawaited(
                      ref
                          .read(queueRepositoryProvider)
                          .removeEpisode(podcast.id, episode.guid),
                    );
                  } else {
                    unawaited(
                      ref
                          .read(libraryRepositoryProvider)
                          .setEpisodeCompleted(podcast.id, episode.guid, false),
                    );
                  }
                },
              ),
            ),
          );

        // Ação, não exclusão: o tile volta pro lugar com a animação nativa.
        return false;
      },
      child: child,
    );
  }
}

/// Fundo colorido que aparece atrás do tile enquanto se arrasta. Cantos
/// iguais aos do `SoftCard` (`AppRadii.mdAll`).
class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.color,
    required this.foreground,
    required this.icon,
    required this.label,
    required this.toStart,
  });

  final Color color;
  final Color foreground;
  final IconData icon;
  final String label;

  /// `true`: gesto pra direita (ícone/label alinhados à esquerda).
  final bool toStart;

  @override
  Widget build(BuildContext context) {
    final content = [
      Icon(icon, color: foreground),
      const SizedBox(width: 8),
      Text(
        label,
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: foreground),
      ),
    ];

    return Container(
      decoration: BoxDecoration(color: color, borderRadius: AppRadii.mdAll),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: toStart ? Alignment.centerLeft : Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: toStart ? content : content.reversed.toList(),
      ),
    );
  }
}
