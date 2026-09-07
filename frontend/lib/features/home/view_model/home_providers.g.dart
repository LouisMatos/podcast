// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Continuar ouvindo" — episódios começados e não terminados, cross-assinatura.

@ProviderFor(continueListening)
final continueListeningProvider = ContinueListeningProvider._();

/// "Continuar ouvindo" — episódios começados e não terminados, cross-assinatura.

final class ContinueListeningProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ContinueListeningItem>>,
          List<ContinueListeningItem>,
          Stream<List<ContinueListeningItem>>
        >
    with
        $FutureModifier<List<ContinueListeningItem>>,
        $StreamProvider<List<ContinueListeningItem>> {
  /// "Continuar ouvindo" — episódios começados e não terminados, cross-assinatura.
  ContinueListeningProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'continueListeningProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$continueListeningHash();

  @$internal
  @override
  $StreamProviderElement<List<ContinueListeningItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ContinueListeningItem>> create(Ref ref) {
    return continueListening(ref);
  }
}

String _$continueListeningHash() => r'c83c7494cca545c7213d6173ec7b080988bbb1b0';

/// "Novos episódios" — episódios recentes de todas as assinaturas.

@ProviderFor(recentEpisodes)
final recentEpisodesProvider = RecentEpisodesProvider._();

/// "Novos episódios" — episódios recentes de todas as assinaturas.

final class RecentEpisodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecentEpisodeItem>>,
          List<RecentEpisodeItem>,
          Stream<List<RecentEpisodeItem>>
        >
    with
        $FutureModifier<List<RecentEpisodeItem>>,
        $StreamProvider<List<RecentEpisodeItem>> {
  /// "Novos episódios" — episódios recentes de todas as assinaturas.
  RecentEpisodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentEpisodesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentEpisodesHash();

  @$internal
  @override
  $StreamProviderElement<List<RecentEpisodeItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecentEpisodeItem>> create(Ref ref) {
    return recentEpisodes(ref);
  }
}

String _$recentEpisodesHash() => r'2fb4160a235ccdf86c3be50ef11d226d775194ff';
