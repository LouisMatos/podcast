// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_download_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(autoDownloadService)
final autoDownloadServiceProvider = AutoDownloadServiceProvider._();

final class AutoDownloadServiceProvider
    extends
        $FunctionalProvider<
          AutoDownloadService,
          AutoDownloadService,
          AutoDownloadService
        >
    with $Provider<AutoDownloadService> {
  AutoDownloadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoDownloadServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoDownloadServiceHash();

  @$internal
  @override
  $ProviderElement<AutoDownloadService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AutoDownloadService create(Ref ref) {
    return autoDownloadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AutoDownloadService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AutoDownloadService>(value),
    );
  }
}

String _$autoDownloadServiceHash() =>
    r'277e403363eeed5f795a19fa964d4d4abca8e3d5';
