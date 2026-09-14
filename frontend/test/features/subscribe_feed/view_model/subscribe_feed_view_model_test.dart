import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/network/dio_client.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/podcast_repository.dart';
import 'package:podcast_app/features/subscribe_feed/view_model/subscribe_feed_view_model.dart';

class _MockPodcastRepository extends Mock implements PodcastRepository {}

class _MockLibraryRepository extends Mock implements LibraryRepository {}

/// Adapter que rejeita na hora — simula qualquer falha de rede, incluindo
/// o cancelamento por `getWithDeadline` quando o prazo de 20s estoura
/// (mesmo mecanismo testado em `core/network/dio_client_test.dart`; aqui
/// confere que o ViewModel converte isso num erro claro, não num loading
/// preso pra sempre — Fase 27.5).
class _FailingAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(requestOptions: options, type: DioExceptionType.cancel);
  }

  @override
  void close({bool force = false}) {}
}

class _XmlAdapter implements HttpClientAdapter {
  _XmlAdapter(this.xml);
  final String xml;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      xml,
      200,
      headers: {
        Headers.contentTypeHeader: ['text/xml'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _feedUrl = 'https://x.com/feed.xml';

const _validFeed = '''
<?xml version="1.0"?>
<rss><channel>
  <title>Podcast Externo</title>
  <item>
    <title>Episódio 1</title>
    <enclosure url="https://x.com/1.mp3" />
    <guid>g1</guid>
  </item>
</channel></rss>
''';

void main() {
  setUpAll(() {
    registerFallbackValue(const Podcast(id: 0, title: '', author: '', feedUrl: ''));
    registerFallbackValue(<Episode>[]);
  });

  test('erro de rede (deadline estourado ou não) vira erro claro, sem loading preso', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://x.com'))..httpClientAdapter = _FailingAdapter();
    final container = ProviderContainer(overrides: [
      dioClientProvider.overrideWithValue(dio),
    ]);
    addTearDown(container.dispose);
    container.listen(subscribeFeedViewModelProvider(_feedUrl), (_, _) {});

    await Future<void>.delayed(const Duration(milliseconds: 50));

    final state = container.read(subscribeFeedViewModelProvider(_feedUrl));
    expect(state.isLoading, isFalse);
    expect(state.error, isNotNull);
    expect(state.podcast, isNull);
  });

  test('feed lido com sucesso: isLoading cai e podcast/episódios aparecem', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://x.com'))..httpClientAdapter = _XmlAdapter(_validFeed);
    final podcastRepository = _MockPodcastRepository();
    final libraryRepository = _MockLibraryRepository();
    when(() => podcastRepository.search(any())).thenThrow(Exception('sem resultado'));
    when(() => libraryRepository.watchIsSubscribed(any())).thenAnswer((_) => Stream.value(false));

    final container = ProviderContainer(overrides: [
      dioClientProvider.overrideWithValue(dio),
      podcastRepositoryProvider.overrideWithValue(podcastRepository),
      libraryRepositoryProvider.overrideWithValue(libraryRepository),
    ]);
    addTearDown(container.dispose);
    container.listen(subscribeFeedViewModelProvider(_feedUrl), (_, _) {});

    await Future<void>.delayed(const Duration(milliseconds: 50));

    final state = container.read(subscribeFeedViewModelProvider(_feedUrl));
    expect(state.isLoading, isFalse);
    expect(state.error, isNull);
    expect(state.podcast?.title, 'Podcast Externo');
    expect(state.episodes, hasLength(1));
  });

  test('subscribe() só assina uma vez (idempotente com alreadySubscribed)', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://x.com'))..httpClientAdapter = _XmlAdapter(_validFeed);
    final podcastRepository = _MockPodcastRepository();
    final libraryRepository = _MockLibraryRepository();
    when(() => podcastRepository.search(any())).thenThrow(Exception('sem resultado'));
    when(() => libraryRepository.watchIsSubscribed(any())).thenAnswer((_) => Stream.value(false));
    when(() => libraryRepository.subscribe(any(), any())).thenAnswer((_) async {});

    final container = ProviderContainer(overrides: [
      dioClientProvider.overrideWithValue(dio),
      podcastRepositoryProvider.overrideWithValue(podcastRepository),
      libraryRepositoryProvider.overrideWithValue(libraryRepository),
    ]);
    addTearDown(container.dispose);
    final notifier = container.read(subscribeFeedViewModelProvider(_feedUrl).notifier);
    container.listen(subscribeFeedViewModelProvider(_feedUrl), (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 50));

    await notifier.subscribe();
    await notifier.subscribe();

    verify(() => libraryRepository.subscribe(any(), any())).called(1);
    expect(container.read(subscribeFeedViewModelProvider(_feedUrl)).alreadySubscribed, isTrue);
  });
}
