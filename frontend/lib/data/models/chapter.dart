import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';

/// Um capítulo de um episódio (Fase 14).
///
/// Vem do JSON do podcast namespace apontado por `Episode.chaptersUrl`; quem
/// baixa, persiste e devolve este modelo é o `ChapterService`.
@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required Duration start,
    required String title,
    String? imageUrl,
  }) = _Chapter;
}
