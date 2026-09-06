// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lista de podcasts mais ouvidos numa categoria (genreId da Apple).

@ProviderFor(CategoryViewModel)
final categoryViewModelProvider = CategoryViewModelFamily._();

/// Lista de podcasts mais ouvidos numa categoria (genreId da Apple).
final class CategoryViewModelProvider
    extends $AsyncNotifierProvider<CategoryViewModel, List<Podcast>> {
  /// Lista de podcasts mais ouvidos numa categoria (genreId da Apple).
  CategoryViewModelProvider._({
    required CategoryViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'categoryViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryViewModelHash();

  @override
  String toString() {
    return r'categoryViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CategoryViewModel create() => CategoryViewModel();

  @override
  bool operator ==(Object other) {
    return other is CategoryViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryViewModelHash() => r'5e23470ae6edd56d839355a82da4d012b5496111';

/// Lista de podcasts mais ouvidos numa categoria (genreId da Apple).

final class CategoryViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          CategoryViewModel,
          AsyncValue<List<Podcast>>,
          List<Podcast>,
          FutureOr<List<Podcast>>,
          int
        > {
  CategoryViewModelFamily._()
    : super(
        retry: null,
        name: r'categoryViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lista de podcasts mais ouvidos numa categoria (genreId da Apple).

  CategoryViewModelProvider call(int genreId) =>
      CategoryViewModelProvider._(argument: genreId, from: this);

  @override
  String toString() => r'categoryViewModelProvider';
}

/// Lista de podcasts mais ouvidos numa categoria (genreId da Apple).

abstract class _$CategoryViewModel extends $AsyncNotifier<List<Podcast>> {
  late final _$args = ref.$arg as int;
  int get genreId => _$args;

  FutureOr<List<Podcast>> build(int genreId);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
