// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup_feed_refresh_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dispara um refresh dos feeds assinados quando o app abre (Fase 9).
/// Respeita o throttle por feed (`LibraryRepository.refreshFeed` só rebusca
/// o que está velho). Observado uma vez pela casca (`AppShell`) — o
/// resultado não importa pra UI.

@ProviderFor(startupFeedRefresh)
final startupFeedRefreshProvider = StartupFeedRefreshProvider._();

/// Dispara um refresh dos feeds assinados quando o app abre (Fase 9).
/// Respeita o throttle por feed (`LibraryRepository.refreshFeed` só rebusca
/// o que está velho). Observado uma vez pela casca (`AppShell`) — o
/// resultado não importa pra UI.

final class StartupFeedRefreshProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Dispara um refresh dos feeds assinados quando o app abre (Fase 9).
  /// Respeita o throttle por feed (`LibraryRepository.refreshFeed` só rebusca
  /// o que está velho). Observado uma vez pela casca (`AppShell`) — o
  /// resultado não importa pra UI.
  StartupFeedRefreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startupFeedRefreshProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startupFeedRefreshHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return startupFeedRefresh(ref);
  }
}

String _$startupFeedRefreshHash() =>
    r'33d78ca2c53b7e03f01d27079e2320be029c8b60';
