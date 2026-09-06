import 'package:flutter/material.dart';

/// Paleta pastel do design system. Ver docs/DESIGN_SYSTEM.md na raiz do
/// repositório para o racional de cada tom.
///
/// Regra de ouro: nenhum widget escreve uma `Color(0x...)` solta — sempre
/// via `Theme.of(context).extension<AppColors>()!`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textMuted,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textMuted;
  final Color shadow;

  static const AppColors light = AppColors(
    background: Color(0xFFFAF7F5),
    surface: Color(0xFFFFFFFF),
    primary: Color(0xFFB8AEE8),
    secondary: Color(0xFFA8D8C8),
    accent: Color(0xFFF5C6AA),
    textPrimary: Color(0xFF3A3542),
    textMuted: Color(0xFF8B8493),
    shadow: Color(0x0F000000),
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF1E1B24),
    surface: Color(0xFF282430),
    primary: Color(0xFF9A8FC7),
    secondary: Color(0xFF86B8A8),
    accent: Color(0xFFD9A98A),
    textPrimary: Color(0xFFEDEAF2),
    textMuted: Color(0xFFA79FB0),
    shadow: Color(0x40000000),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? textPrimary,
    Color? textMuted,
    Color? shadow,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
