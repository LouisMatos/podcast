/// Alvo de um deep link já interpretado — o que o app deve abrir.
///
/// Esquemas cobertos:
/// - `podcastapp://podcast/<id>` — detalhe de um podcast (id = collectionId iTunes).
/// - `podcastapp://episode/<podcastId>/<guid>` — descrição de um episódio.
/// - `http(s)://.../feed.xml`, `content://…`, `file://…` — candidato a feed RSS
///   externo (intent VIEW de outro app).
sealed class DeepLinkTarget {
  const DeepLinkTarget();
}

class DeepLinkPodcast extends DeepLinkTarget {
  const DeepLinkPodcast(this.id);

  final int id;

  @override
  bool operator ==(Object other) => other is DeepLinkPodcast && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DeepLinkEpisode extends DeepLinkTarget {
  const DeepLinkEpisode(this.podcastId, this.guid);

  final int podcastId;
  final String guid;

  @override
  bool operator ==(Object other) =>
      other is DeepLinkEpisode && other.podcastId == podcastId && other.guid == guid;

  @override
  int get hashCode => Object.hash(podcastId, guid);
}

class DeepLinkFeed extends DeepLinkTarget {
  const DeepLinkFeed(this.url);

  final String url;

  @override
  bool operator ==(Object other) => other is DeepLinkFeed && other.url == url;

  @override
  int get hashCode => url.hashCode;
}

class DeepLinkUnknown extends DeepLinkTarget {
  const DeepLinkUnknown();

  @override
  bool operator ==(Object other) => other is DeepLinkUnknown;

  @override
  int get hashCode => 0;
}

/// Função pura: [Uri] recebido por intent/link → [DeepLinkTarget].
DeepLinkTarget parseDeepLink(Uri uri) {
  final scheme = uri.scheme.toLowerCase();

  if (scheme == 'podcastapp') {
    final host = uri.host.toLowerCase();
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

    if (host == 'podcast' && segments.isNotEmpty) {
      final id = int.tryParse(segments.first);
      return id == null ? const DeepLinkUnknown() : DeepLinkPodcast(id);
    }

    if (host == 'episode' && segments.length >= 2) {
      final podcastId = int.tryParse(segments.first);
      if (podcastId == null) return const DeepLinkUnknown();
      // O guid pode conter `/` (guids costumam ser URLs) — junta o resto do
      // path e decodifica (veio URL-encoded).
      final rawGuid = segments.skip(1).join('/');
      final guid = Uri.decodeComponent(rawGuid);
      return guid.isEmpty ? const DeepLinkUnknown() : DeepLinkEpisode(podcastId, guid);
    }

    return const DeepLinkUnknown();
  }

  // Qualquer http(s)/content/file que chegou por intent VIEW é candidato a feed.
  if (scheme == 'http' || scheme == 'https' || scheme == 'content' || scheme == 'file') {
    return DeepLinkFeed(uri.toString());
  }

  return const DeepLinkUnknown();
}

/// Rota `/resolve/*` que resolve um [DeepLinkTarget]. É o seam usado pelo
/// `redirect` do `GoRouter` (`appRouter`): a plataforma entrega o intent VIEW
/// como localização crua, o `redirect` chama `parseDeepLink` + isto.
String locationForDeepLink(DeepLinkTarget target) {
  return switch (target) {
    DeepLinkPodcast(:final id) => '/resolve/podcast/$id',
    DeepLinkEpisode(:final podcastId, :final guid) =>
      Uri(path: '/resolve/episode/$podcastId', queryParameters: {'guid': guid}).toString(),
    DeepLinkFeed(:final url) =>
      Uri(path: '/resolve/feed', queryParameters: {'url': url}).toString(),
    DeepLinkUnknown() => '/home',
  };
}
