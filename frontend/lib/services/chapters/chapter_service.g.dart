// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `keepAlive`: só depende de outros `keepAlive` (Dio e banco), e o player
/// vive fora da árvore de widgets.

@ProviderFor(chapterService)
final chapterServiceProvider = ChapterServiceProvider._();

/// `keepAlive`: só depende de outros `keepAlive` (Dio e banco), e o player
/// vive fora da árvore de widgets.

final class ChapterServiceProvider
    extends $FunctionalProvider<ChapterService, ChapterService, ChapterService>
    with $Provider<ChapterService> {
  /// `keepAlive`: só depende de outros `keepAlive` (Dio e banco), e o player
  /// vive fora da árvore de widgets.
  ChapterServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterServiceHash();

  @$internal
  @override
  $ProviderElement<ChapterService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChapterService create(Ref ref) {
    return chapterService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterService>(value),
    );
  }
}

String _$chapterServiceHash() => r'249875e65f3d05a2d2216feca45a0041a88673ff';
