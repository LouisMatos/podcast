import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PreferencesStore> store([Map<String, Object> initial = const {}]) async {
  SharedPreferences.setMockInitialValues(initial);
  return PreferencesStore(await SharedPreferences.getInstance());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('defaults quando o store está vazio', () async {
    final s = await store();
    expect(s.themeModeName, isNull);
    expect(s.volume, 1.0);
    expect(s.playbackSpeed, 1.0);
    expect(s.equalizerEnabled, isFalse);
    expect(s.equalizerGains, isEmpty);
  });

  test('round-trip de cada campo', () async {
    final s = await store();
    await s.setThemeModeName('dark');
    await s.setVolume(0.3);
    await s.setPlaybackSpeed(1.75);
    await s.setEqualizerEnabled(true);
    await s.setEqualizerGains([-2.0, 0.0, 3.5]);

    expect(s.themeModeName, 'dark');
    expect(s.volume, 0.3);
    expect(s.playbackSpeed, 1.75);
    expect(s.equalizerEnabled, isTrue);
    expect(s.equalizerGains, [-2.0, 0.0, 3.5]);
  });

  test('lê valores já presentes de uma sessão anterior', () async {
    final s = await store({
      'pref.theme_mode': 'light',
      'pref.volume': 0.5,
      'pref.equalizer_gains': '[1.0,2.0]',
    });
    expect(s.themeModeName, 'light');
    expect(s.volume, 0.5);
    expect(s.equalizerGains, [1.0, 2.0]);
  });

  test('equalizerGains inválido não derruba', () async {
    final s = await store({'pref.equalizer_gains': 'lixo'});
    expect(s.equalizerGains, isEmpty);
  });
}
