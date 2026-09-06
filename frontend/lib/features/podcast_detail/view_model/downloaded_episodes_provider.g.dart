// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_episodes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Episódios de um podcast com download concluído, ao vivo — pra aba
/// "Baixados" do detalhe.

@ProviderFor(downloadedEpisodes)
final downloadedEpisodesProvider = DownloadedEpisodesFamily._();

/// Episódios de um podcast com download concluído, ao vivo — pra aba
/// "Baixados" do detalhe.

final class DownloadedEpisodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Episode>>,
          List<Episode>,
          Stream<List<Episode>>
        >
    with $FutureModifier<List<Episode>>, $StreamProvider<List<Episode>> {
  /// Episódios de um podcast com download concluído, ao vivo — pra aba
  /// "Baixados" do detalhe.
  DownloadedEpisodesProvider._({
    required DownloadedEpisodesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'downloadedEpisodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadedEpisodesHash();

  @override
  String toString() {
    return r'downloadedEpisodesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Episode>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Episode>> create(Ref ref) {
    final argument = this.argument as int;
    return downloadedEpisodes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadedEpisodesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadedEpisodesHash() =>
    r'c82f8ff1afb0ba2bb0b503a1b385ebb5971d9d83';

/// Episódios de um podcast com download concluído, ao vivo — pra aba
/// "Baixados" do detalhe.

final class DownloadedEpisodesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Episode>>, int> {
  DownloadedEpisodesFamily._()
    : super(
        retry: null,
        name: r'downloadedEpisodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Episódios de um podcast com download concluído, ao vivo — pra aba
  /// "Baixados" do detalhe.

  DownloadedEpisodesProvider call(int podcastId) =>
      DownloadedEpisodesProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'downloadedEpisodesProvider';
}
