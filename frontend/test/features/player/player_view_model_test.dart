import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/download_repository.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/features/player/view_model/player_view_model.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

import '../../support/fake_preferences.dart';

/// Handler real (os BehaviorSubjects de `BaseAudioHandler` já funcionam),
/// mas `playQueue` é interceptado — assim nada bate em platform channel e
/// dá pra inspecionar o `autoPlay`.
class _FakeHandler extends PodcastAudioHandler {
  int calls = 0;
  bool? lastAutoPlay;

  @override
  Future<void> playQueue(
    List<MediaItem> items, {
    required int startIndex,
    Duration? initialPosition,
    bool autoPlay = true,
  }) async {
    calls++;
    lastAutoPlay = autoPlay;
  }
}

class _MockLibrary extends Mock implements LibraryRepository {}

class _MockDownloads extends Mock implements DownloadRepository {}

void main() {
  // `just_audio.AudioPlayer` (criado no construtor do handler) registra um
  // method channel handler — precisa do binding de teste inicializado.
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeHandler handler;
  late ProviderContainer container;

  const podcast = Podcast(id: 1, title: 'P', author: 'A', feedUrl: 'https://x/f.xml');
  const episode = Episode(guid: 'g1', title: 'E1', audioUrl: 'https://x/e1.mp3');

  Future<ProviderContainer> makeContainer([Map<String, Object> prefs = const {}]) async {
    handler = _FakeHandler();
    final lib = _MockLibrary();
    final dl = _MockDownloads();
    when(() => lib.playbackPositionFor(any(), any())).thenAnswer((_) async => null);
    when(() => dl.completedPathsForPodcast(any())).thenAnswer((_) async => {});

    final c = ProviderContainer(
      overrides: [
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(lib),
        downloadRepositoryProvider.overrideWithValue(dl),
        preferencesStoreProvider.overrideWithValue(await fakePreferencesStore(prefs)),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() async {
    container = await makeContainer();
  });

  test('playEpisode não toca sozinho (autoPlay padrão = false)', () async {
    await container
        .read(playerViewModelProvider.notifier)
        .playEpisode(podcast, episode, queue: const [episode]);

    expect(handler.calls, 1);
    expect(handler.lastAutoPlay, false);
  });

  test('playEpisode com autoPlay: true repassa pro handler', () async {
    await container
        .read(playerViewModelProvider.notifier)
        .playEpisode(podcast, episode, queue: const [episode], autoPlay: true);

    expect(handler.lastAutoPlay, true);
  });

  test('estado ganha o episódio de forma síncrona, antes do await', () {
    container
        .read(playerViewModelProvider.notifier)
        .playEpisode(podcast, episode, queue: const [episode]);

    expect(container.read(playerViewModelProvider).episode?.guid, 'g1');
  });

  test('build restaura volume e velocidade salvos', () async {
    final c = await makeContainer({'pref.volume': 0.4, 'pref.playback_speed': 1.5});

    final state = c.read(playerViewModelProvider);
    expect(state.volume, 0.4);
    expect(state.speed, 1.5);
  });

  test('setVolume e setSpeed persistem no store', () async {
    final prefs = await fakePreferencesStore();
    handler = _FakeHandler();
    final lib = _MockLibrary();
    final dl = _MockDownloads();
    when(() => lib.playbackPositionFor(any(), any())).thenAnswer((_) async => null);
    when(() => dl.completedPathsForPodcast(any())).thenAnswer((_) async => {});
    final c = ProviderContainer(overrides: [
      audioHandlerProvider.overrideWithValue(handler),
      libraryRepositoryProvider.overrideWithValue(lib),
      downloadRepositoryProvider.overrideWithValue(dl),
      preferencesStoreProvider.overrideWithValue(prefs),
    ]);
    addTearDown(c.dispose);

    await c.read(playerViewModelProvider.notifier).setVolume(0.25);
    c.read(playerViewModelProvider.notifier).setSpeed(2.0);
    await Future<void>.delayed(Duration.zero);

    expect(prefs.volume, 0.25);
    expect(prefs.playbackSpeed, 2.0);
  });
}
