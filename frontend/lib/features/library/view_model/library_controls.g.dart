// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_controls.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Filtro por nome, ordenação e modo grade/lista da Biblioteca. Só estado de
/// UI — não toca em rede. `grid`/`sort` sobrevivem ao restart via
/// [PreferencesStore]; `filter` é local à sessão. keepAlive porque depende de
/// `preferencesStoreProvider` (keepAlive) e a preferência não deve cair ao
/// sair da aba.

@ProviderFor(LibraryControls)
final libraryControlsProvider = LibraryControlsProvider._();

/// Filtro por nome, ordenação e modo grade/lista da Biblioteca. Só estado de
/// UI — não toca em rede. `grid`/`sort` sobrevivem ao restart via
/// [PreferencesStore]; `filter` é local à sessão. keepAlive porque depende de
/// `preferencesStoreProvider` (keepAlive) e a preferência não deve cair ao
/// sair da aba.
final class LibraryControlsProvider
    extends $NotifierProvider<LibraryControls, LibraryControlsState> {
  /// Filtro por nome, ordenação e modo grade/lista da Biblioteca. Só estado de
  /// UI — não toca em rede. `grid`/`sort` sobrevivem ao restart via
  /// [PreferencesStore]; `filter` é local à sessão. keepAlive porque depende de
  /// `preferencesStoreProvider` (keepAlive) e a preferência não deve cair ao
  /// sair da aba.
  LibraryControlsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryControlsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryControlsHash();

  @$internal
  @override
  LibraryControls create() => LibraryControls();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryControlsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryControlsState>(value),
    );
  }
}

String _$libraryControlsHash() => r'6f8a5bf05d20aa8699ed10ad736f27c05db9e67e';

/// Filtro por nome, ordenação e modo grade/lista da Biblioteca. Só estado de
/// UI — não toca em rede. `grid`/`sort` sobrevivem ao restart via
/// [PreferencesStore]; `filter` é local à sessão. keepAlive porque depende de
/// `preferencesStoreProvider` (keepAlive) e a preferência não deve cair ao
/// sair da aba.

abstract class _$LibraryControls extends $Notifier<LibraryControlsState> {
  LibraryControlsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibraryControlsState, LibraryControlsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibraryControlsState, LibraryControlsState>,
              LibraryControlsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
