import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/features/podcast_detail/view_model/episode_list_controls.dart';

Episode _ep(String guid, {String title = 'Ep', DateTime? date, Duration? dur}) =>
    Episode(guid: guid, title: title, audioUrl: 'https://x/$guid', publishedAt: date, duration: dur);

void main() {
  final a = _ep('a', title: 'Entrevista com fulano', date: DateTime(2024, 1, 1), dur: const Duration(minutes: 20));
  final b = _ep('b', title: 'Notícias da semana', date: DateTime(2024, 3, 1), dur: const Duration(minutes: 60));
  final c = _ep('c', title: 'Especial entrevista', date: DateTime(2024, 2, 1), dur: const Duration(minutes: 10));
  final episodes = [a, b, c];

  const progress = {
    'a': (positionSeconds: 600, completed: false),
    'b': (positionSeconds: 3600, completed: true),
  };

  test('busca por título, case-insensitive', () {
    final out = applyEpisodeControls(
      episodes,
      const EpisodeListControlsState(query: 'ENTREVISTA'),
      progress,
    );
    expect(out.map((e) => e.guid), ['c', 'a']); // ordenação padrão = recentes
  });

  test('filtro "ouvidos" usa o completed do progresso', () {
    final out = applyEpisodeControls(
      episodes,
      const EpisodeListControlsState(filter: EpisodeFilter.ouvidos),
      progress,
    );
    expect(out.map((e) => e.guid), ['b']);
  });

  test('filtro "não ouvidos" inclui quem nunca tocou', () {
    final out = applyEpisodeControls(
      episodes,
      const EpisodeListControlsState(filter: EpisodeFilter.naoOuvidos),
      progress,
    );
    expect(out.map((e) => e.guid).toSet(), {'a', 'c'});
  });

  test('ordenação recentes / antigos / mais longos', () {
    expect(
      applyEpisodeControls(episodes, const EpisodeListControlsState(), progress).map((e) => e.guid),
      ['b', 'c', 'a'],
    );
    expect(
      applyEpisodeControls(episodes, const EpisodeListControlsState(sort: EpisodeSort.antigos), progress)
          .map((e) => e.guid),
      ['a', 'c', 'b'],
    );
    expect(
      applyEpisodeControls(episodes, const EpisodeListControlsState(sort: EpisodeSort.maisLongos), progress)
          .map((e) => e.guid),
      ['b', 'a', 'c'],
    );
  });

  test('episódio sem data vai pro fim em recentes', () {
    final noDate = _ep('z', title: 'Sem data');
    final out = applyEpisodeControls([a, noDate, b], const EpisodeListControlsState(), progress);
    expect(out.last.guid, 'z');
  });
}
