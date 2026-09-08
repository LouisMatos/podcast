import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/features/library/view_model/library_controls.dart';

LibrarySubscription _sub(
  String title, {
  int unplayed = 0,
  DateTime? last,
}) =>
    (
      podcast: Podcast(
        id: title.hashCode,
        title: title,
        author: 'autor',
        feedUrl: 'https://x.com/$title.xml',
      ),
      unplayedCount: unplayed,
      lastPublishedAt: last,
    );

void main() {
  final a = _sub('Alpha', unplayed: 1, last: DateTime(2026, 1, 10));
  final b = _sub('bravo', unplayed: 5, last: DateTime(2026, 3, 1));
  final c = _sub('Charlie', unplayed: 0, last: null);

  group('filtro por nome', () {
    test('vazio devolve tudo', () {
      final out = applyLibraryControls([a, b, c], const LibraryControlsState());
      expect(out, hasLength(3));
    });

    test('case-insensitive e com trim', () {
      final out = applyLibraryControls(
        [a, b, c],
        const LibraryControlsState(filter: '  BRA '),
      );
      expect(out, [b]);
    });

    test('sem match devolve lista vazia', () {
      final out = applyLibraryControls(
        [a, b, c],
        const LibraryControlsState(filter: 'zzz'),
      );
      expect(out, isEmpty);
    });
  });

  group('ordenação', () {
    test('recentes: lastPublishedAt desc, nulls por último', () {
      final out = applyLibraryControls(
        [a, b, c],
        const LibraryControlsState(sort: LibrarySort.recentes),
      );
      expect(out, [b, a, c]);
    });

    test('alfabetico: título A→Z case-insensitive', () {
      final out = applyLibraryControls(
        [c, a, b],
        const LibraryControlsState(sort: LibrarySort.alfabetico),
      );
      expect(out.map((s) => s.podcast.title), ['Alpha', 'bravo', 'Charlie']);
    });

    test('naoOuvidos: unplayedCount desc, depois lastPublishedAt desc', () {
      final d = _sub('Delta', unplayed: 1, last: DateTime(2026, 5, 1));
      final out = applyLibraryControls(
        [a, b, c, d],
        const LibraryControlsState(sort: LibrarySort.naoOuvidos),
      );
      // b(5) > {a(1, jan), d(1, mai)} > c(0). Empate em 1 → data desc: d antes de a.
      expect(out, [b, d, a, c]);
    });
  });

  test('não muta a lista de entrada', () {
    final input = [b, a, c];
    applyLibraryControls(input, const LibraryControlsState(sort: LibrarySort.alfabetico));
    expect(input, [b, a, c]);
  });
}
