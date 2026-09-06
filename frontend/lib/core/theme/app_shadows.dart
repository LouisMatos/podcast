import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Sombra suave padrão do design system — é o que separa `surface` do
/// `background`, no lugar de `Divider`/borda.
abstract final class AppShadows {
  static List<BoxShadow> soft(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return [
      BoxShadow(color: colors.shadow, blurRadius: 24, offset: const Offset(0, 8)),
    ];
  }
}
