import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/podcast.dart';

/// Busca de podcasts via iTunes Search API (pública, sem chave).
/// https://performance-partners.apple.com/search-api
class ItunesSearchApi {
  ItunesSearchApi(this._dio);

  final Dio _dio;

  static const String _endpoint = 'https://itunes.apple.com/search';

  Future<List<Podcast>> search(String term, {int limit = 25}) async {
    // A API devolve `Content-Type: text/javascript`, não `application/json`
    // — o decoder automático do Dio não reconhece isso, então pedimos texto
    // puro e decodificamos o JSON na mão.
    final response = await _dio.get<String>(
      _endpoint,
      queryParameters: {
        'media': 'podcast',
        'entity': 'podcast',
        'term': term,
        'limit': limit,
      },
      options: Options(responseType: ResponseType.plain),
    );

    final body = response.data;
    if (body == null || body.isEmpty) return const [];

    final json = jsonDecode(body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>? ?? const [];
    return results.map(_toPodcast).nonNulls.toList();
  }

  Podcast? _toPodcast(dynamic json) {
    if (json is! Map<String, dynamic>) return null;

    final id = json['collectionId'] as int?;
    final title = json['collectionName'] as String?;
    final feedUrl = json['feedUrl'] as String?;
    if (id == null || title == null || feedUrl == null) return null;

    return Podcast(
      id: id,
      title: title,
      feedUrl: feedUrl,
      author: json['artistName'] as String? ?? '',
      artworkUrl: (json['artworkUrl600'] ?? json['artworkUrl100']) as String?,
      genre: json['primaryGenreName'] as String?,
      episodeCount: json['trackCount'] as int? ?? 0,
    );
  }
}
