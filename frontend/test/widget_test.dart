import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:podcast_app/app.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/queue_repository.dart';
import 'package:podcast_app/features/home/view_model/home_providers.dart';
import 'package:podcast_app/features/library/view_model/startup_feed_refresh_provider.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

import 'support/fake_preferences.dart';

void main() {
  testWidgets('app abre na aba Início com a casca de navegação', (tester) async {
    final prefs = await fakePreferencesStore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioHandlerProvider.overrideWithValue(PodcastAudioHandler()),
          preferencesStoreProvider.overrideWithValue(prefs),
          // Início consulta o banco — nos testes damos streams vazios e
          // pulamos o refresh de startup pra não tocar em drift/rede.
          continueListeningProvider.overrideWith(
            (ref) => Stream.value(const <ContinueListeningItem>[]),
          ),
          recentEpisodesProvider.overrideWith(
            (ref) => Stream.value(const <RecentEpisodeItem>[]),
          ),
          startupFeedRefreshProvider.overrideWith((ref) async => 0),
          queueProvider.overrideWith((ref) => Stream.value(const <QueueEntry>[])),
        ],
        child: const PodcastApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Início'), findsWidgets);
    expect(find.text('Descobrir'), findsOneWidget);
    expect(find.text('Biblioteca'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
  });
}
