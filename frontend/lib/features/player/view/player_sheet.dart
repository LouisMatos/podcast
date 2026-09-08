import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import 'player_screen.dart';

/// Abre o player como sheet arrastável (Fase 15.1). Arrastar pra baixo fecha
/// — o `showModalBottomSheet` cuida disso (`enableDrag` default). O deep link
/// `/player` continua abrindo a `PlayerScreen` em tela cheia.
Future<void> showPlayerSheet(BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: colors.surface,
    barrierColor: Colors.black54,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadii.surface),
      ),
    ),
    builder: (_) => const _PlayerSheet(),
  );
}

class _PlayerSheet extends StatelessWidget {
  const _PlayerSheet();

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(heightFactor: 0.94, child: PlayerView());
  }
}
