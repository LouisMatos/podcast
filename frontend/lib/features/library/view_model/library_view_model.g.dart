// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
/// de novo toda vez que a tabela de assinaturas muda, então a tela nunca
/// precisa dar refresh manual.

@ProviderFor(LibraryViewModel)
final libraryViewModelProvider = LibraryViewModelProvider._();

/// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
/// de novo toda vez que a tabela de assinaturas muda, então a tela nunca
/// precisa dar refresh manual.
final class LibraryViewModelProvider
    extends $StreamNotifierProvider<LibraryViewModel, List<Podcast>> {
  /// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
  /// de novo toda vez que a tabela de assinaturas muda, então a tela nunca
  /// precisa dar refresh manual.
  LibraryViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryViewModelHash();

  @$internal
  @override
  LibraryViewModel create() => LibraryViewModel();
}

String _$libraryViewModelHash() => r'86e3991d11d8620bd8701a4f41cf39c5749f8867';

/// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
/// de novo toda vez que a tabela de assinaturas muda, então a tela nunca
/// precisa dar refresh manual.

abstract class _$LibraryViewModel extends $StreamNotifier<List<Podcast>> {
  Stream<List<Podcast>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Podcast>>, List<Podcast>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Podcast>>, List<Podcast>>,
              AsyncValue<List<Podcast>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
