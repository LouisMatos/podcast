import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/data/models/radio_station.dart';
import 'package:podcast_app/data/repositories/radio_repository.dart';
import 'package:podcast_app/features/radio/view_model/radio_view_model.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

import '../../support/fake_preferences.dart';

class _MockRadioRepository extends Mock implements RadioRepository {}

/// Handler real (os BehaviorSubjects de `BaseAudioHandler` já funcionam),
/// `setQueue` interceptado — mesmo padrão de `player_view_model_test.dart`.
class _FakeHandler extends PodcastAudioHandler {
  List<MediaItem>? lastItems;
  bool? lastPlayFirst;

  @override
  Future<void> setQueue(
    List<MediaItem> items, {
    bool playFirst = false,
    Duration? initialPosition,
    bool autoPlay = true,
  }) async {
    lastItems = items;
    lastPlayFirst = playFirst;
    if (playFirst) mediaItem.add(items.first);
  }

  bool paused = false;
  bool played = false;

  @override
  Future<void> pause() async => paused = true;

  @override
  Future<void> play() async => played = true;
}

const _station = RadioStation(id: 'a1', name: 'Rádio Teste', streamUrl: 'https://x.com/live');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockRadioRepository repository;
  late _FakeHandler handler;
  late PreferencesStore prefs;
  late ProviderContainer container;

  setUp(() async {
    repository = _MockRadioRepository();
    handler = _FakeHandler();
    prefs = await fakePreferencesStore();
    container = ProviderContainer(overrides: [
      radioRepositoryProvider.overrideWithValue(repository),
      audioHandlerProvider.overrideWithValue(handler),
      preferencesStoreProvider.overrideWithValue(prefs),
    ]);
    addTearDown(container.dispose);
  });

  // autoDispose: sem listener permanente o notifier morre antes do fetch
  // assíncrono do build() completar. Stub do repositório sempre configurado
  // ANTES do listen — o listen já dispara build()/_load() (via microtask).
  void keepAlive() => container.listen(radioViewModelProvider, (_, _) {});

  test('carrega lista de rádios ao abrir', () async {
    when(() => repository.brStations()).thenAnswer((_) async => [_station]);
    keepAlive();

    expect(container.read(radioViewModelProvider).isLoading, isTrue);

    await Future<void>.delayed(Duration.zero);

    final state = container.read(radioViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.stations, [_station]);
    expect(state.error, isNull);
  });

  test('erro de conexão marca offline', () async {
    when(() => repository.brStations()).thenThrow(DioException(
      requestOptions: RequestOptions(path: ''),
      type: DioExceptionType.connectionError,
    ));
    keepAlive();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(radioViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.offline, isTrue);
    expect(state.error, isNotNull);
  });

  test('erro genérico não marca offline', () async {
    when(() => repository.brStations()).thenThrow(Exception('boom'));
    keepAlive();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(radioViewModelProvider);
    expect(state.offline, isFalse);
    expect(state.error, isNotNull);
  });

  test('retry refaz a busca', () async {
    when(() => repository.brStations()).thenAnswer((_) async => const []);
    keepAlive();
    final notifier = container.read(radioViewModelProvider.notifier);
    await Future<void>.delayed(Duration.zero);

    when(() => repository.brStations()).thenAnswer((_) async => [_station]);
    notifier.retry();
    await Future<void>.delayed(Duration.zero);

    expect(container.read(radioViewModelProvider).stations, [_station]);
  });

  group('playback ao vivo', () {
    test('play() chama setQueue com MediaItem extras isRadio+stationId', () async {
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      keepAlive();
      final notifier = container.read(radioViewModelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.play(_station);

      expect(handler.lastPlayFirst, isTrue);
      final item = handler.lastItems!.single;
      expect(item.id, _station.streamUrl);
      expect(item.extras?['isRadio'], isTrue);
      expect(item.extras?['stationId'], _station.id);
      expect(container.read(radioViewModelProvider).nowPlayingId, _station.id);
    });

    test('play() na mesma estação já tocando alterna pause em vez de recarregar', () async {
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      keepAlive();
      final notifier = container.read(radioViewModelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.play(_station);
      handler.playbackState.add(PlaybackState(playing: true));
      await Future<void>.delayed(Duration.zero);

      await notifier.play(_station);

      expect(handler.paused, isTrue);
      expect(handler.played, isFalse);
    });

    test('PlaybackState do handler atualiza isPlaying/isBuffering enquanto rádio toca', () async {
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      keepAlive();
      final notifier = container.read(radioViewModelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.play(_station);
      handler.playbackState.add(PlaybackState(
        playing: false,
        processingState: AudioProcessingState.buffering,
      ));
      await Future<void>.delayed(Duration.zero);

      var state = container.read(radioViewModelProvider);
      expect(state.isBuffering, isTrue);
      expect(state.isPlaying, isFalse);

      handler.playbackState.add(PlaybackState(
        playing: true,
        processingState: AudioProcessingState.ready,
      ));
      await Future<void>.delayed(Duration.zero);

      state = container.read(radioViewModelProvider);
      expect(state.isPlaying, isTrue);
      expect(state.isBuffering, isFalse);
    });

    test('mediaItem sem isRadio (handler tocando outra coisa) reseta nowPlayingId', () async {
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      keepAlive();
      final notifier = container.read(radioViewModelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.play(_station);
      handler.playbackState.add(PlaybackState(playing: true));
      await Future<void>.delayed(Duration.zero);
      expect(container.read(radioViewModelProvider).nowPlayingId, _station.id);

      // Handler compartilhado passa a tocar um episódio de podcast.
      handler.mediaItem.add(const MediaItem(id: 'https://x.com/ep.mp3', title: 'Episódio'));
      await Future<void>.delayed(Duration.zero);

      final state = container.read(radioViewModelProvider);
      expect(state.nowPlayingId, isNull);
      expect(state.isPlaying, isFalse);
      expect(state.isBuffering, isFalse);
    });

    test('stop() para o handler e zera nowPlaying/nowPlayingId', () async {
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      keepAlive();
      final notifier = container.read(radioViewModelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.play(_station);
      handler.playbackState.add(PlaybackState(playing: true));
      await Future<void>.delayed(Duration.zero);
      expect(container.read(radioViewModelProvider).nowPlaying, _station);

      await notifier.stop();

      final state = container.read(radioViewModelProvider);
      expect(state.nowPlayingId, isNull);
      expect(state.nowPlaying, isNull);
      expect(state.isPlaying, isFalse);
      expect(state.isBuffering, isFalse);
    });
  });

  group('busca', () {
    const stationSp = RadioStation(
      id: 'sp',
      name: 'Rádio SP FM',
      streamUrl: 'https://x.com/sp',
      genre: 'Rock',
      state: 'São Paulo',
    );
    const stationRj = RadioStation(
      id: 'rj',
      name: 'Rádio RJ',
      streamUrl: 'https://x.com/rj',
      genre: 'Sertanejo',
      state: 'Rio de Janeiro',
    );

    test('setQuery atualiza state.query', () async {
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      keepAlive();
      final notifier = container.read(radioViewModelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      notifier.setQuery('rock');

      expect(container.read(radioViewModelProvider).query, 'rock');
    });

    test('filterStations filtra por nome, gênero e estado, case-insensitive', () {
      final stations = [stationSp, stationRj];

      expect(filterStations(stations, ''), stations);
      expect(filterStations(stations, 'sp fm'), [stationSp]);
      expect(filterStations(stations, 'SERTANEJO'), [stationRj]);
      expect(filterStations(stations, 'rio de janeiro'), [stationRj]);
      expect(filterStations(stations, 'nenhuma'), isEmpty);
    });
  });

  group('favoritos', () {
    test('toggleFavorite adiciona e persiste', () async {
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      keepAlive();
      final notifier = container.read(radioViewModelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.toggleFavorite(_station.id);

      expect(container.read(radioViewModelProvider).favoriteIds, {_station.id});
      expect(prefs.favoriteRadioIds, [_station.id]);
    });

    test('toggleFavorite remove se já favoritada', () async {
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      keepAlive();
      final notifier = container.read(radioViewModelProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.toggleFavorite(_station.id);
      await notifier.toggleFavorite(_station.id);

      expect(container.read(radioViewModelProvider).favoriteIds, isEmpty);
      expect(prefs.favoriteRadioIds, isEmpty);
    });

    test('favoritos salvos antes são carregados ao abrir', () async {
      final savedPrefs = await fakePreferencesStore({
        'pref.favorite_radio_ids': [_station.id],
      });
      final freshContainer = ProviderContainer(overrides: [
        radioRepositoryProvider.overrideWithValue(repository),
        audioHandlerProvider.overrideWithValue(handler),
        preferencesStoreProvider.overrideWithValue(savedPrefs),
      ]);
      addTearDown(freshContainer.dispose);
      when(() => repository.brStations()).thenAnswer((_) async => [_station]);
      freshContainer.listen(radioViewModelProvider, (_, _) {});
      await Future<void>.delayed(Duration.zero);

      expect(freshContainer.read(radioViewModelProvider).favoriteIds, {_station.id});
    });
  });
}
