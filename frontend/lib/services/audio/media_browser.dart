import 'package:audio_service/audio_service.dart';

/// Ids da árvore de mídia navegável (Android Auto / MediaBrowserService).
///
/// A raiz-mãe vem da constante do `audio_service`; as quatro "pastas" de
/// primeiro nível e os episódios/podcasts usam ids próprios que também
/// servem de rota — `getChildren`/`playFromMediaId` roteiam pelo prefixo.
abstract final class MediaBrowserIds {
  /// Raiz navegável pedida pelo sistema no `onGetRoot`.
  static const String root = AudioService.browsableRootId;

  static const String continueRoot = 'continue';
  static const String queue = 'queue';
  static const String subs = 'subs';
  static const String downloads = 'downloads';

  /// Id tocável de um episódio. `guid` é encodado (pode ter `/`, `:`...).
  static String episodeMediaId(int podcastId, String guid) =>
      'ep/$podcastId/${Uri.encodeComponent(guid)}';

  /// `null` se `id` não é um id de episódio válido.
  static ({int podcastId, String guid})? parseEpisodeMediaId(String id) {
    final parts = id.split('/');
    if (parts.length != 3 || parts[0] != 'ep') return null;
    final podcastId = int.tryParse(parts[1]);
    if (podcastId == null) return null;
    return (podcastId: podcastId, guid: Uri.decodeComponent(parts[2]));
  }

  /// Id de pasta de um podcast assinado (lista os episódios do cache).
  static String subMediaId(int podcastId) => 'sub/$podcastId';

  /// `null` se `id` não é um id de pasta de podcast.
  static int? parseSubMediaId(String id) {
    final parts = id.split('/');
    if (parts.length != 2 || parts[0] != 'sub') return null;
    return int.tryParse(parts[1]);
  }
}

/// Fonte da árvore de mídia. Implementada fora do `AudioHandler` (que só
/// delega) pra manter o handler sem dependência de repositório/Riverpod.
abstract interface class MediaBrowserSource {
  Future<List<MediaItem>> getChildren(String parentMediaId);
  Future<MediaItem?> getMediaItem(String mediaId);
  Future<void> playFromMediaId(String mediaId);
}
