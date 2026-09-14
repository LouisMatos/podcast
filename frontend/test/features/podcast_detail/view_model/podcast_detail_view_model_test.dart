import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/repositories/podcast_repository.dart';
import 'package:podcast_app/features/podcast_detail/view_model/podcast_detail_view_model.dart';

class _MockPodcastRepository extends Mock implements PodcastRepository {}

class _MockLibraryRepository extends Mock implements LibraryRepository {}

const _podcast = Podcast(id: 1, title: 'P1', author: 'A', feedUrl: 'https://x/1.xml');
const _ep1 = Episode(guid: 'g1', title: 'E1', audioUrl: 'a1');
const _ep2 = Episode(guid: 'g2', title: 'E2', audioUrl: 'a2');

void main() {
  late _MockPodcastRepository podcastRepository;
  late _MockLibraryRepository libraryRepository;
  late ProviderContainer container;

  setUp(() {
    podcastRepository = _MockPodcastRepository();
    libraryRepository = _MockLibraryRepository();
    when(() => libraryRepository.cacheEpisodesIfSubscribed(any(), any())).thenAnswer((_) async {});
    container = ProviderContainer(
      // Riverpod 3 reretenta provider que lança erro (até 10x, backoff) antes
      // de assentar em AsyncError — desligado aqui pro teste de falha não
      // esperar isso (mesmo ajuste de podcast_detail_screen_test.dart).
      retry: (retryCount, error) => null,
      overrides: [
        podcastRepositoryProvider.overrideWithValue(podcastRepository),
        libraryRepositoryProvider.overrideWithValue(libraryRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  test('sem cache nenhum: espera a rede, relança se falhar', () async {
    when(() => libraryRepository.cachedEpisodes(1)).thenAnswer((_) async => []);
    when(() => podcastRepository.cachedEpisodesFor(_podcast)).thenAnswer((_) async => null);
    when(() => podcastRepository.episodesFor(_podcast)).thenThrow(Exception('offline'));

    container.listen(podcastDetailViewModelProvider(_podcast), (_, _) {});
    await expectLater(
      container.read(podcastDetailViewModelProvider(_podcast).future),
      throwsA(isA<Exception>()),
    );
  });

  test('podcast assinado com cache: pinta na hora (LibraryRepository) e revalida por trás', () async {
    when(() => libraryRepository.cachedEpisodes(1)).thenAnswer((_) async => [_ep1]);
    final gate = Completer<List<Episode>>();
    when(() => podcastRepository.episodesFor(_podcast)).thenAnswer((_) => gate.future);

    container.listen(podcastDetailViewModelProvider(_podcast), (_, _) {});
    final seeded = await container.read(podcastDetailViewModelProvider(_podcast).future);
    expect(seeded.episodes, [_ep1]);

    gate.complete([_ep1, _ep2]);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(podcastDetailViewModelProvider(_podcast));
    expect(state.value!.episodes, [_ep1, _ep2]);
    verify(() => libraryRepository.cacheEpisodesIfSubscribed(1, [_ep1, _ep2])).called(1);
  });

  test('podcast não-assinado com cache genérico: pinta na hora e revalida por trás', () async {
    when(() => libraryRepository.cachedEpisodes(1)).thenAnswer((_) async => []);
    when(() => podcastRepository.cachedEpisodesFor(_podcast)).thenAnswer((_) async => [_ep1]);
    final gate = Completer<List<Episode>>();
    when(() => podcastRepository.episodesFor(_podcast)).thenAnswer((_) => gate.future);

    container.listen(podcastDetailViewModelProvider(_podcast), (_, _) {});
    final seeded = await container.read(podcastDetailViewModelProvider(_podcast).future);
    expect(seeded.episodes, [_ep1]);

    gate.complete([_ep1, _ep2]);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(podcastDetailViewModelProvider(_podcast));
    expect(state.value!.episodes, [_ep1, _ep2]);
  });

  test('falha na revalidação depois do seed: mantém o cache exibido, sem AsyncError', () async {
    when(() => libraryRepository.cachedEpisodes(1)).thenAnswer((_) async => [_ep1]);
    when(() => podcastRepository.episodesFor(_podcast)).thenThrow(Exception('offline'));

    container.listen(podcastDetailViewModelProvider(_podcast), (_, _) {});
    final seeded = await container.read(podcastDetailViewModelProvider(_podcast).future);
    expect(seeded.episodes, [_ep1]);

    await Future<void>.delayed(Duration.zero);
    final state = container.read(podcastDetailViewModelProvider(_podcast));
    expect(state.value!.episodes, [_ep1]);
    expect(state.hasError, isFalse);
  });
}
