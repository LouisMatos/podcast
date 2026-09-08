import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/services/opml/opml_import_service.dart';
import 'package:podcast_app/services/opml/opml_service.dart';

void main() {
  group('buildOpml / parseOpml', () {
    test('round-trip preserva title + feedUrl de 3 assinaturas', () {
      const subs = [
        Podcast(id: 1, title: 'Café & Código', author: 'A', feedUrl: 'https://a.com/feed.xml'),
        Podcast(id: 2, title: 'Pod "Dois"', author: 'B', feedUrl: 'https://b.com/rss'),
        Podcast(id: 3, title: 'Três <3>', author: 'C', feedUrl: 'https://c.com/feed?id=3'),
      ];

      final entries = parseOpml(buildOpml(subs));

      expect(entries, hasLength(3));
      expect(entries[0], (title: 'Café & Código', feedUrl: 'https://a.com/feed.xml'));
      expect(entries[1], (title: 'Pod "Dois"', feedUrl: 'https://b.com/rss'));
      expect(entries[2], (title: 'Três <3>', feedUrl: 'https://c.com/feed?id=3'));
    });

    test('outline aninhado (categoria) pega os feeds filhos', () {
      const xml = '''
<opml version="2.0">
  <head><title>Podcasts</title></head>
  <body>
    <outline text="Tecnologia">
      <outline type="rss" text="Pod A" xmlUrl="https://a.com/feed" />
      <outline type="rss" title="Pod B" xmlUrl="https://b.com/feed" />
    </outline>
    <outline type="rss" text="Pod C" xmlUrl="https://c.com/feed" />
    <outline text="Categoria vazia" />
  </body>
</opml>
''';

      final entries = parseOpml(xml);

      expect(entries, hasLength(3));
      expect(entries.map((e) => e.feedUrl), [
        'https://a.com/feed',
        'https://b.com/feed',
        'https://c.com/feed',
      ]);
      // title = text ?? title ?? feedUrl
      expect(entries[1].title, 'Pod B');
    });

    test('XML lixo → lista vazia', () {
      expect(parseOpml('não é xml <<<'), isEmpty);
      expect(parseOpml(''), isEmpty);
    });
  });

  group('normalizeFeedUrl', () {
    test('remove querystring, barra final e baixa a caixa', () {
      expect(normalizeFeedUrl('https://Exemplo.com/Feed/'), 'https://exemplo.com/feed');
      expect(normalizeFeedUrl('  https://a.com/rss?utm=x  '), 'https://a.com/rss');
      expect(normalizeFeedUrl('https://a.com/rss'), 'https://a.com/rss');
    });
  });
}
