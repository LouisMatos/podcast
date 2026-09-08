import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/features/library/view_model/library_search_view_model.dart';

class _MockLibraryRepository extends Mock implements LibraryRepository {}

const _podcast = Podcast(
  id: 1,
  title: 'Podcast de Teste',
  author: 'Autor',
  feedUrl: 'https://x.com/feed.xml',
);

const _item = (
  podcast: _podcast,
  episode: Episode(guid: 'g1', title: 'Episódio 1', audioUrl: 'https://x.com/1.mp3'),
);

void main() {
  late _MockLibraryRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockLibraryRepository();
    container = ProviderContainer(
      overrides: [libraryRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    container.listen(librarySearchViewModelProvider, (_, _) {});
  });

  test('estado inicial vazio', () {
    final state = container.read(librarySearchViewModelProvider);
    expect(state.query, isEmpty);
    expect(state.results, isEmpty);
    expect(state.isLoading, isFalse);
  });

  test('query vazia limpa sem chamar o repositório', () {
    final notifier = container.read(librarySearchViewModelProvider.notifier);
    notifier.onQueryChanged('   ');
    expect(container.read(librarySearchViewModelProvider).results, isEmpty);
    verifyNever(() => repository.searchLibraryEpisodes(any()));
  });

  test('busca dispara depois do debounce e popula results', () async {
    when(() => repository.searchLibraryEpisodes('flutter'))
        .thenAnswer((_) async => [_item]);
    final notifier = container.read(librarySearchViewModelProvider.notifier);

    notifier.onQueryChanged('flutter');
    verifyNever(() => repository.searchLibraryEpisodes(any()));

    await Future<void>.delayed(const Duration(milliseconds: 450));

    verify(() => repository.searchLibraryEpisodes('flutter')).called(1);
    final state = container.read(librarySearchViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.results, [_item]);
  });

  test('só a última query digitada busca (debounce cancela a anterior)', () async {
    when(() => repository.searchLibraryEpisodes(any()))
        .thenAnswer((_) async => [_item]);
    final notifier = container.read(librarySearchViewModelProvider.notifier);

    notifier.onQueryChanged('f');
    notifier.onQueryChanged('fl');
    notifier.onQueryChanged('flu');
    await Future<void>.delayed(const Duration(milliseconds: 450));

    verify(() => repository.searchLibraryEpisodes('flu')).called(1);
    verifyNever(() => repository.searchLibraryEpisodes('f'));
  });

  test('erro do repositório vira mensagem, sem derrubar', () async {
    when(() => repository.searchLibraryEpisodes('erro'))
        .thenThrow(Exception('sem rede'));
    final notifier = container.read(librarySearchViewModelProvider.notifier);

    notifier.onQueryChanged('erro');
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final state = container.read(librarySearchViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.error, isNotNull);
    expect(state.results, isEmpty);
  });
}
