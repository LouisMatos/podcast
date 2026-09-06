import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preferência de tema do usuário.
///
/// Não usa `ThemeMode` do Flutter aqui de propósito — um ViewModel não
/// importa `package:flutter/material.dart` (ver docs/ARCHITECTURE.md). A
/// tradução pra `ThemeMode` acontece em `app.dart`, na View.
enum AppThemeMode { light, dark, system }

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() => AppThemeMode.system;

  void set(AppThemeMode mode) => state = mode;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, AppThemeMode>(ThemeModeNotifier.new);
