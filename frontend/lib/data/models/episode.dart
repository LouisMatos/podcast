import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';

/// Um episódio de um podcast, extraído do feed RSS.
///
/// A tradução do XML bruto pra este modelo acontece em
/// `data/sources/rss_feed_parser.dart`.
@freezed
abstract class Episode with _$Episode {
  const factory Episode({
    required String guid,
    required String title,
    required String audioUrl,
    String? description,
    String? imageUrl,
    Duration? duration,
    DateTime? publishedAt,

    /// Metadados avançados (Fase 14) — todos opcionais, o feed pode não
    /// declarar nenhum.
    int? seasonNumber,
    int? episodeNumber,

    /// `full` | `trailer` | `bonus`, do `itunes:episodeType`.
    String? episodeType,

    /// `<link>` do item — página do episódio no site do podcast.
    String? link,

    /// URL do JSON de capítulos (`<podcast:chapters>`).
    String? chaptersUrl,
  }) = _Episode;
}
