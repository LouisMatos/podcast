// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sobrescrito em `main.dart` com a instância real (mesmo padrão de
/// `audioHandlerProvider`). Em teste, sobrescrever com um store sobre
/// `SharedPreferences` mockado (`SharedPreferences.setMockInitialValues`).

@ProviderFor(preferencesStore)
final preferencesStoreProvider = PreferencesStoreProvider._();

/// Sobrescrito em `main.dart` com a instância real (mesmo padrão de
/// `audioHandlerProvider`). Em teste, sobrescrever com um store sobre
/// `SharedPreferences` mockado (`SharedPreferences.setMockInitialValues`).

final class PreferencesStoreProvider
    extends
        $FunctionalProvider<
          PreferencesStore,
          PreferencesStore,
          PreferencesStore
        >
    with $Provider<PreferencesStore> {
  /// Sobrescrito em `main.dart` com a instância real (mesmo padrão de
  /// `audioHandlerProvider`). Em teste, sobrescrever com um store sobre
  /// `SharedPreferences` mockado (`SharedPreferences.setMockInitialValues`).
  PreferencesStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesStoreHash();

  @$internal
  @override
  $ProviderElement<PreferencesStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PreferencesStore create(Ref ref) {
    return preferencesStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreferencesStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreferencesStore>(value),
    );
  }
}

String _$preferencesStoreHash() => r'02c90667b80e0091f98c78538c09c7f486e9ede1';
