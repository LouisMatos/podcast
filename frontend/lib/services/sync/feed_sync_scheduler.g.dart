// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_sync_scheduler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(feedSyncScheduler)
final feedSyncSchedulerProvider = FeedSyncSchedulerProvider._();

final class FeedSyncSchedulerProvider
    extends
        $FunctionalProvider<
          FeedSyncScheduler,
          FeedSyncScheduler,
          FeedSyncScheduler
        >
    with $Provider<FeedSyncScheduler> {
  FeedSyncSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedSyncSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedSyncSchedulerHash();

  @$internal
  @override
  $ProviderElement<FeedSyncScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeedSyncScheduler create(Ref ref) {
    return feedSyncScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedSyncScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedSyncScheduler>(value),
    );
  }
}

String _$feedSyncSchedulerHash() => r'7093b7ce29c0af72a4e2704194d61364c5f47777';
