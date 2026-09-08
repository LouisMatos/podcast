// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_shortcuts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sobrescrito com uma instância já `register()`-ada em `main.dart` — o
/// `quick_actions` precisa registrar o handler Pigeon **antes** do `runApp`,
/// senão o atalho de cold start (entregue no attach da Activity) se perde.

@ProviderFor(appShortcuts)
final appShortcutsProvider = AppShortcutsProvider._();

/// Sobrescrito com uma instância já `register()`-ada em `main.dart` — o
/// `quick_actions` precisa registrar o handler Pigeon **antes** do `runApp`,
/// senão o atalho de cold start (entregue no attach da Activity) se perde.

final class AppShortcutsProvider
    extends $FunctionalProvider<AppShortcuts, AppShortcuts, AppShortcuts>
    with $Provider<AppShortcuts> {
  /// Sobrescrito com uma instância já `register()`-ada em `main.dart` — o
  /// `quick_actions` precisa registrar o handler Pigeon **antes** do `runApp`,
  /// senão o atalho de cold start (entregue no attach da Activity) se perde.
  AppShortcutsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appShortcutsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appShortcutsHash();

  @$internal
  @override
  $ProviderElement<AppShortcuts> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppShortcuts create(Ref ref) {
    return appShortcuts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppShortcuts value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppShortcuts>(value),
    );
  }
}

String _$appShortcutsHash() => r'1bab9d6880246b12fb6c7f1fb14411d076319a9d';

@ProviderFor(shortcutActionStream)
final shortcutActionStreamProvider = ShortcutActionStreamProvider._();

final class ShortcutActionStreamProvider
    extends $FunctionalProvider<AsyncValue<String>, String, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String> {
  ShortcutActionStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shortcutActionStreamProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shortcutActionStreamHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String> create(Ref ref) {
    return shortcutActionStream(ref);
  }
}

String _$shortcutActionStreamHash() =>
    r'11de2327baa4450e7ba17ec1718897d2939f6fde';
