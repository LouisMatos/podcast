import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// `PreferencesStore` sobre um `SharedPreferences` em memória, pra testes.
/// Passe `initialValues` já com as chaves namespaced (`pref.volume`, etc.)
/// pra simular um app que já rodou antes.
Future<PreferencesStore> fakePreferencesStore([
  Map<String, Object> initialValues = const {},
]) async {
  SharedPreferences.setMockInitialValues(initialValues);
  return PreferencesStore(await SharedPreferences.getInstance());
}
