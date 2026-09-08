// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
/// de novo toda vez que a tabela de assinaturas (ou o progresso/cache) muda,
/// então a tela nunca precisa dar refresh manual. Cada item já vem com os
/// metadados que a lista precisa (não-ouvidos, data do último episódio).

@ProviderFor(LibraryViewModel)
final libraryViewModelProvider = LibraryViewModelProvider._();

/// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
/// de novo toda vez que a tabela de assinaturas (ou o progresso/cache) muda,
/// então a tela nunca precisa dar refresh manual. Cada item já vem com os
/// metadados que a lista precisa (não-ouvidos, data do último episódio).
final class LibraryViewModelProvider
    extends
        $StreamNotifierProvider<LibraryViewModel, List<LibrarySubscription>> {
  /// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
  /// de novo toda vez que a tabela de assinaturas (ou o progresso/cache) muda,
  /// então a tela nunca precisa dar refresh manual. Cada item já vem com os
  /// metadados que a lista precisa (não-ouvidos, data do último episódio).
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

String _$libraryViewModelHash() => r'09b53066b7a5333572a1de95079ee32061244612';

/// ViewModel da Biblioteca. `build()` devolve um `Stream` — o drift emite
/// de novo toda vez que a tabela de assinaturas (ou o progresso/cache) muda,
/// então a tela nunca precisa dar refresh manual. Cada item já vem com os
/// metadados que a lista precisa (não-ouvidos, data do último episódio).

abstract class _$LibraryViewModel
    extends $StreamNotifier<List<LibrarySubscription>> {
  Stream<List<LibrarySubscription>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<LibrarySubscription>>,
              List<LibrarySubscription>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LibrarySubscription>>,
                List<LibrarySubscription>
              >,
              AsyncValue<List<LibrarySubscription>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
