import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/prefs/preferences_store.dart';

/// Preferência de tema do usuário. Persistida via [PreferencesStore] — a
/// escolha sobrevive ao restart do app.
///
/// Não usa `ThemeMode` do Flutter aqui de propósito — um ViewModel não
/// importa `package:flutter/material.dart` (ver docs/ARCHITECTURE.md). A
/// tradução pra `ThemeMode` acontece em `app.dart`, na View.
enum AppThemeMode { light, dark, system }

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    final name = ref.read(preferencesStoreProvider).themeModeName;
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => AppThemeMode.system,
    );
  }

  void set(AppThemeMode mode) {
    state = mode;
    ref.read(preferencesStoreProvider).setThemeModeName(mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, AppThemeMode>(ThemeModeNotifier.new);
