import 'package:flutter/material.dart';

/// Tipografia do design system: Nunito, terminais arredondados combinando
/// com a forma do resto do app. Pesos 400/600/700; títulos com
/// `letterSpacing` levemente negativo.
///
/// Fonte vendorizada em `assets/fonts/` (não via google_fonts) pra não
/// depender de fetch de rede no primeiro uso em aparelho fraco/offline.
abstract final class AppTypography {
  static TextTheme textTheme({
    required Color primary,
    required Color muted,
    required Brightness brightness,
  }) {
    final base = (brightness == Brightness.dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme)
        .apply(fontFamily: 'Nunito');

    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: primary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: primary,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(fontWeight: FontWeight.w400, color: primary),
      bodyMedium: base.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: muted),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: primary),
      labelSmall: base.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: primary),
    );
  }
}
