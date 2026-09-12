import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/motion.dart';

/// Botão circular compacto, só ícone, pra ações de dois estados (ex.
/// assinar/assinado) onde um `PillButton` com texto ocuparia espaço demais.
class IconToggleButton extends StatelessWidget {
  const IconToggleButton({
    super.key,
    required this.selected,
    required this.iconSelected,
    required this.iconUnselected,
    required this.tooltipSelected,
    required this.tooltipUnselected,
    required this.onPressed,
    this.size = 40,
  });

  final bool selected;
  final IconData iconSelected;
  final IconData iconUnselected;
  final String tooltipSelected;
  final String tooltipUnselected;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final background = selected ? colors.secondary : colors.primary;

    return Tooltip(
      message: selected ? tooltipSelected : tooltipUnselected,
      child: AnimatedContainer(
        duration: AppMotion.effective(context, AppMotion.fast),
        curve: AppMotion.standard,
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Center(
              child: Icon(
                selected ? iconSelected : iconUnselected,
                size: 18,
                color: colors.onAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
