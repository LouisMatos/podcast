// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_list_controls.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Busca / filtro / ordenação da lista de episódios do detalhe. `family`
/// por `podcastId` — só estado de UI, não toca em rede.

@ProviderFor(EpisodeListControls)
final episodeListControlsProvider = EpisodeListControlsFamily._();

/// Busca / filtro / ordenação da lista de episódios do detalhe. `family`
/// por `podcastId` — só estado de UI, não toca em rede.
final class EpisodeListControlsProvider
    extends $NotifierProvider<EpisodeListControls, EpisodeListControlsState> {
  /// Busca / filtro / ordenação da lista de episódios do detalhe. `family`
  /// por `podcastId` — só estado de UI, não toca em rede.
  EpisodeListControlsProvider._({
    required EpisodeListControlsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'episodeListControlsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeListControlsHash();

  @override
  String toString() {
    return r'episodeListControlsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EpisodeListControls create() => EpisodeListControls();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EpisodeListControlsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EpisodeListControlsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeListControlsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeListControlsHash() =>
    r'caf96837b386d3ba73ae7190f08df1bd3e5fb208';

/// Busca / filtro / ordenação da lista de episódios do detalhe. `family`
/// por `podcastId` — só estado de UI, não toca em rede.

final class EpisodeListControlsFamily extends $Family
    with
        $ClassFamilyOverride<
          EpisodeListControls,
          EpisodeListControlsState,
          EpisodeListControlsState,
          EpisodeListControlsState,
          int
        > {
  EpisodeListControlsFamily._()
    : super(
        retry: null,
        name: r'episodeListControlsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Busca / filtro / ordenação da lista de episódios do detalhe. `family`
  /// por `podcastId` — só estado de UI, não toca em rede.

  EpisodeListControlsProvider call(int podcastId) =>
      EpisodeListControlsProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'episodeListControlsProvider';
}

/// Busca / filtro / ordenação da lista de episódios do detalhe. `family`
/// por `podcastId` — só estado de UI, não toca em rede.

abstract class _$EpisodeListControls
    extends $Notifier<EpisodeListControlsState> {
  late final _$args = ref.$arg as int;
  int get podcastId => _$args;

  EpisodeListControlsState build(int podcastId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<EpisodeListControlsState, EpisodeListControlsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EpisodeListControlsState, EpisodeListControlsState>,
              EpisodeListControlsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
