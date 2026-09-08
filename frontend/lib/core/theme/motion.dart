import 'package:flutter/material.dart';

/// Durações e curvas de animação do app. Toda animação deve vir daqui —
/// nunca `Curves.linear`, nunca "bounce". Movimento é lento e suave.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration base = Duration(milliseconds: 450);
  static const Duration slow = Duration(milliseconds: 700);
  static const Duration page = Duration(milliseconds: 550);

  /// Duração efetiva — `Duration.zero` quando o usuário pediu menos animação
  /// (`MediaQuery.disableAnimations`). Todo widget animado adicionado na
  /// Fase 15 passa por aqui (`docs/DESIGN_SYSTEM.md`).
  static Duration effective(BuildContext context, Duration duration) =>
      (MediaQuery.maybeDisableAnimationsOf(context) ?? false)
      ? Duration.zero
      : duration;

  /// Entrada de elemento novo na tela.
  static const Curve enter = Curves.easeOutCubic;

  /// Transformação de um estado visual pro outro (expandir, mover).
  static const Curve transform = Curves.easeInOutCubicEmphasized;

  /// Padrão geral quando nenhuma das duas acima se aplica.
  static const Curve standard = Curves.easeInOut;
}
