import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:xml/xml.dart';

import '../../core/network/dio_client.dart';
import '../models/episode.dart';

/// Baixa e interpreta o feed RSS de um podcast, extraindo os episódios.
/// Usa as extensões `itunes:*` do feed quando disponíveis (duração, imagem).
///
/// O parse do XML é pesado (feeds grandes têm centenas de episódios) e
/// **síncrono** — roda num isolate à parte (`Isolate.run`) pra não travar
/// a UI. Isso importa quando vários feeds são rebuscados de uma vez (Fase 9).
class RssFeedParser {
  RssFeedParser(this._dio);

  final Dio _dio;

  Future<List<Episode>> fetchEpisodes(String feedUrl) async {
    final response = await _dio.getWithDeadline<String>(
      feedUrl,
      options: Options(responseType: ResponseType.plain),
    );

    final xml = response.data;
    if (xml == null || xml.isEmpty) return const [];

    return Isolate.run(() => parseRssEpisodes(xml));
  }
}

/// Formato de data mais comum em feed RSS (RFC 822), ex:
/// "Wed, 15 Jun 2026 19:00:00 +0000".
final DateFormat _pubDateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US');

/// Top-level (roda no isolate do `compute`): XML cru → lista de [Episode].
List<Episode> parseRssEpisodes(String xml) {
  final feed = RssFeed.parse(xml);
  final extras = _parseItemExtras(xml);
  return feed.items.map((item) => _toEpisode(item, feed, extras)).nonNulls.toList();
}

Episode? _toEpisode(RssItem item, RssFeed feed, Map<String, _ItemExtras> extras) {
  final audioUrl = item.enclosure?.url;
  final title = item.title;
  if (audioUrl == null || title == null) return null;

  final extra = extras[item.guid] ?? extras[audioUrl];

  return Episode(
    guid: item.guid ?? audioUrl,
    title: title,
    audioUrl: audioUrl,
    description: _pickDescription(item),
    imageUrl: item.itunes?.image?.href ?? feed.image?.url,
    duration: item.itunes?.duration,
    publishedAt: _parseDate(item.pubDate),
    seasonNumber: item.itunes?.season,
    episodeNumber: item.itunes?.episode,
    // `rss_dart` devolve `RssItunesEpisodeType.full` quando o elemento nem
    // existe; queremos `null` nesse caso, então lemos do XML cru.
    episodeType: extra?.episodeType,
    link: _blankToNull(item.link),
    chaptersUrl: extra?.chaptersUrl,
  );
}

/// `content:encoded` costuma trazer o show notes completo enquanto o
/// `itunes:summary` traz um resumo curto — prefere o mais longo dos dois.
String? _pickDescription(RssItem item) {
  final summary = _stripHtml(item.itunes?.summary ?? item.description);
  final content = _stripHtml(item.content?.value);
  if (content == null) return summary;
  if (summary == null || content.length > summary.length) return content;
  return summary;
}

/// O que o `rss_dart` não entrega: a URL do `<podcast:chapters>` e a
/// presença (vs. default) do `<itunes:episodeType>`.
class _ItemExtras {
  const _ItemExtras({this.chaptersUrl, this.episodeType});

  final String? chaptersUrl;
  final String? episodeType;
}

/// Varre o XML cru uma vez e indexa os extras por `guid` **e** por url do
/// enclosure — o `_toEpisode` casa o `RssItem` por um dos dois.
///
/// Tolerante de propósito: o feed pode usar outro prefixo pro namespace
/// `https://podcastindex.org/namespace/1.0`, então casamos pelo nome local
/// (`chapters`) + presença do atributo `url`. Se o XML não parsear, os
/// extras somem e o resto do parse segue igual.
Map<String, _ItemExtras> _parseItemExtras(String xml) {
  final extras = <String, _ItemExtras>{};
  try {
    final document = XmlDocument.parse(xml);
    for (final item in document.findAllElements('item')) {
      final chaptersUrl = item.childElements
          .where((e) => e.name.local == 'chapters' && e.getAttribute('url') != null)
          .map((e) => e.getAttribute('url'))
          .firstOrNull;
      final episodeType = item.childElements
          .where((e) => e.name.local == 'episodeType')
          .map((e) => e.innerText.trim())
          .firstOrNull;

      if (chaptersUrl == null && episodeType == null) continue;
      final entry = _ItemExtras(
        chaptersUrl: _blankToNull(chaptersUrl),
        episodeType: _blankToNull(episodeType),
      );
      for (final key in [
        item.getElement('guid')?.innerText,
        item.getElement('enclosure')?.getAttribute('url'),
      ]) {
        if (key != null && key.isNotEmpty) extras[key] = entry;
      }
    }
  } on XmlException {
    return const {};
  }
  return extras;
}

String? _blankToNull(String? input) {
  final trimmed = input?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}

DateTime? _parseDate(String? raw) {
  if (raw == null) return null;
  try {
    return _pubDateFormat.parseUtc(raw.trim());
  } on FormatException {
    return null;
  }
}

String? _stripHtml(String? input) {
  if (input == null) return null;
  final text = input.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  return text.isEmpty ? null : text;
}
