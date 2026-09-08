import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/theme/app_theme.dart';
import 'package:podcast_app/core/widgets/episode_row.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';

/// Fase 18 — acessibilidade: o tile de episódio precisa ser lido pelo
/// TalkBack como um bloco único (título + subtítulo), não em pedaços.
void main() {
  const podcast = Podcast(
    id: 1,
    title: 'Meu Podcast',
    author: 'Autor',
    feedUrl: 'https://x/f.xml',
  );
  const episode = Episode(
    guid: 'g1',
    title: 'Um título de episódio',
    audioUrl: 'https://x/e1.mp3',
  );

  Widget wrap(Widget child) => MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );

  testWidgets('título e subtítulo são lidos como um bloco só', (tester) async {
    await tester.pumpWidget(
      wrap(
        const EpisodeRow(
          podcast: podcast,
          episode: episode,
          subtitle: 'Meu Podcast • 12min',
        ),
      ),
    );

    final semantics = tester.getSemantics(find.text('Um título de episódio'));
    expect(semantics.label, contains('Um título de episódio'));
    expect(semantics.label, contains('Meu Podcast • 12min'));
  });

  testWidgets('a capa não vira nó de semântica próprio', (tester) async {
    await tester.pumpWidget(
      wrap(
        const EpisodeRow(podcast: podcast, episode: episode, subtitle: 'sub'),
      ),
    );

    // A capa cai no fallback (sem rede) — deve estar fora da árvore semântica.
    expect(tester.getSemantics(find.byIcon(Icons.graphic_eq)).label, isEmpty);
  });
}
