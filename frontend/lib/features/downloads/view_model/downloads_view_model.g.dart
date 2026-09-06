// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel da tela de Downloads. Reativo — remover um download em
/// qualquer lugar do app atualiza essa lista sozinho.

@ProviderFor(DownloadsViewModel)
final downloadsViewModelProvider = DownloadsViewModelProvider._();

/// ViewModel da tela de Downloads. Reativo — remover um download em
/// qualquer lugar do app atualiza essa lista sozinho.
final class DownloadsViewModelProvider
    extends
        $StreamNotifierProvider<DownloadsViewModel, List<DownloadedEpisode>> {
  /// ViewModel da tela de Downloads. Reativo — remover um download em
  /// qualquer lugar do app atualiza essa lista sozinho.
  DownloadsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadsViewModelHash();

  @$internal
  @override
  DownloadsViewModel create() => DownloadsViewModel();
}

String _$downloadsViewModelHash() =>
    r'e66909a39cb1790770e21ec78c3f096b779fdff9';

/// ViewModel da tela de Downloads. Reativo — remover um download em
/// qualquer lugar do app atualiza essa lista sozinho.

abstract class _$DownloadsViewModel
    extends $StreamNotifier<List<DownloadedEpisode>> {
  Stream<List<DownloadedEpisode>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<DownloadedEpisode>>,
              List<DownloadedEpisode>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<DownloadedEpisode>>,
                List<DownloadedEpisode>
              >,
              AsyncValue<List<DownloadedEpisode>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
