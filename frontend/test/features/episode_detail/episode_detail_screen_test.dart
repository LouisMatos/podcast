import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/theme/app_theme.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/queue_repository.dart';
import 'package:podcast_app/features/episode_detail/view/episode_detail_screen.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

import '../../support/fake_preferences.dart';

class _MockLibrary extends Mock implements LibraryRepository {}

void main() {
  const podcast = Podcast(id: 1, title: 'Meu Podcast', author: 'A', feedUrl: 'https://x/f.xml');
  const episode = Episode(
    guid: 'g1',
    title: 'Episódio Um',
    audioUrl: 'https://x/e1.mp3',
    description: '<p>Descrição <b>com</b> HTML.</p>',
  );

  testWidgets('mostra título, descrição e botões sem tocar nada', (tester) async {
    final lib = _MockLibrary();
    when(() => lib.watchIsSubscribed(any())).thenAnswer((_) => Stream.value(false));
    final prefs = await fakePreferencesStore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioHandlerProvider.overrideWithValue(PodcastAudioHandler()),
          libraryRepositoryProvider.overrideWithValue(lib),
          preferencesStoreProvider.overrideWithValue(prefs),
          queueProvider.overrideWith((ref) => Stream.value(const <QueueEntry>[])),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const EpisodeDetailScreen(podcast: podcast, episode: episode, queue: [episode]),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Episódio Um'), findsOneWidget);
    expect(find.text('Tocar'), findsOneWidget);
    expect(find.text('Abrir player'), findsOneWidget);
    expect(find.byType(HtmlWidget), findsOneWidget);
  });
}
