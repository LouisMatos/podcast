import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/theme/app_theme.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/queue_repository.dart';
import 'package:podcast_app/features/player/widgets/episode_swipe_actions.dart';

class _MockLibrary extends Mock implements LibraryRepository {}

class _MockQueue extends Mock implements QueueRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Podcast(id: 0, title: '', author: '', feedUrl: ''));
    registerFallbackValue(const Episode(guid: '', title: '', audioUrl: ''));
  });

  const podcast = Podcast(id: 1, title: 'P', author: 'A', feedUrl: 'https://x/f.xml');
  const episode = Episode(guid: 'g1', title: 'Episódio', audioUrl: 'https://x/e.mp3');

  late _MockLibrary lib;
  late _MockQueue queue;

  Widget wrap({bool enabled = true}) {
    lib = _MockLibrary();
    queue = _MockQueue();
    when(() => lib.setEpisodeCompleted(any(), any(), any())).thenAnswer((_) async {});
    when(() => queue.addToEnd(any(), any())).thenAnswer((_) async {});
    when(() => queue.removeEpisode(any(), any())).thenAnswer((_) async {});

    return ProviderScope(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(lib),
        queueRepositoryProvider.overrideWithValue(queue),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: ListView(
            children: [
              EpisodeSwipeActions(
                podcast: podcast,
                episode: episode,
                enabled: enabled,
                child: const SizedBox(height: 72, child: Text('tile')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('arrastar pra direita adiciona à fila, tile permanece', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.drag(find.text('tile'), const Offset(600, 0));
    await tester.pumpAndSettle();

    verify(() => queue.addToEnd(podcast, episode)).called(1);
    expect(find.text('tile'), findsOneWidget);
    expect(find.text('Adicionado à fila'), findsOneWidget);
  });

  testWidgets('arrastar pra esquerda marca como ouvido', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.drag(find.text('tile'), const Offset(-600, 0));
    await tester.pumpAndSettle();

    verify(() => lib.setEpisodeCompleted(1, 'g1', true)).called(1);
    expect(find.text('tile'), findsOneWidget);
  });

  testWidgets('desfazer a fila remove o episódio', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.drag(find.text('tile'), const Offset(600, 0));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Desfazer'));
    await tester.pump();
    verify(() => queue.removeEpisode(1, 'g1')).called(1);
  });

  testWidgets('enabled: false não envolve em Dismissible', (tester) async {
    await tester.pumpWidget(wrap(enabled: false));
    expect(find.byType(Dismissible), findsNothing);

    await tester.drag(find.text('tile'), const Offset(-600, 0));
    await tester.pumpAndSettle();
    verifyNever(() => lib.setEpisodeCompleted(any(), any(), any()));
  });
}
