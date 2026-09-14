// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `keepAlive`: sem estado próprio, mesmo padrão de `podcastRepositoryProvider`.

@ProviderFor(radioRepository)
final radioRepositoryProvider = RadioRepositoryProvider._();

/// `keepAlive`: sem estado próprio, mesmo padrão de `podcastRepositoryProvider`.

final class RadioRepositoryProvider
    extends
        $FunctionalProvider<RadioRepository, RadioRepository, RadioRepository>
    with $Provider<RadioRepository> {
  /// `keepAlive`: sem estado próprio, mesmo padrão de `podcastRepositoryProvider`.
  RadioRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'radioRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$radioRepositoryHash();

  @$internal
  @override
  $ProviderElement<RadioRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RadioRepository create(Ref ref) {
    return radioRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RadioRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RadioRepository>(value),
    );
  }
}

String _$radioRepositoryHash() => r'03c03d0f1f69508c67d644d136d887d1695645ab';
