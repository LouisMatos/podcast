// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Status de download de um episódio, ao vivo — usado pelo botão de
/// download na lista de episódios. `null` quer dizer "nunca foi baixado".

@ProviderFor(downloadStatus)
final downloadStatusProvider = DownloadStatusFamily._();

/// Status de download de um episódio, ao vivo — usado pelo botão de
/// download na lista de episódios. `null` quer dizer "nunca foi baixado".

final class DownloadStatusProvider
    extends
        $FunctionalProvider<AsyncValue<Download?>, Download?, Stream<Download?>>
    with $FutureModifier<Download?>, $StreamProvider<Download?> {
  /// Status de download de um episódio, ao vivo — usado pelo botão de
  /// download na lista de episódios. `null` quer dizer "nunca foi baixado".
  DownloadStatusProvider._({
    required DownloadStatusFamily super.from,
    required (int, String) super.argument,
  }) : super(
         retry: null,
         name: r'downloadStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadStatusHash();

  @override
  String toString() {
    return r'downloadStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<Download?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Download?> create(Ref ref) {
    final argument = this.argument as (int, String);
    return downloadStatus(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadStatusHash() => r'1b3b5a89b806da9add60a534fef735111e22a0c1';

/// Status de download de um episódio, ao vivo — usado pelo botão de
/// download na lista de episódios. `null` quer dizer "nunca foi baixado".

final class DownloadStatusFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Download?>, (int, String)> {
  DownloadStatusFamily._()
    : super(
        retry: null,
        name: r'downloadStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Status de download de um episódio, ao vivo — usado pelo botão de
  /// download na lista de episódios. `null` quer dizer "nunca foi baixado".

  DownloadStatusProvider call(int podcastId, String episodeGuid) =>
      DownloadStatusProvider._(argument: (podcastId, episodeGuid), from: this);

  @override
  String toString() => r'downloadStatusProvider';
}
