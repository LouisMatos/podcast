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
///
/// O status de assinatura NÃO mora nesse estado de propósito: ele vem de
/// `isSubscribedProvider`, que a View observa direto. Se estivesse aqui,
/// assinar/desassinar refaria o fetch inteiro do RSS a cada toque.

@ProviderFor(PodcastDetailViewModel)
final podcastDetailViewModelProvider = PodcastDetailViewModelFamily._();

/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.
///
/// O status de assinatura NÃO mora nesse estado de propósito: ele vem de
/// `isSubscribedProvider`, que a View observa direto. Se estivesse aqui,
/// assinar/desassinar refaria o fetch inteiro do RSS a cada toque.
final class PodcastDetailViewModelProvider
    extends $AsyncNotifierProvider<PodcastDetailViewModel, PodcastDetailState> {
  /// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
  /// já vem completo da busca, então carregar os episódios é a única
  /// dependência assíncrona real.
  ///
  /// O status de assinatura NÃO mora nesse estado de propósito: ele vem de
  /// `isSubscribedProvider`, que a View observa direto. Se estivesse aqui,
  /// assinar/desassinar refaria o fetch inteiro do RSS a cada toque.
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
    r'5c2ae883679d1b6a8b3e4c67ac2e9908510502d4';

/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.
///
/// O status de assinatura NÃO mora nesse estado de propósito: ele vem de
/// `isSubscribedProvider`, que a View observa direto. Se estivesse aqui,
/// assinar/desassinar refaria o fetch inteiro do RSS a cada toque.

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
  ///
  /// O status de assinatura NÃO mora nesse estado de propósito: ele vem de
  /// `isSubscribedProvider`, que a View observa direto. Se estivesse aqui,
  /// assinar/desassinar refaria o fetch inteiro do RSS a cada toque.

  PodcastDetailViewModelProvider call(Podcast podcast) =>
      PodcastDetailViewModelProvider._(argument: podcast, from: this);

  @override
  String toString() => r'podcastDetailViewModelProvider';
}

/// ViewModel do detalhe de um podcast. `family` pelo próprio [Podcast] —
/// já vem completo da busca, então carregar os episódios é a única
/// dependência assíncrona real.
///
/// O status de assinatura NÃO mora nesse estado de propósito: ele vem de
/// `isSubscribedProvider`, que a View observa direto. Se estivesse aqui,
/// assinar/desassinar refaria o fetch inteiro do RSS a cada toque.

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
