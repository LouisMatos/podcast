// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_browser_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaBrowserSource)
final mediaBrowserSourceProvider = MediaBrowserSourceProvider._();

final class MediaBrowserSourceProvider
    extends
        $FunctionalProvider<
          RepoMediaBrowserSource,
          RepoMediaBrowserSource,
          RepoMediaBrowserSource
        >
    with $Provider<RepoMediaBrowserSource> {
  MediaBrowserSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaBrowserSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaBrowserSourceHash();

  @$internal
  @override
  $ProviderElement<RepoMediaBrowserSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RepoMediaBrowserSource create(Ref ref) {
    return mediaBrowserSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RepoMediaBrowserSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RepoMediaBrowserSource>(value),
    );
  }
}

String _$mediaBrowserSourceHash() =>
    r'08d9558451b73b34e833d9435bc9a0c00794ca2b';

/// Seam de fiação: liga a árvore de mídia ao handler. O integrador chama
/// `ref.listen(mediaBrowserWiringProvider, (_, _) {})` no AppShell.

@ProviderFor(mediaBrowserWiring)
final mediaBrowserWiringProvider = MediaBrowserWiringProvider._();

/// Seam de fiação: liga a árvore de mídia ao handler. O integrador chama
/// `ref.listen(mediaBrowserWiringProvider, (_, _) {})` no AppShell.

final class MediaBrowserWiringProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Seam de fiação: liga a árvore de mídia ao handler. O integrador chama
  /// `ref.listen(mediaBrowserWiringProvider, (_, _) {})` no AppShell.
  MediaBrowserWiringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaBrowserWiringProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaBrowserWiringHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return mediaBrowserWiring(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$mediaBrowserWiringHash() =>
    r'50e6d80fca78d8d978843b65bfd4f0dcc3df6ab0';
