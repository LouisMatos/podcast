// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
/// uma rede ruim não travar a UI por muito tempo.

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

/// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
/// uma rede ruim não travar a UI por muito tempo.

final class DioClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
  /// uma rede ruim não travar a UI por muito tempo.
  DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioClientHash() => r'ef6734390414dbc406852d67cbc5e175fcf2f8a4';
