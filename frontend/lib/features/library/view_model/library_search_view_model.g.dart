// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_search_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Busca de episódios dentro da biblioteca (só assinaturas). Sem import de
/// Flutter — testável sem widget. Debounce de 400ms, igual `DiscoverViewModel`.

@ProviderFor(LibrarySearchViewModel)
final librarySearchViewModelProvider = LibrarySearchViewModelProvider._();

/// Busca de episódios dentro da biblioteca (só assinaturas). Sem import de
/// Flutter — testável sem widget. Debounce de 400ms, igual `DiscoverViewModel`.
final class LibrarySearchViewModelProvider
    extends $NotifierProvider<LibrarySearchViewModel, LibrarySearchState> {
  /// Busca de episódios dentro da biblioteca (só assinaturas). Sem import de
  /// Flutter — testável sem widget. Debounce de 400ms, igual `DiscoverViewModel`.
  LibrarySearchViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySearchViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchViewModelHash();

  @$internal
  @override
  LibrarySearchViewModel create() => LibrarySearchViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibrarySearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibrarySearchState>(value),
    );
  }
}

String _$librarySearchViewModelHash() =>
    r'5b331cd8f64dc461f3e49af9f8f3b25de8d93683';

/// Busca de episódios dentro da biblioteca (só assinaturas). Sem import de
/// Flutter — testável sem widget. Debounce de 400ms, igual `DiscoverViewModel`.

abstract class _$LibrarySearchViewModel extends $Notifier<LibrarySearchState> {
  LibrarySearchState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibrarySearchState, LibrarySearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibrarySearchState, LibrarySearchState>,
              LibrarySearchState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
