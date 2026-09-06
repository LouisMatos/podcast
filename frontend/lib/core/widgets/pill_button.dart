import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/motion.dart';

enum PillButtonVariant { primary, secondary, ghost }

/// Botão em pílula (raio total) do design system.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = PillButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PillButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final (background, foreground) = switch (variant) {
      PillButtonVariant.primary => (colors.primary, colors.onAccent),
      PillButtonVariant.secondary => (colors.secondary, colors.onAccent),
      PillButtonVariant.ghost => (Colors.transparent, colors.textPrimary),
    };

    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.standard,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppRadii.pill)),
      child: Material(
        color: Colors.transparent,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: foreground),
                  const SizedBox(width: 8),
                ],
                Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: foreground)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
