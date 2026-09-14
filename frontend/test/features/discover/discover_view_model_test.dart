import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/episode_search_result.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/podcast_repository.dart';
import 'package:podcast_app/features/discover/view_model/discover_state.dart';
import 'package:podcast_app/features/discover/view_model/discover_view_model.dart';

class _MockPodcastRepository extends Mock implements PodcastRepository {}

const _podcast = Podcast(id: 1, title: 'Podcast de Teste', author: 'Autor', feedUrl: 'https://x.com/feed.xml');

const _episodeResult = EpisodeSearchResult(
  collectionId: 42,
  collectionName: 'Podcast de Teste',
  episode: Episode(guid: 'g1', title: 'Episódio 1', audioUrl: 'https://x.com/1.mp3'),
);

void main() {
  late _MockPodcastRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockPodcastRepository();
    // Sem cache por padrão (Fase 27.4) — testes que exercitam o caminho de
    // pintura imediata sobrescrevem essas duas chamadas.
    when(() => repository.cachedSearchResults(any())).thenAnswer((_) async => null);
    when(() => repository.cachedEpisodeSearchResults(any())).thenAnswer((_) async => null);
    container = ProviderContainer(overrides: [podcastRepositoryProvider.overrideWithValue(repository)]);
    addTearDown(container.dispose);
    // discoverViewModelProvider é autoDispose — sem um listener permanente,
    // o container derruba o notifier (e o Timer do debounce junto) assim
    // que o `read` retorna, antes do debounce ter chance de disparar.
    container.listen(discoverViewModelProvider, (_, _) {});
  });

  test('estado inicial não tem busca nem resultado', () {
    final state = container.read(discoverViewModelProvider);
    expect(state.query, isEmpty);
    expect(state.results, isEmpty);
    expect(state.isLoading, isFalse);
  });

  test('query vazia limpa resultados sem chamar o repositório', () {
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('');

    expect(container.read(discoverViewModelProvider).results, isEmpty);
    verifyNever(() => repository.search(any()));
  });

  test('busca só dispara depois do debounce, uma vez só', () async {
    when(() => repository.search('flutter')).thenAnswer((_) async => [_podcast]);
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('flutter');
    verifyNever(() => repository.search(any()));
    expect(container.read(discoverViewModelProvider).isLoading, isFalse);

    await Future<void>.delayed(const Duration(milliseconds: 450));

    verify(() => repository.search('flutter')).called(1);
    final state = container.read(discoverViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.results, [_podcast]);
  });

  test('só a última letra digitada gera busca (debounce cancela a anterior)', () async {
    when(() => repository.search(any())).thenAnswer((_) async => [_podcast]);
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('f');
    notifier.onQueryChanged('fl');
    notifier.onQueryChanged('flu');

    await Future<void>.delayed(const Duration(milliseconds: 450));

    verify(() => repository.search('flu')).called(1);
    verifyNever(() => repository.search('f'));
    verifyNever(() => repository.search('fl'));
  });

  test('erro do repositório vira mensagem de erro, sem derrubar o app', () async {
    when(() => repository.search('erro')).thenThrow(Exception('sem rede'));
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('erro');
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final state = container.read(discoverViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.error, isNotNull);
    expect(state.results, isEmpty);
  });

  test('erro de conexão (DioException) marca state.offline', () async {
    when(() => repository.search('sem rede')).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/search'),
        type: DioExceptionType.connectionError,
      ),
    );
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('sem rede');
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final state = container.read(discoverViewModelProvider);
    expect(state.offline, isTrue);
    expect(state.error, isNotNull);
  });

  test('erro genérico NÃO marca state.offline', () async {
    when(() => repository.search('erro')).thenThrow(Exception('boom'));
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('erro');
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final state = container.read(discoverViewModelProvider);
    expect(state.offline, isFalse);
    expect(state.error, isNotNull);
  });

  test('retry refaz a busca da query atual', () async {
    when(() => repository.search('flutter')).thenAnswer((_) async => [_podcast]);
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 450));
    verify(() => repository.search('flutter')).called(1);

    notifier.retry();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    verify(() => repository.search('flutter')).called(1);
  });

  test('setMode(episodios) com query ativa dispara searchEpisodes e popula episodeResults', () async {
    when(() => repository.search('flutter')).thenAnswer((_) async => [_podcast]);
    when(() => repository.searchEpisodes('flutter')).thenAnswer((_) async => [_episodeResult]);
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 450));
    expect(container.read(discoverViewModelProvider).results, [_podcast]);

    notifier.setMode(SearchMode.episodios);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    verify(() => repository.searchEpisodes('flutter')).called(1);
    final state = container.read(discoverViewModelProvider);
    expect(state.mode, SearchMode.episodios);
    expect(state.episodeResults, [_episodeResult]);
    expect(state.results, isEmpty); // lista do outro modo limpa
  });

  test('setMode igual ao atual é no-op', () {
    final notifier = container.read(discoverViewModelProvider.notifier);
    notifier.onQueryChanged('flutter');
    notifier.setMode(SearchMode.podcasts);
    verifyNever(() => repository.searchEpisodes(any()));
  });

  test('voltar pro modo podcasts limpa episodeResults', () async {
    when(() => repository.search('flutter')).thenAnswer((_) async => [_podcast]);
    when(() => repository.searchEpisodes('flutter')).thenAnswer((_) async => [_episodeResult]);
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 450));
    notifier.setMode(SearchMode.episodios);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(container.read(discoverViewModelProvider).episodeResults, isNotEmpty);

    notifier.setMode(SearchMode.podcasts);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    final state = container.read(discoverViewModelProvider);
    expect(state.results, [_podcast]);
    expect(state.episodeResults, isEmpty);
  });

  test('query vazia limpa results e episodeResults', () async {
    when(() => repository.searchEpisodes('flutter')).thenAnswer((_) async => [_episodeResult]);
    final notifier = container.read(discoverViewModelProvider.notifier);

    notifier.setMode(SearchMode.episodios);
    notifier.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 450));
    expect(container.read(discoverViewModelProvider).episodeResults, isNotEmpty);

    notifier.onQueryChanged('');
    final state = container.read(discoverViewModelProvider);
    expect(state.results, isEmpty);
    expect(state.episodeResults, isEmpty);
  });

  group('stale-while-revalidate (Fase 27.4)', () {
    test('pinta cache salvo na hora, sem skeleton, e revalida por trás', () async {
      when(() => repository.cachedSearchResults('flutter')).thenAnswer((_) async => [_podcast]);
      final gate = Completer<List<Podcast>>();
      when(() => repository.search('flutter')).thenAnswer((_) => gate.future);
      final notifier = container.read(discoverViewModelProvider.notifier);

      notifier.onQueryChanged('flutter');
      await Future<void>.delayed(const Duration(milliseconds: 450));

      var state = container.read(discoverViewModelProvider);
      expect(state.results, [_podcast]);
      expect(state.isLoading, isFalse);
      expect(state.isRevalidating, isTrue);

      final fresh = [_podcast, const Podcast(id: 2, title: 'Outro', author: 'A', feedUrl: 'https://x/2.xml')];
      gate.complete(fresh);
      await Future<void>.delayed(Duration.zero);

      state = container.read(discoverViewModelProvider);
      expect(state.results, fresh);
      expect(state.isRevalidating, isFalse);
    });

    test('sem cache: mantém skeleton (isLoading) até a rede responder', () async {
      final gate = Completer<List<Podcast>>();
      when(() => repository.search('flutter')).thenAnswer((_) => gate.future);
      final notifier = container.read(discoverViewModelProvider.notifier);

      notifier.onQueryChanged('flutter');
      await Future<void>.delayed(const Duration(milliseconds: 405));

      expect(container.read(discoverViewModelProvider).isLoading, isTrue);
      gate.complete([_podcast]);
      await Future<void>.delayed(Duration.zero);
    });
  });
}
