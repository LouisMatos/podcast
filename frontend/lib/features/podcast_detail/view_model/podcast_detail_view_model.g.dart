// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.

@ProviderFor(PodcastDetailViewModel)
final podcastDetailViewModelProvider = PodcastDetailViewModelFamily._();

/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.
final class PodcastDetailViewModelProvider
    extends $AsyncNotifierProvider<PodcastDetailViewModel, PodcastDetailState> {
  /// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
  /// já vem completo da busca, então carregar os episódios é a única
  /// dependência assíncrona real.
  PodcastDetailViewModelProvider._({
    required PodcastDetailViewModelFamily super.from,
    required Podcast super.argument,
  }) : super(
         retry: null,
         name: r'podcastDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastDetailViewModelHash();

  @override
  String toString() {
    return r'podcastDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PodcastDetailViewModel create() => PodcastDetailViewModel();

  @override
  bool operator ==(Object other) {
    return other is PodcastDetailViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastDetailViewModelHash() =>
    r'6e477d51ce41cd4edd75a22919b21bb1fbd2c83b';

/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.

final class PodcastDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          PodcastDetailViewModel,
          AsyncValue<PodcastDetailState>,
          PodcastDetailState,
          FutureOr<PodcastDetailState>,
          Podcast
        > {
  PodcastDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'podcastDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
  /// já vem completo da busca, então carregar os episódios é a única
  /// dependência assíncrona real.

  PodcastDetailViewModelProvider call(Podcast podcast) =>
      PodcastDetailViewModelProvider._(argument: podcast, from: this);

  @override
  String toString() => r'podcastDetailViewModelProvider';
}

/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.

abstract class _$PodcastDetailViewModel
    extends $AsyncNotifier<PodcastDetailState> {
  late final _$args = ref.$arg as Podcast;
  Podcast get podcast => _$args;

  FutureOr<PodcastDetailState> build(Podcast podcast);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PodcastDetailState>, PodcastDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PodcastDetailState>, PodcastDetailState>,
              AsyncValue<PodcastDetailState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
