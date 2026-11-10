import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/features/player/view_model/player_state.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/download_repository.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/queue_repository.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/data/models/chapter.dart';
import 'package:podcast_app/features/player/view_model/player_view_model.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';
import 'package:podcast_app/services/chapters/chapter_service.dart';

import '../../support/fake_preferences.dart';

/// Handler real (os BehaviorSubjects de `BaseAudioHandler` já funcionam),
/// mas `setQueue` é interceptado — assim nada bate em platform channel e
/// dá pra inspecionar o `autoPlay`.
class _FakeHandler extends PodcastAudioHandler {
  int calls = 0;
  bool? lastAutoPlay;
  List<MediaItem>? lastItems;
  bool shouldThrowOnSetQueue = false;

  @override
  Future<void> setQueue(
    List<MediaItem> items, {
    bool playFirst = false,
    Duration? initialPosition,
    bool autoPlay = true,
  }) async {
    if (shouldThrowOnSetQueue) throw Exception('URL inalcançável');
    lastItems = items;
    if (playFirst) {
      calls++;
      lastAutoPlay = autoPlay;
    }
  }
}

class _MockLibrary extends Mock implements LibraryRepository {}

class _MockDownloads extends Mock implements DownloadRepository {}

class _MockQueue extends Mock implements QueueRepository {}

class _MockChapters extends Mock implements ChapterService {}

_MockChapters _stubChapters() {
  final chapters = _MockChapters();
  when(() => chapters.ensureChapters(
        podcastId: any(named: 'podcastId'),
        episodeGuid: any(named: 'episodeGuid'),
        chaptersUrl: any(named: 'chaptersUrl'),
      )).thenAnswer((_) async {});
  when(() => chapters.watchChapters(any(), any()))
      .thenAnswer((_) => Stream.value(const <Chapter>[]));
  return chapters;
}

void main() {
  // `just_audio.AudioPlayer` (criado no construtor do handler) registra um
  // method channel handler — precisa do binding de teste inicializado.
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(<QueueEntry>[]);
    registerFallbackValue(const Podcast(id: 0, title: '', author: '', feedUrl: ''));
    registerFallbackValue(const Episode(guid: '', title: '', audioUrl: ''));
    registerFallbackValue(Duration.zero);
  });

  late _FakeHandler handler;
  late ProviderContainer container;

  const podcast = Podcast(id: 1, title: 'P', author: 'A', feedUrl: 'https://x/f.xml');
  const episode = Episode(guid: 'g1', title: 'E1', audioUrl: 'https://x/e1.mp3');

  Future<ProviderContainer> makeContainer([Map<String, Object> prefs = const {}]) async {
    handler = _FakeHandler();
    final lib = _MockLibrary();
    final dl = _MockDownloads();
    final q = _MockQueue();
    final chapters = _stubChapters();
    when(() => lib.playbackPositionFor(any(), any())).thenAnswer((_) async => null);
    when(() => lib.watchSubscriptionSettings(any()))
        .thenAnswer((_) => Stream.value(defaultSubscriptionSettings));
    when(() => lib.savePlaybackPosition(
          podcastId: any(named: 'podcastId'),
          episodeGuid: any(named: 'episodeGuid'),
          position: any(named: 'position'),
          completed: any(named: 'completed'),
        )).thenAnswer((_) async {});
    when(() => lib.recordListening(
          podcastId: any(named: 'podcastId'),
          episodeGuid: any(named: 'episodeGuid'),
          delta: any(named: 'delta'),
        )).thenAnswer((_) async {});
    when(() => lib.updateEpisodeDuration(any(), any(), any())).thenAnswer((_) async {});
    when(() => dl.completedPathsForPodcast(any())).thenAnswer((_) async => {});
    when(() => q.replaceWith(any())).thenAnswer((_) async {});
    when(() => q.playNow(any(), any())).thenAnswer((_) async {});
    when(() => q.addToEnd(any(), any())).thenAnswer((_) async {});
    when(() => q.playNextAfter(any(), any(), any())).thenAnswer((_) async {});
    when(() => q.removeEpisode(any(), any())).thenAnswer((_) async {});

    final c = ProviderContainer(
      overrides: [
        audioHandlerProvider.overrideWithValue(handler),
        libraryRepositoryProvider.overrideWithValue(lib),
        downloadRepositoryProvider.overrideWithValue(dl),
        queueRepositoryProvider.overrideWithValue(q),
        chapterServiceProvider.overrideWithValue(chapters),
        queueProvider.overrideWith((ref) => Stream.value(const <QueueEntry>[])),
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
        .playEpisode(podcast, episode);

    expect(handler.calls, 1);
    expect(handler.lastAutoPlay, false);
  });

  test('playEpisode com autoPlay: true repassa pro handler', () async {
    await container
        .read(playerViewModelProvider.notifier)
        .playEpisode(podcast, episode, autoPlay: true);

    expect(handler.lastAutoPlay, true);
  });

  test('estado ganha o episódio de forma síncrona, antes do await', () {
    container
        .read(playerViewModelProvider.notifier)
        .playEpisode(podcast, episode);

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
    final q = _MockQueue();
    when(() => lib.playbackPositionFor(any(), any())).thenAnswer((_) async => null);
    when(() => lib.watchSubscriptionSettings(any()))
        .thenAnswer((_) => Stream.value(defaultSubscriptionSettings));
    when(() => dl.completedPathsForPodcast(any())).thenAnswer((_) async => {});
    final c = ProviderContainer(overrides: [
      audioHandlerProvider.overrideWithValue(handler),
      libraryRepositoryProvider.overrideWithValue(lib),
      downloadRepositoryProvider.overrideWithValue(dl),
      queueRepositoryProvider.overrideWithValue(q),
      chapterServiceProvider.overrideWithValue(_stubChapters()),
      queueProvider.overrideWith((ref) => Stream.value(const <QueueEntry>[])),
      preferencesStoreProvider.overrideWithValue(prefs),
    ]);
    addTearDown(c.dispose);

    await c.read(playerViewModelProvider.notifier).setVolume(0.25);
    c.read(playerViewModelProvider.notifier).setSpeed(2.0);
    await Future<void>.delayed(Duration.zero);

    expect(prefs.volume, 0.25);
    expect(prefs.playbackSpeed, 2.0);
  });

  group('fechar mini-player (dismiss)', () {
    test('para o handler, limpa a fila e zera o episódio', () async {
      final q = container.read(queueRepositoryProvider) as _MockQueue;
      when(() => q.clear()).thenAnswer((_) async {});

      await container
          .read(playerViewModelProvider.notifier)
          .playEpisode(podcast, episode);
      expect(container.read(playerViewModelProvider).isIdle, false);

      await container.read(playerViewModelProvider.notifier).dismiss();

      final state = container.read(playerViewModelProvider);
      expect(state.isIdle, true);
      expect(state.podcast, null);
      expect(state.queue, isEmpty);
      expect(state.isPlaying, false);
      verify(() => q.clear()).called(1);
    });
  });

  group('efeitos de áudio (Fase 14)', () {
    test('build restaura pular silêncio / reforço de volume salvos', () async {
      final c = await makeContainer({
        'pref.skip_silence_enabled': true,
        'pref.volume_boost_enabled': true,
        'pref.volume_boost_gain_db': 6.0,
      });
      final state = c.read(playerViewModelProvider);
      expect(state.skipSilenceEnabled, isTrue);
      expect(state.volumeBoostEnabled, isTrue);
      expect(state.volumeBoostGainDb, 6.0);
    });

    test('setSkipSilence persiste e atualiza o estado', () async {
      final notifier = container.read(playerViewModelProvider.notifier);
      await notifier.setSkipSilence(true);
      expect(container.read(playerViewModelProvider).skipSilenceEnabled, isTrue);
      expect(container.read(preferencesStoreProvider).skipSilenceEnabled, isTrue);
    });

    test('setVolumeBoostGain persiste', () async {
      final notifier = container.read(playerViewModelProvider.notifier);
      await notifier.setVolumeBoostGain(9.0);
      expect(container.read(playerViewModelProvider).volumeBoostGainDb, 9.0);
      expect(container.read(preferencesStoreProvider).volumeBoostGainDb, 9.0);
    });
  });

  group('capítulos (Fase 14)', () {
    test('playEpisode carrega os capítulos do episódio', () async {
      final c = await makeContainer();
      final cs = c.read(chapterServiceProvider) as _MockChapters;
      when(() => cs.watchChapters(any(), any())).thenAnswer(
        (_) => Stream.value(const [
          Chapter(start: Duration.zero, title: 'Intro'),
          Chapter(start: Duration(minutes: 5), title: 'Miolo'),
        ]),
      );

      await c.read(playerViewModelProvider.notifier).playEpisode(podcast, episode);
      await Future<void>.delayed(Duration.zero);

      expect(c.read(playerViewModelProvider).chapters, hasLength(2));
      verify(() => cs.ensureChapters(
            podcastId: 1,
            episodeGuid: 'g1',
            chaptersUrl: any(named: 'chaptersUrl'),
          )).called(1);
    });
  });

  group('temporizador para dormir (Fase 14)', () {
    test('startSleepTimer arma o modo duração; cancel volta pra off', () {
      final notifier = container.read(playerViewModelProvider.notifier);
      notifier.startSleepTimer(const Duration(minutes: 15));
      expect(container.read(playerViewModelProvider).sleepTimerMode, SleepTimerMode.duration);

      notifier.cancelSleepTimer();
      expect(container.read(playerViewModelProvider).sleepTimerMode, SleepTimerMode.off);
      expect(container.read(playerViewModelProvider).sleepTimerRemaining, isNull);
    });

    test('modo "fim do episódio": pausa quando o episódio armado é consumido', () async {
      final notifier = container.read(playerViewModelProvider.notifier);
      await notifier.playEpisode(podcast, episode);
      notifier.startSleepTimerAtEndOfEpisode();
      expect(container.read(playerViewModelProvider).sleepTimerMode, SleepTimerMode.endOfEpisode);

      // Handler avisa que o item em foco saiu da fila (episódio terminou).
      handler.onItemConsumed?.call(const MediaItem(
        id: 'x',
        title: 'E1',
        extras: {'guid': 'g1', 'podcastId': 1},
      ));
      await Future<void>.delayed(Duration.zero);

      expect(container.read(playerViewModelProvider).sleepTimerMode, SleepTimerMode.off);
    });

    test('agitar estende o timer em 5 min', () async {
      final shakes = StreamController<AccelerometerEvent>.broadcast();
      addTearDown(shakes.close);
      final notifier = container.read(playerViewModelProvider.notifier)
        ..debugAccelerometerStream = () => shakes.stream;

      notifier.startSleepTimer(const Duration(minutes: 10));
      final before = container.read(playerViewModelProvider).sleepTimerRemaining!;

      shakes.add(AccelerometerEvent(0, 30, 30, DateTime.now()));
      await Future<void>.delayed(Duration.zero);

      final after = container.read(playerViewModelProvider).sleepTimerRemaining!;
      expect(after, greaterThan(before + const Duration(minutes: 4)));
    });
  });

  group('histórico de escuta (Fase 17)', () {
    test('listeningDelta: dentro da faixa devolve o avanço', () {
      expect(
        listeningDelta(const Duration(seconds: 10), const Duration(seconds: 40)),
        const Duration(seconds: 30),
      );
      expect(
        listeningDelta(Duration.zero, const Duration(minutes: 2)),
        const Duration(minutes: 2),
      );
    });

    test('listeningDelta: retrocesso / sem avanço vira zero', () {
      expect(
        listeningDelta(const Duration(minutes: 5), const Duration(minutes: 4)),
        Duration.zero,
      );
      expect(
        listeningDelta(const Duration(seconds: 5), const Duration(seconds: 5)),
        Duration.zero,
      );
    });

    test('listeningDelta: salto maior que 2 min vira zero', () {
      expect(
        listeningDelta(Duration.zero, const Duration(minutes: 3)),
        Duration.zero,
      );
    });

    test('grava no repositório só o avanço real ouvido', () async {
      final lib = container.read(libraryRepositoryProvider) as _MockLibrary;
      final notifier = container.read(playerViewModelProvider.notifier);
      await notifier.playEpisode(podcast, episode);
      await Future<void>.delayed(Duration.zero);

      PlaybackState stateAt(Duration pos, {required bool playing}) => PlaybackState(
            playing: playing,
            processingState: AudioProcessingState.ready,
            updatePosition: pos,
          );

      // Estabelece a base do histórico em 10s (1º save deste episódio).
      handler.playbackState.add(stateAt(const Duration(seconds: 10), playing: true));
      await Future<void>.delayed(Duration.zero);
      handler.playbackState.add(stateAt(const Duration(seconds: 10), playing: false));
      await Future<void>.delayed(Duration.zero);

      // Avança 30s tocando e pausa → grava delta de 30s.
      handler.playbackState.add(stateAt(const Duration(seconds: 40), playing: true));
      await Future<void>.delayed(Duration.zero);
      handler.playbackState.add(stateAt(const Duration(seconds: 40), playing: false));
      await Future<void>.delayed(Duration.zero);

      verify(() => lib.recordListening(
            podcastId: 1,
            episodeGuid: 'g1',
            delta: const Duration(seconds: 30),
          )).called(1);
    });
  });

  group('rádio ao vivo (guard isRadio)', () {
    MediaItem radioItem() => const MediaItem(
          id: 'https://stream.example.com/live',
          title: 'Rádio Teste',
          extras: {'isRadio': true},
        );

    test('MediaItem isRadio não sobrescreve episode/podcast/duration do state', () async {
      await container.read(playerViewModelProvider.notifier).playEpisode(podcast, episode);
      await Future<void>.delayed(Duration.zero);
      final before = container.read(playerViewModelProvider);

      handler.mediaItem.add(radioItem());
      await Future<void>.delayed(Duration.zero);

      final after = container.read(playerViewModelProvider);
      expect(after.episode, before.episode);
      expect(after.podcast, before.podcast);
      expect(after.duration, before.duration);
    });

    test('PlaybackState durante rádio não mexe em position nem chama _saveProgress', () async {
      final lib = container.read(libraryRepositoryProvider) as _MockLibrary;
      await container.read(playerViewModelProvider.notifier).playEpisode(podcast, episode);
      await Future<void>.delayed(Duration.zero);

      handler.mediaItem.add(radioItem());
      await Future<void>.delayed(Duration.zero);

      // Tocando e depois "pausando" a rádio com posição bem distante da do
      // episódio — se o guard falhar, isso vira save de progresso corrompido.
      handler.playbackState.add(PlaybackState(
        playing: true,
        processingState: AudioProcessingState.ready,
        updatePosition: const Duration(minutes: 42),
      ));
      await Future<void>.delayed(Duration.zero);
      handler.playbackState.add(PlaybackState(
        playing: false,
        processingState: AudioProcessingState.ready,
        updatePosition: const Duration(minutes: 42),
      ));
      await Future<void>.delayed(Duration.zero);

      final state = container.read(playerViewModelProvider);
      expect(state.position, isNot(const Duration(minutes: 42)));
      verifyNever(() => lib.savePlaybackPosition(
            podcastId: any(named: 'podcastId'),
            episodeGuid: any(named: 'episodeGuid'),
            position: const Duration(minutes: 42),
            completed: any(named: 'completed'),
          ));
    });
  });

  group('_toMediaItem (Fase 25 v3)', () {
    test('usa imagem do episódio, cai pra do podcast se faltar', () async {
      const withArt = Episode(
        guid: 'g1',
        title: 'E1',
        audioUrl: 'https://x/e1.mp3',
        imageUrl: 'https://x/ep.png',
        duration: Duration(minutes: 10),
      );
      const podcastArt = Podcast(
        id: 1,
        title: 'P',
        author: 'A',
        feedUrl: 'https://x/f.xml',
        artworkUrl: 'https://x/pod.png',
      );

      await container.read(playerViewModelProvider.notifier).playEpisode(podcastArt, withArt);

      final item = handler.lastItems!.single;
      expect(item.artUri, Uri.parse('https://x/ep.png'));
      expect(item.duration, const Duration(minutes: 10));

      const noArt = Episode(guid: 'g2', title: 'E2', audioUrl: 'https://x/e2.mp3');
      await container.read(playerViewModelProvider.notifier).playEpisode(podcastArt, noArt);
      final fallback = handler.lastItems!.single;
      expect(fallback.artUri, Uri.parse('https://x/pod.png'));
      expect(fallback.duration, isNull);
    });
  });

  group('reconciliação de duração real (Fase 21 v3)', () {
    test('corrige o cache quando diverge > 2s do itunes:duration, só uma vez por guid', () async {
      final lib = container.read(libraryRepositoryProvider) as _MockLibrary;
      const ep = Episode(
        guid: 'g1',
        title: 'E1',
        audioUrl: 'https://x/e1.mp3',
        duration: Duration(minutes: 6),
      );
      await container.read(playerViewModelProvider.notifier).playEpisode(podcast, ep);
      await Future<void>.delayed(Duration.zero);

      handler.mediaItem.add(MediaItem(
        id: 'https://x/e1.mp3',
        title: 'E1',
        duration: const Duration(minutes: 7, seconds: 11),
        extras: const {'guid': 'g1', 'podcastId': 1},
      ));
      await Future<void>.delayed(Duration.zero);

      verify(() => lib.updateEpisodeDuration(1, 'g1', const Duration(minutes: 7, seconds: 11))).called(1);

      handler.mediaItem.add(MediaItem(
        id: 'https://x/e1.mp3',
        title: 'E1',
        duration: const Duration(minutes: 7, seconds: 12),
        extras: const {'guid': 'g1', 'podcastId': 1},
      ));
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => lib.updateEpisodeDuration(1, 'g1', const Duration(minutes: 7, seconds: 12)));
    });

    test('não corrige quando a divergência é <= 2s', () async {
      final lib = container.read(libraryRepositoryProvider) as _MockLibrary;
      const ep = Episode(
        guid: 'g1',
        title: 'E1',
        audioUrl: 'https://x/e1.mp3',
        duration: Duration(minutes: 7, seconds: 10),
      );
      await container.read(playerViewModelProvider.notifier).playEpisode(podcast, ep);
      await Future<void>.delayed(Duration.zero);

      handler.mediaItem.add(MediaItem(
        id: 'https://x/e1.mp3',
        title: 'E1',
        duration: const Duration(minutes: 7, seconds: 11),
        extras: const {'guid': 'g1', 'podcastId': 1},
      ));
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => lib.updateEpisodeDuration(any(), any(), any()));
    });
  });

  group('recuperação de falha ao tocar (robustez pós-27)', () {
    test('setQueue lançando não deixa o spinner preso — volta pro estado ocioso', () async {
      handler.shouldThrowOnSetQueue = true;

      await container.read(playerViewModelProvider.notifier).playEpisode(podcast, episode);

      final state = container.read(playerViewModelProvider);
      expect(state.isBuffering, isFalse);
      expect(state.isPlaying, isFalse);
      expect(state.episode, isNull);
      expect(state.podcast, isNull);
      expect(state.isIdle, isTrue);
    });
  });
}
