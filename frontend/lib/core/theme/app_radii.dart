import 'package:flutter/material.dart';

/// Raios do design system. Sem borda dura em lugar nenhum do app — só
/// cantos arredondados e sombra suave pra separar superfícies.
abstract final class AppRadii {
  static const double sm = 16;
  static const double md = 24;
  static const double surface = 32;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius surfaceAll = BorderRadius.all(Radius.circular(surface));

  /// Raio total — usado em botões e chips (`StadiumBorder`/pílula).
  static const double pill = 999;
}
