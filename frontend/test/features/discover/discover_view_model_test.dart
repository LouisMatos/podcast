import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/podcast_repository.dart';
import 'package:podcast_app/features/discover/view_model/discover_view_model.dart';

class _MockPodcastRepository extends Mock implements PodcastRepository {}

const _podcast = Podcast(id: 1, title: 'Podcast de Teste', author: 'Autor', feedUrl: 'https://x.com/feed.xml');

void main() {
  late _MockPodcastRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockPodcastRepository();
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
}
