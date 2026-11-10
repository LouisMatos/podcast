import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/podcast_repository.dart';
import 'package:podcast_app/features/deeplink/view_model/deep_link_resolution.dart';

class _MockPodcastRepository extends Mock implements PodcastRepository {}

class _MockLibraryRepository extends Mock implements LibraryRepository {}

const _podcast = Podcast(id: 1, title: 'P1', author: 'A', feedUrl: 'https://x/1.xml');
const _ep1 = Episode(guid: 'g1', title: 'E1', audioUrl: 'a1');
const _ep2 = Episode(guid: 'g2', title: 'E2', audioUrl: 'a2');

void main() {
  late _MockPodcastRepository podcastRepository;
  late _MockLibraryRepository libraryRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_podcast);
  });

  setUp(() {
    podcastRepository = _MockPodcastRepository();
    libraryRepository = _MockLibraryRepository();
    when(() => libraryRepository.watchSubscriptions()).thenAnswer((_) => Stream.value([_podcast]));
    container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        podcastRepositoryProvider.overrideWithValue(podcastRepository),
        libraryRepositoryProvider.overrideWithValue(libraryRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  test('casa episódio pelo cache local quando existe', () async {
    when(() => libraryRepository.cachedEpisodes(1, includeArchived: true))
        .thenAnswer((_) async => [_ep1, _ep2]);

    final result =
        await container.read(resolvedDeepLinkEpisodeProvider(1, 'g2').future);

    expect(result?.podcast, _podcast);
    expect(result?.episode, _ep2);
    verifyNever(() => podcastRepository.episodesFor(any()));
  });

  test('cai pro RSS ao vivo quando não está no cache', () async {
    when(() => libraryRepository.cachedEpisodes(1, includeArchived: true))
        .thenAnswer((_) async => [_ep1]);
    when(() => podcastRepository.episodesFor(_podcast)).thenAnswer((_) async => [_ep1, _ep2]);

    final result =
        await container.read(resolvedDeepLinkEpisodeProvider(1, 'g2').future);

    expect(result?.episode, _ep2);
  });

  test('null quando o podcast não é encontrado', () async {
    when(() => libraryRepository.watchSubscriptions()).thenAnswer((_) => Stream.value([]));
    when(() => podcastRepository.podcastById(99)).thenAnswer((_) async => null);

    final result =
        await container.read(resolvedDeepLinkEpisodeProvider(99, 'g1').future);

    expect(result, isNull);
  });

  test('null quando o guid não casa em cache nem em RSS', () async {
    when(() => libraryRepository.cachedEpisodes(1, includeArchived: true))
        .thenAnswer((_) async => [_ep1]);
    when(() => podcastRepository.episodesFor(_podcast)).thenAnswer((_) async => [_ep1]);

    final result =
        await container.read(resolvedDeepLinkEpisodeProvider(1, 'inexistente').future);

    expect(result, isNull);
  });
}
