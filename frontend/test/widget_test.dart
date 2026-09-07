import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:podcast_app/app.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

import 'support/fake_preferences.dart';

void main() {
  testWidgets('app abre na tela Descobrir com a casca de navegação', (tester) async {
    final prefs = await fakePreferencesStore();

    await tester.pumpWidget(
      ProviderScope(
        // Em produção isso vem de `AudioService.init` / `SharedPreferences`
        // em main.dart. Nos testes não existe app real, só precisamos de
        // instâncias pra MiniPlayer/PlayerViewModel terem o que observar.
        overrides: [
          audioHandlerProvider.overrideWithValue(PodcastAudioHandler()),
          preferencesStoreProvider.overrideWithValue(prefs),
        ],
        child: const PodcastApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Descobrir'), findsWidgets);
    expect(find.text('Biblioteca'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
  });
}
