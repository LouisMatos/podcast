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
  }) = _Episode;
}
