// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opml_import_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(opmlImportService)
final opmlImportServiceProvider = OpmlImportServiceProvider._();

final class OpmlImportServiceProvider
    extends
        $FunctionalProvider<
          OpmlImportService,
          OpmlImportService,
          OpmlImportService
        >
    with $Provider<OpmlImportService> {
  OpmlImportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'opmlImportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$opmlImportServiceHash();

  @$internal
  @override
  $ProviderElement<OpmlImportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpmlImportService create(Ref ref) {
    return opmlImportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpmlImportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpmlImportService>(value),
    );
  }
}

String _$opmlImportServiceHash() => r'e9f6e8bdee74e1ddd6f00ee01bcd1aa70ae7ed62';
