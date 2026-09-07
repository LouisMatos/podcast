import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/core/theme/app_theme.dart';
import 'package:podcast_app/data/models/chapter.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/download_repository.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/queue_repository.dart';
import 'package:podcast_app/features/player/view/mini_player.dart';
import 'package:podcast_app/features/player/view/player_screen.dart';
import 'package:podcast_app/features/player/view_model/player_view_model.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';
import 'package:podcast_app/services/chapters/chapter_service.dart';

import '../../support/fake_preferences.dart';

class _FakeHandler extends PodcastAudioHandler {
  @override
  Future<void> setQueue(
    List<MediaItem> items, {
    bool playFirst = false,
    Duration? initialPosition,
    bool autoPlay = true,
  }) async {}
}

class _MockLibrary extends Mock implements LibraryRepository {}

class _MockDownloads extends Mock implements DownloadRepository {}

class _MockQueue extends Mock implements QueueRepository {}

class _MockChapters extends Mock implements ChapterService {}

/// `PodcastAudioHandler()` aqui não toca nada de verdade: seu construtor só
/// cria um `just_audio.AudioPlayer` e assina os próprios streams — nenhum
/// método que bata em platform channel (`setAudioSource`/`play`) é chamado
/// enquanto a tela só observa o estado ocioso.
void main() {
  late PreferencesStore prefs;

  setUpAll(() {
    registerFallbackValue(const Podcast(id: 0, title: '', author: '', feedUrl: ''));
    registerFallbackValue(const Episode(guid: '', title: '', audioUrl: ''));
  });

  setUp(() async {
    prefs = await fakePreferencesStore();
  });

  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(PodcastAudioHandler()),
        preferencesStoreProvider.overrideWithValue(prefs),
        queueProvider.overrideWith((ref) => Stream.value(const <QueueEntry>[])),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: child),
    );
  }

  testWidgets('PlayerScreen mostra placeholder quando nada está tocando', (tester) async {
    await tester.pumpWidget(wrap(const PlayerScreen()));
    await tester.pump();

    expect(find.text('Nada tocando'), findsOneWidget);
  });

  testWidgets('MiniPlayer não mostra nenhum controle quando está ocioso', (tester) async {
    await tester.pumpWidget(wrap(const Scaffold(bottomNavigationBar: MiniPlayer())));
    await tester.pump();

    expect(find.byIcon(Icons.play_circle_fill), findsNothing);
    expect(find.byIcon(Icons.pause_circle_filled), findsNothing);
  });

  // Fase 14: a tela ganhou faixa de capítulos + aviso do temporizador; num
  // aparelho pequeno isso estourava o `Column`. Corpo agora rola.
  testWidgets('PlayerScreen não estoura com capítulos + timer + fila numa tela baixa',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 1700);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const podcast = Podcast(id: 1, title: 'P', author: 'A', feedUrl: 'https://x/f.xml');
    const ep = Episode(guid: 'g1', title: 'Um episódio de título razoavelmente longo', audioUrl: 'https://x/e.mp3');

    final handler = _FakeHandler();
    final lib = _MockLibrary();
    final dl = _MockDownloads();
    final q = _MockQueue();
    final cs = _MockChapters();
    when(() => lib.playbackPositionFor(any(), any())).thenAnswer((_) async => null);
    when(() => lib.watchSubscriptionSettings(any()))
        .thenAnswer((_) => Stream.value(defaultSubscriptionSettings));
    when(() => dl.completedPathsForPodcast(any())).thenAnswer((_) async => {});
    when(() => q.playNow(any(), any())).thenAnswer((_) async {});
    when(() => cs.ensureChapters(
          podcastId: any(named: 'podcastId'),
          episodeGuid: any(named: 'episodeGuid'),
          chaptersUrl: any(named: 'chaptersUrl'),
        )).thenAnswer((_) async {});
    when(() => cs.watchChapters(any(), any())).thenAnswer(
      (_) => Stream.value(const [
        Chapter(start: Duration.zero, title: 'Abertura'),
        Chapter(start: Duration(minutes: 3), title: 'Assunto principal'),
      ]),
    );

    final container = ProviderContainer(overrides: [
      audioHandlerProvider.overrideWithValue(handler),
      preferencesStoreProvider.overrideWithValue(prefs),
      libraryRepositoryProvider.overrideWithValue(lib),
      downloadRepositoryProvider.overrideWithValue(dl),
      queueRepositoryProvider.overrideWithValue(q),
      chapterServiceProvider.overrideWithValue(cs),
      queueProvider.overrideWith((ref) => Stream.value(const <QueueEntry>[])),
    ]);

    final vm = container.read(playerViewModelProvider.notifier);
    await vm.playEpisode(podcast, ep);
    vm.startSleepTimerAtEndOfEpisode();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.light(), home: const PlayerScreen()),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('agite para +5 min'), findsOneWidget);

    // Desmonta a árvore e o container antes do fim do teste — o `_ticker`
    // periódico do PlayerViewModel dispararia o invariante de timer pendente.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });
}
