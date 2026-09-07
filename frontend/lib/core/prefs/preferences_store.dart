import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_store.g.dart';

/// Preferências do usuário que sobrevivem ao restart do app (tema,
/// volume, velocidade, equalizador). É o único lugar do app que fala com
/// `SharedPreferences` — o resto usa este store por trás de um provider.
///
/// Posição de escuta e assinaturas NÃO moram aqui — isso é drift
/// (`LibraryRepository`). Aqui só ficam ajustes leves de UI/player.
class PreferencesStore {
  PreferencesStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kThemeMode = 'pref.theme_mode';
  static const _kVolume = 'pref.volume';
  static const _kSpeed = 'pref.playback_speed';
  static const _kEqualizerEnabled = 'pref.equalizer_enabled';
  static const _kEqualizerGains = 'pref.equalizer_gains';
  static const _kBackgroundRefresh = 'pref.background_refresh_enabled';
  static const _kNewEpisodeNotifications = 'pref.new_episode_notifications';
  static const _kRefreshWifiOnly = 'pref.refresh_wifi_only';

  /// Nome do `AppThemeMode` (a tradução pro enum fica no ViewModel, pra
  /// não acoplar `core/` a `features/settings/`).
  String? get themeModeName => _prefs.getString(_kThemeMode);
  Future<void> setThemeModeName(String name) => _prefs.setString(_kThemeMode, name);

  double get volume => _prefs.getDouble(_kVolume) ?? 1.0;
  Future<void> setVolume(double value) => _prefs.setDouble(_kVolume, value);

  double get playbackSpeed => _prefs.getDouble(_kSpeed) ?? 1.0;
  Future<void> setPlaybackSpeed(double value) => _prefs.setDouble(_kSpeed, value);

  bool get equalizerEnabled => _prefs.getBool(_kEqualizerEnabled) ?? false;
  Future<void> setEqualizerEnabled(bool value) => _prefs.setBool(_kEqualizerEnabled, value);

  /// Ganhos (dB) por banda, na ordem das bandas do device. Lista vazia =
  /// nunca ajustado.
  List<double> get equalizerGains {
    final raw = _prefs.getString(_kEqualizerGains);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return [for (final e in list) (e as num).toDouble()];
    } catch (_) {
      return const [];
    }
  }

  Future<void> setEqualizerGains(List<double> gains) =>
      _prefs.setString(_kEqualizerGains, jsonEncode(gains));

  /// Refresh automático dos feeds em background (Fase 10). Ligado por
  /// padrão — é o que mantém "Novos episódios" fresco sem abrir o app.
  bool get backgroundRefreshEnabled => _prefs.getBool(_kBackgroundRefresh) ?? true;
  Future<void> setBackgroundRefreshEnabled(bool value) =>
      _prefs.setBool(_kBackgroundRefresh, value);

  /// Notificação quando sai episódio novo. Desligado por padrão — exige a
  /// permissão `POST_NOTIFICATIONS` (Android 13+), pedida ao ligar.
  bool get newEpisodeNotifications => _prefs.getBool(_kNewEpisodeNotifications) ?? false;
  Future<void> setNewEpisodeNotifications(bool value) =>
      _prefs.setBool(_kNewEpisodeNotifications, value);

  /// Só rebuscar feeds em background numa rede não tarifada (wifi).
  bool get refreshWifiOnly => _prefs.getBool(_kRefreshWifiOnly) ?? false;
  Future<void> setRefreshWifiOnly(bool value) =>
      _prefs.setBool(_kRefreshWifiOnly, value);
}

/// Sobrescrito em `main.dart` com a instância real (mesmo padrão de
/// `audioHandlerProvider`). Em teste, sobrescrever com um store sobre
/// `SharedPreferences` mockado (`SharedPreferences.setMockInitialValues`).
@Riverpod(keepAlive: true)
PreferencesStore preferencesStore(Ref ref) {
  throw UnimplementedError('preferencesStoreProvider precisa de overrideWithValue em main.dart');
}
