import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:rss_dart/dart_rss.dart';

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
    final response = await _dio.get<String>(
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
  return feed.items.map((item) => _toEpisode(item, feed)).nonNulls.toList();
}

Episode? _toEpisode(RssItem item, RssFeed feed) {
  final audioUrl = item.enclosure?.url;
  final title = item.title;
  if (audioUrl == null || title == null) return null;

  return Episode(
    guid: item.guid ?? audioUrl,
    title: title,
    audioUrl: audioUrl,
    description: _stripHtml(item.itunes?.summary ?? item.description),
    imageUrl: item.itunes?.image?.href ?? feed.image?.url,
    duration: item.itunes?.duration,
    publishedAt: _parseDate(item.pubDate),
  );
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
