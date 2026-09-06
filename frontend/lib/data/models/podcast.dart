import 'package:freezed_annotation/freezed_annotation.dart';

part 'podcast.freezed.dart';

/// Um podcast, como devolvido pela busca (iTunes Search API).
///
/// A tradução do JSON bruto pra este modelo acontece em
/// `data/sources/itunes_search_api.dart` — este arquivo não sabe de onde o
/// dado veio.
@freezed
abstract class Podcast with _$Podcast {
  const factory Podcast({
    required int id,
    required String title,
    required String author,
    required String feedUrl,
    String? artworkUrl,
    String? genre,
    @Default(0) int episodeCount,
  }) = _Podcast;
}
