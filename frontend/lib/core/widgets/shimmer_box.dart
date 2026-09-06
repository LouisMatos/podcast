import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/motion.dart';

/// Placeholder de carregamento: pulso suave e lento. Nunca um spinner
/// girando — combina mais com o resto do movimento do app.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, this.width, this.height = 16, this.borderRadius});

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.slow,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final radius = widget.borderRadius ?? AppRadii.smAll;

    if (MediaQuery.of(context).disableAnimations) {
      return _box(colors, radius, 0.18);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => _box(colors, radius, 0.12 + _controller.value * 0.14),
    );
  }

  Widget _box(AppColors colors, BorderRadius radius, double alpha) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(color: colors.textMuted.withValues(alpha: alpha), borderRadius: radius),
    );
  }
}
