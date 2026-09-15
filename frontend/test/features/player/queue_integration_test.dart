import 'package:audio_service/audio_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/data/models/chapter.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/download_repository.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/queue_repository.dart';
import 'package:podcast_app/features/player/view_model/player_view_model.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';
import 'package:podcast_app/services/chapters/chapter_service.dart';

import '../../support/fake_preferences.dart';

/// Espelha `setQueue` num `BehaviorSubject` (como o handler real faria depois
/// de carregar a `AudioSource`) e registra cada chamada — assim o teste vê
/// tanto o que o `PlayerViewModel` mandou quanto o estado resultante.
class _FakeHandler extends PodcastAudioHandler {
  final List<({List<String> ids, bool playFirst, bool autoPlay})> calls = [];
  bool shouldThrowOnSetQueue = false;

  @override
  Future<void> setQueue(
    List<MediaItem> items, {
    bool playFirst = false,
    Duration? initialPosition,
    bool autoPlay = true,
  }) async {
    if (shouldThrowOnSetQueue) throw Exception('URL inalcançável');
    calls.add((
      ids: [for (final i in items) i.id],
      playFirst: playFirst,
      autoPlay: autoPlay,
    ));
    this.queue.add(items);
    mediaItem.add(items.isEmpty ? null : items.first);
  }

  ({List<String> ids, bool playFirst, bool autoPlay}) get last => calls.last;
}

class _MockLibrary extends Mock implements LibraryRepository {}

class _MockDownloads extends Mock implements DownloadRepository {}

class _MockChapters extends Mock implements ChapterService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(Duration.zero);
    registerFallbackValue(const Podcast(id: 0, title: '', author: '', feedUrl: ''));
    registerFallbackValue(const Episode(guid: '', title: '', audioUrl: ''));
  });

  late AppDatabase db;
  late QueueRepository queueRepo;
  late _FakeHandler handler;
  late ProviderContainer container;

  const podcast = Podcast(id: 1, title: 'P', author: 'A', feedUrl: 'https://x/f.xml');
  Episode ep(String guid) => Episode(guid: guid, title: guid.toUpperCase(), audioUrl: 'u-$guid');

  // O `_syncQueue` reage ao stream do drift (`.watch()`), que emite fora do
  // microtask atual — dá um respiro real pra propagar.
  Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 30));

  List<String> handlerIds() => [for (final i in handler.queue.value) i.id];

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    queueRepo = QueueRepository(db);
    handler = _FakeHandler();
    final prefs = await fakePreferencesStore();

    final lib = _MockLibrary();
    final dl = _MockDownloads();
    final chapters = _MockChapters();
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
    when(() => dl.completedPathsForPodcast(any())).thenAnswer((_) async => <String, String>{});
    when(() => chapters.ensureChapters(
          podcastId: any(named: 'podcastId'),
          episodeGuid: any(named: 'episodeGuid'),
          chaptersUrl: any(named: 'chaptersUrl'),
        )).thenAnswer((_) async {});
    when(() => chapters.watchChapters(any(), any()))
        .thenAnswer((_) => Stream.value(const <Chapter>[]));

    container = ProviderContainer(overrides: [
      audioHandlerProvider.overrideWithValue(handler),
      appDatabaseProvider.overrideWithValue(db),
      queueRepositoryProvider.overrideWithValue(queueRepo),
      libraryRepositoryProvider.overrideWithValue(lib),
      downloadRepositoryProvider.overrideWithValue(dl),
      chapterServiceProvider.overrideWithValue(chapters),
      preferencesStoreProvider.overrideWithValue(prefs),
    ]);
    addTearDown(db.close);
    addTearDown(container.dispose);
    // Assinantes permanentes — sem isso o `PlayerViewModel` e o stream da
    // fila podem ser recolhidos entre um `await` e outro.
    container.listen(playerViewModelProvider, (_, _) {});
    container.listen(queueProvider, (_, _) {});
  });

  test('fluxo ponta-a-ponta: play, enfileira, consome, reordena, limpa', () async {
    final vm = container.read(playerViewModelProvider.notifier);

    // play(A) → fila = [A]; handler recebeu um setQueue(playFirst) com só A.
    await vm.playEpisode(podcast, ep('a'));
    await settle();

    expect([for (final e in await queueRepo.currentQueue()) e.episode.guid], ['a']);
    expect(handler.calls.any((c) => c.playFirst && c.ids.contains('u-a')), isTrue);
    expect(handlerIds(), ['u-a']);

    // enqueue(B), enqueue(C) → fila = [A,B,C]; handler espelhado.
    await vm.enqueue(podcast, ep('b'));
    await settle();
    await vm.enqueue(podcast, ep('c'));
    await settle();

    expect([for (final e in await queueRepo.currentQueue()) e.episode.guid], ['a', 'b', 'c']);
    expect(handlerIds(), ['u-a', 'u-b', 'u-c']);
    expect(container.read(playerViewModelProvider).queue.map((e) => e.guid), ['a', 'b', 'c']);

    // Fim do episódio A: o handler avisa que o item saiu de foco.
    handler.onItemConsumed!.call(const MediaItem(
      id: 'u-a',
      title: 'A',
      extras: {'guid': 'a', 'podcastId': 1},
    ));
    await settle();

    expect([for (final e in await queueRepo.currentQueue()) e.episode.guid], ['b', 'c']);
    // O item que tocava sumiu → handler recarrega o novo topo (B) tocando.
    expect(handler.last.playFirst, isTrue);
    expect(handler.last.ids, ['u-b', 'u-c']);
    expect(handlerIds(), ['u-b', 'u-c']);

    // reorderQueue → espelha no handler.
    await vm.reorderQueue(0, 1);
    await settle();
    expect([for (final e in await queueRepo.currentQueue()) e.episode.guid], ['c', 'b']);
    expect(handlerIds(), ['u-c', 'u-b']);

    // removeFromQueueAt → espelha no handler.
    await vm.removeFromQueueAt(1);
    await settle();
    expect([for (final e in await queueRepo.currentQueue()) e.episode.guid], ['c']);
    expect(handlerIds(), ['u-c']);

    // clearQueue → fila vazia, handler setQueue([]).
    await vm.clearQueue();
    await settle();
    expect(await queueRepo.currentQueue(), isEmpty);
    expect(handler.last.ids, isEmpty);
    expect(handler.queue.value, isEmpty);
  });

  test('_syncQueue: setQueue lançando não deixa isPlaying/isBuffering presos', () async {
    final vm = container.read(playerViewModelProvider.notifier);

    await vm.playEpisode(podcast, ep('a'));
    await settle();

    handler.shouldThrowOnSetQueue = true;
    await vm.enqueue(podcast, ep('b'));
    await settle();

    final state = container.read(playerViewModelProvider);
    expect(state.isPlaying, isFalse);
    expect(state.isBuffering, isFalse);
  });
}
