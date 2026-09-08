import 'package:xml/xml.dart';

import '../../data/models/podcast.dart';

/// Uma linha do OPML: título do podcast + URL do feed. É o que sobra depois
/// de descartar categorias e outlines sem `xmlUrl`.
typedef OpmlEntry = ({String title, String feedUrl});

/// Gera um OPML 2.0 válido com uma `<outline type="rss">` por assinatura.
/// Usa [XmlBuilder] pra escapar aspas/&/< nos títulos e URLs.
String buildOpml(List<Podcast> subscriptions) {
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('opml', nest: () {
    builder.attribute('version', '2.0');
    builder.element('head', nest: () {
      builder.element('title', nest: 'Podcasts');
    });
    builder.element('body', nest: () {
      for (final podcast in subscriptions) {
        builder.element('outline', nest: () {
          builder.attribute('type', 'rss');
          builder.attribute('text', podcast.title);
          builder.attribute('title', podcast.title);
          builder.attribute('xmlUrl', podcast.feedUrl);
        });
      }
    });
  });
  return builder.buildDocument().toXmlString(pretty: true, indent: '  ');
}

/// Extrai todo `<outline>` com `xmlUrl` não-vazio, em qualquer profundidade
/// (outlines de categoria aninham os feeds). `title` = `text` ?? `title` ??
/// a própria URL. XML mal-formado → `[]`.
List<OpmlEntry> parseOpml(String xmlString) {
  try {
    final document = XmlDocument.parse(xmlString);
    final entries = <OpmlEntry>[];
    for (final outline in document.findAllElements('outline')) {
      final feedUrl = outline.getAttribute('xmlUrl')?.trim() ?? '';
      if (feedUrl.isEmpty) continue;
      final title = outline.getAttribute('text')?.trim().isNotEmpty ?? false
          ? outline.getAttribute('text')!.trim()
          : (outline.getAttribute('title')?.trim().isNotEmpty ?? false
              ? outline.getAttribute('title')!.trim()
              : feedUrl);
      entries.add((title: title, feedUrl: feedUrl));
    }
    return entries;
  } catch (_) {
    return const [];
  }
}
