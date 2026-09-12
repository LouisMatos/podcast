import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';

/// Rankings de podcast da Apple (públicos, sem chave).
///
/// - Geral: "Marketing Tools" RSS
///   (`https://rss.marketingtools.apple.com/api/v2/br/podcasts/top/<limit>/podcasts.json`).
/// - Por categoria: RSS legado
///   (`https://itunes.apple.com/br/rss/toppodcasts/limit=<limit>/genre=<id>/json`),
///   porque a Marketing Tools API não expõe filtro de gênero de forma confiável.
///
/// Devolve só os `collectionId` na ordem do ranking — o [_toPodcast] completo
/// (com `feedUrl`) vem de `ItunesSearchApi.lookup`.
class AppleChartsApi {
  AppleChartsApi(this._dio);

  final Dio _dio;

  static const String _storefront = 'br';

  Future<List<int>> topPodcastIds({int limit = 20, int? genreId}) async {
    final url = genreId == null
        ? 'https://rss.marketingtools.apple.com/api/v2/$_storefront/podcasts/top/$limit/podcasts.json'
        : 'https://itunes.apple.com/$_storefront/rss/toppodcasts/limit=$limit/genre=$genreId/json';

    // Mesma armadilha da iTunes Search API: content-type nem sempre é
    // `application/json`. Pedimos texto puro e decodificamos na mão.
    final response = await _dio.get<String>(url, options: Options(responseType: ResponseType.plain));
    final body = response.data;
    if (body == null || body.isEmpty) return const [];

    return Isolate.run(() => _parseIds(body));
  }

  static List<int> _parseIds(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final entries = (json['feed'] as Map<String, dynamic>?)?['results'] ??
        (json['feed'] as Map<String, dynamic>?)?['entry'] ??
        const [];
    if (entries is! List) return const [];

    return entries.map(_idOf).nonNulls.toList();
  }

  /// Extrai o id numérico de um item, seja o formato novo (`{"id": "123"}`)
  /// ou o legado (`{"id": {"attributes": {"im:id": "123"}}}`).
  static int? _idOf(dynamic entry) {
    if (entry is! Map<String, dynamic>) return null;

    final raw = entry['id'];
    if (raw is String) return int.tryParse(raw);
    if (raw is Map<String, dynamic>) {
      final attrs = raw['attributes'] as Map<String, dynamic>?;
      return int.tryParse(attrs?['im:id'] as String? ?? '');
    }
    return null;
  }
}
