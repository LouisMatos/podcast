// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_feed_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fluxo "assinar este feed RSS" — aberto por um deep link `http(s)://…`
/// (intent VIEW de outro app). Lê o feed, tenta casá-lo com um resultado da
/// iTunes (pra ter o `collectionId` real) e, se não achar, sintetiza um
/// [Podcast] com id derivado da URL.

@ProviderFor(SubscribeFeedViewModel)
final subscribeFeedViewModelProvider = SubscribeFeedViewModelFamily._();

/// Fluxo "assinar este feed RSS" — aberto por um deep link `http(s)://…`
/// (intent VIEW de outro app). Lê o feed, tenta casá-lo com um resultado da
/// iTunes (pra ter o `collectionId` real) e, se não achar, sintetiza um
/// [Podcast] com id derivado da URL.
final class SubscribeFeedViewModelProvider
    extends $NotifierProvider<SubscribeFeedViewModel, SubscribeFeedState> {
  /// Fluxo "assinar este feed RSS" — aberto por um deep link `http(s)://…`
  /// (intent VIEW de outro app). Lê o feed, tenta casá-lo com um resultado da
  /// iTunes (pra ter o `collectionId` real) e, se não achar, sintetiza um
  /// [Podcast] com id derivado da URL.
  SubscribeFeedViewModelProvider._({
    required SubscribeFeedViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'subscribeFeedViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subscribeFeedViewModelHash();

  @override
  String toString() {
    return r'subscribeFeedViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SubscribeFeedViewModel create() => SubscribeFeedViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscribeFeedState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscribeFeedState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SubscribeFeedViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subscribeFeedViewModelHash() =>
    r'2cb0919c974a63fee034de6af57da3980a661095';

/// Fluxo "assinar este feed RSS" — aberto por um deep link `http(s)://…`
/// (intent VIEW de outro app). Lê o feed, tenta casá-lo com um resultado da
/// iTunes (pra ter o `collectionId` real) e, se não achar, sintetiza um
/// [Podcast] com id derivado da URL.

final class SubscribeFeedViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SubscribeFeedViewModel,
          SubscribeFeedState,
          SubscribeFeedState,
          SubscribeFeedState,
          String
        > {
  SubscribeFeedViewModelFamily._()
    : super(
        retry: null,
        name: r'subscribeFeedViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fluxo "assinar este feed RSS" — aberto por um deep link `http(s)://…`
  /// (intent VIEW de outro app). Lê o feed, tenta casá-lo com um resultado da
  /// iTunes (pra ter o `collectionId` real) e, se não achar, sintetiza um
  /// [Podcast] com id derivado da URL.

  SubscribeFeedViewModelProvider call(String feedUrl) =>
      SubscribeFeedViewModelProvider._(argument: feedUrl, from: this);

  @override
  String toString() => r'subscribeFeedViewModelProvider';
}

/// Fluxo "assinar este feed RSS" — aberto por um deep link `http(s)://…`
/// (intent VIEW de outro app). Lê o feed, tenta casá-lo com um resultado da
/// iTunes (pra ter o `collectionId` real) e, se não achar, sintetiza um
/// [Podcast] com id derivado da URL.

abstract class _$SubscribeFeedViewModel extends $Notifier<SubscribeFeedState> {
  late final _$args = ref.$arg as String;
  String get feedUrl => _$args;

  SubscribeFeedState build(String feedUrl);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SubscribeFeedState, SubscribeFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SubscribeFeedState, SubscribeFeedState>,
              SubscribeFeedState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
