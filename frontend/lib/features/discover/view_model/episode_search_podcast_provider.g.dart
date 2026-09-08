// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_search_podcast_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolve o [Podcast] dono de um resultado de busca de episódio pelo
/// `collectionId` iTunes — a busca de episódio só traz o mínimo do podcast, a
/// tela de episódio precisa do modelo completo. `null` = não encontrado.

@ProviderFor(episodeSearchPodcast)
final episodeSearchPodcastProvider = EpisodeSearchPodcastFamily._();

/// Resolve o [Podcast] dono de um resultado de busca de episódio pelo
/// `collectionId` iTunes — a busca de episódio só traz o mínimo do podcast, a
/// tela de episódio precisa do modelo completo. `null` = não encontrado.

final class EpisodeSearchPodcastProvider
    extends
        $FunctionalProvider<AsyncValue<Podcast?>, Podcast?, FutureOr<Podcast?>>
    with $FutureModifier<Podcast?>, $FutureProvider<Podcast?> {
  /// Resolve o [Podcast] dono de um resultado de busca de episódio pelo
  /// `collectionId` iTunes — a busca de episódio só traz o mínimo do podcast, a
  /// tela de episódio precisa do modelo completo. `null` = não encontrado.
  EpisodeSearchPodcastProvider._({
    required EpisodeSearchPodcastFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'episodeSearchPodcastProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeSearchPodcastHash();

  @override
  String toString() {
    return r'episodeSearchPodcastProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Podcast?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Podcast?> create(Ref ref) {
    final argument = this.argument as int;
    return episodeSearchPodcast(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeSearchPodcastProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeSearchPodcastHash() =>
    r'8515c6feee729b858335d9217be7ad90405b10fe';

/// Resolve o [Podcast] dono de um resultado de busca de episódio pelo
/// `collectionId` iTunes — a busca de episódio só traz o mínimo do podcast, a
/// tela de episódio precisa do modelo completo. `null` = não encontrado.

final class EpisodeSearchPodcastFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Podcast?>, int> {
  EpisodeSearchPodcastFamily._()
    : super(
        retry: null,
        name: r'episodeSearchPodcastProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolve o [Podcast] dono de um resultado de busca de episódio pelo
  /// `collectionId` iTunes — a busca de episódio só traz o mínimo do podcast, a
  /// tela de episódio precisa do modelo completo. `null` = não encontrado.

  EpisodeSearchPodcastProvider call(int collectionId) =>
      EpisodeSearchPodcastProvider._(argument: collectionId, from: this);

  @override
  String toString() => r'episodeSearchPodcastProvider';
}
