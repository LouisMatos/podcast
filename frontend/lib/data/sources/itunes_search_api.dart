import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';

import '../models/episode.dart';
import '../models/episode_search_result.dart';
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

    return Isolate.run(() => _parsePodcasts(body));
  }

  /// Busca episódios avulsos (`entity=podcastEpisode`). Cada resultado traz o
  /// episódio + o mínimo do podcast dono.
  Future<List<EpisodeSearchResult>> searchEpisodes(
    String term, {
    int limit = 25,
  }) async {
    final response = await _dio.get<String>(
      _endpoint,
      queryParameters: {
        'media': 'podcast',
        'entity': 'podcastEpisode',
        'term': term,
        'limit': limit,
      },
      options: Options(responseType: ResponseType.plain),
    );

    final body = response.data;
    if (body == null || body.isEmpty) return const [];

    return Isolate.run(() => _parseEpisodeResults(body));
  }

  static List<Podcast> _parsePodcasts(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>? ?? const [];
    return results.map(_toPodcast).nonNulls.toList();
  }

  static List<EpisodeSearchResult> _parseEpisodeResults(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final results = json['results'] as List<dynamic>? ?? const [];
    return results.map(_toEpisodeResult).nonNulls.toList();
  }

  static EpisodeSearchResult? _toEpisodeResult(dynamic json) {
    if (json is! Map<String, dynamic>) return null;

    final collectionId = json['collectionId'] as int?;
    final audioUrl = json['episodeUrl'] as String?;
    final title = json['trackName'] as String?;
    // collectionId, áudio e título são obrigatórios — sem eles não dá pra
    // abrir a tela de episódio.
    if (collectionId == null || audioUrl == null || title == null) return null;

    final artworkUrl = (json['artworkUrl600'] ??
        json['artworkUrl160'] ??
        json['artworkUrl60']) as String?;

    final trackTimeMillis = json['trackTimeMillis'] as int?;

    final episode = Episode(
      guid: json['episodeGuid'] as String? ?? 'itunes:${json['trackId']}',
      title: title,
      audioUrl: audioUrl,
      description:
          (json['description'] ?? json['shortDescription']) as String?,
      imageUrl: artworkUrl,
      duration: trackTimeMillis == null
          ? null
          : Duration(milliseconds: trackTimeMillis),
      publishedAt: DateTime.tryParse(json['releaseDate'] as String? ?? ''),
    );

    return EpisodeSearchResult(
      collectionId: collectionId,
      collectionName: json['collectionName'] as String? ?? '',
      feedUrl: json['feedUrl'] as String?,
      podcastArtworkUrl: artworkUrl,
      episode: episode,
    );
  }

  /// Resolve uma lista de `collectionId` em [Podcast]s completos (com
  /// `feedUrl`) numa única chamada ao endpoint `/lookup`.
  ///
  /// O `/lookup` **não** garante devolver na ordem pedida — o chamador que
  /// depende de ranking deve reordenar por [ids].
  Future<List<Podcast>> lookup(List<int> ids) async {
    if (ids.isEmpty) return const [];

    final response = await _dio.get<String>(
      'https://itunes.apple.com/lookup',
      queryParameters: {'id': ids.join(','), 'entity': 'podcast'},
      options: Options(responseType: ResponseType.plain),
    );

    final body = response.data;
    if (body == null || body.isEmpty) return const [];

    return Isolate.run(() => _parsePodcasts(body));
  }

  static Podcast? _toPodcast(dynamic json) {
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
