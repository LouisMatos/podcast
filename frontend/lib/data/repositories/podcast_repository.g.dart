// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `keepAlive`: sem estado próprio e usado por ViewModels `keepAlive`
/// (`FeaturedViewModel`) — `riverpod_lint: only_use_keep_alive_inside_keep_alive`.

@ProviderFor(podcastRepository)
final podcastRepositoryProvider = PodcastRepositoryProvider._();

/// `keepAlive`: sem estado próprio e usado por ViewModels `keepAlive`
/// (`FeaturedViewModel`) — `riverpod_lint: only_use_keep_alive_inside_keep_alive`.

final class PodcastRepositoryProvider
    extends
        $FunctionalProvider<
          PodcastRepository,
          PodcastRepository,
          PodcastRepository
        >
    with $Provider<PodcastRepository> {
  /// `keepAlive`: sem estado próprio e usado por ViewModels `keepAlive`
  /// (`FeaturedViewModel`) — `riverpod_lint: only_use_keep_alive_inside_keep_alive`.
  PodcastRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podcastRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podcastRepositoryHash();

  @$internal
  @override
  $ProviderElement<PodcastRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastRepository create(Ref ref) {
    return podcastRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastRepository>(value),
    );
  }
}

String _$podcastRepositoryHash() => r'c22ca016aba57134320689848177da1b0fb161e6';
