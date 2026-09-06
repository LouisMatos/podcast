// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Progresso de escuta de cada episódio de um podcast, ao vivo. Mapa por
/// `episodeGuid` — guid ausente quer dizer que nunca tocou.

@ProviderFor(episodeProgress)
final episodeProgressProvider = EpisodeProgressFamily._();

/// Progresso de escuta de cada episódio de um podcast, ao vivo. Mapa por
/// `episodeGuid` — guid ausente quer dizer que nunca tocou.

final class EpisodeProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, EpisodeProgress>>,
          Map<String, EpisodeProgress>,
          Stream<Map<String, EpisodeProgress>>
        >
    with
        $FutureModifier<Map<String, EpisodeProgress>>,
        $StreamProvider<Map<String, EpisodeProgress>> {
  /// Progresso de escuta de cada episódio de um podcast, ao vivo. Mapa por
  /// `episodeGuid` — guid ausente quer dizer que nunca tocou.
  EpisodeProgressProvider._({
    required EpisodeProgressFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'episodeProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$episodeProgressHash();

  @override
  String toString() {
    return r'episodeProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, EpisodeProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, EpisodeProgress>> create(Ref ref) {
    final argument = this.argument as int;
    return episodeProgress(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EpisodeProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$episodeProgressHash() => r'ab2ca65120dbea729fa83a553a374fd2342cad93';

/// Progresso de escuta de cada episódio de um podcast, ao vivo. Mapa por
/// `episodeGuid` — guid ausente quer dizer que nunca tocou.

final class EpisodeProgressFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Map<String, EpisodeProgress>>, int> {
  EpisodeProgressFamily._()
    : super(
        retry: null,
        name: r'episodeProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Progresso de escuta de cada episódio de um podcast, ao vivo. Mapa por
  /// `episodeGuid` — guid ausente quer dizer que nunca tocou.

  EpisodeProgressProvider call(int podcastId) =>
      EpisodeProgressProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'episodeProgressProvider';
}
