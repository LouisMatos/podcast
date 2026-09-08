// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_resolution.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orquestra os dois awaits de um deep link de episódio: resolve o podcast
/// (assinatura ou iTunes) e depois casa o episódio por `guid` — primeiro no
/// cache local, senão no RSS ao vivo. `null` se qualquer um dos dois falhar.

@ProviderFor(resolvedDeepLinkEpisode)
final resolvedDeepLinkEpisodeProvider = ResolvedDeepLinkEpisodeFamily._();

/// Orquestra os dois awaits de um deep link de episódio: resolve o podcast
/// (assinatura ou iTunes) e depois casa o episódio por `guid` — primeiro no
/// cache local, senão no RSS ao vivo. `null` se qualquer um dos dois falhar.

final class ResolvedDeepLinkEpisodeProvider
    extends
        $FunctionalProvider<
          AsyncValue<ResolvedDeepLinkEpisode?>,
          ResolvedDeepLinkEpisode?,
          FutureOr<ResolvedDeepLinkEpisode?>
        >
    with
        $FutureModifier<ResolvedDeepLinkEpisode?>,
        $FutureProvider<ResolvedDeepLinkEpisode?> {
  /// Orquestra os dois awaits de um deep link de episódio: resolve o podcast
  /// (assinatura ou iTunes) e depois casa o episódio por `guid` — primeiro no
  /// cache local, senão no RSS ao vivo. `null` se qualquer um dos dois falhar.
  ResolvedDeepLinkEpisodeProvider._({
    required ResolvedDeepLinkEpisodeFamily super.from,
    required (int, String) super.argument,
  }) : super(
         retry: null,
         name: r'resolvedDeepLinkEpisodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$resolvedDeepLinkEpisodeHash();

  @override
  String toString() {
    return r'resolvedDeepLinkEpisodeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ResolvedDeepLinkEpisode?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ResolvedDeepLinkEpisode?> create(Ref ref) {
    final argument = this.argument as (int, String);
    return resolvedDeepLinkEpisode(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ResolvedDeepLinkEpisodeProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$resolvedDeepLinkEpisodeHash() =>
    r'14b1f55a68aa58c26a245bdc1bcdbcc9c4da3eda';

/// Orquestra os dois awaits de um deep link de episódio: resolve o podcast
/// (assinatura ou iTunes) e depois casa o episódio por `guid` — primeiro no
/// cache local, senão no RSS ao vivo. `null` se qualquer um dos dois falhar.

final class ResolvedDeepLinkEpisodeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ResolvedDeepLinkEpisode?>,
          (int, String)
        > {
  ResolvedDeepLinkEpisodeFamily._()
    : super(
        retry: null,
        name: r'resolvedDeepLinkEpisodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Orquestra os dois awaits de um deep link de episódio: resolve o podcast
  /// (assinatura ou iTunes) e depois casa o episódio por `guid` — primeiro no
  /// cache local, senão no RSS ao vivo. `null` se qualquer um dos dois falhar.

  ResolvedDeepLinkEpisodeProvider call(int podcastId, String guid) =>
      ResolvedDeepLinkEpisodeProvider._(
        argument: (podcastId, guid),
        from: this,
      );

  @override
  String toString() => r'resolvedDeepLinkEpisodeProvider';
}
