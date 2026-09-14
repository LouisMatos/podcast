import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/podcast_repository.dart';
import 'package:podcast_app/features/discover/view_model/featured_view_model.dart';

class _MockPodcastRepository extends Mock implements PodcastRepository {}

const _podcast = Podcast(id: 1, title: 'P1', author: 'A', feedUrl: 'https://x/1.xml');
const _ranked = (rank: 1, podcast: _podcast);

void main() {
  late _MockPodcastRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockPodcastRepository();
    container = ProviderContainer(overrides: [podcastRepositoryProvider.overrideWithValue(repository)]);
    addTearDown(container.dispose);
  });

  test('sem cache: espera a rede normalmente', () async {
    when(() => repository.cachedTopPodcasts()).thenAnswer((_) async => null);
    when(() => repository.topPodcasts()).thenAnswer((_) async => [_ranked]);

    final result = await container.read(featuredViewModelProvider.future);

    expect(result, [_ranked]);
  });

  test('stale-while-revalidate (Fase 27.4): pinta cache salvo na hora e revalida por trás', () async {
    when(() => repository.cachedTopPodcasts()).thenAnswer((_) async => [_ranked]);
    final gate = Completer<List<RankedPodcast>>();
    when(() => repository.topPodcasts()).thenAnswer((_) => gate.future);

    container.listen(featuredViewModelProvider, (_, _) {});
    final seeded = await container.read(featuredViewModelProvider.future);
    expect(seeded, [_ranked]);

    const fresh = (rank: 1, podcast: Podcast(id: 2, title: 'P2', author: 'A', feedUrl: 'https://x/2.xml'));
    gate.complete([fresh]);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(featuredViewModelProvider);
    expect(state.value, [fresh]);
  });

  test('falha na revalidação depois do seed: mantém o cache exibido', () async {
    when(() => repository.cachedTopPodcasts()).thenAnswer((_) async => [_ranked]);
    when(() => repository.topPodcasts()).thenThrow(Exception('offline'));

    container.listen(featuredViewModelProvider, (_, _) {});
    final seeded = await container.read(featuredViewModelProvider.future);
    expect(seeded, [_ranked]);

    await Future<void>.delayed(Duration.zero);
    final state = container.read(featuredViewModelProvider);
    expect(state.value, [_ranked]);
    expect(state.hasError, isFalse);
  });
}
