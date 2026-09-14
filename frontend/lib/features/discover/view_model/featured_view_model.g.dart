// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Carrossel "Mais ouvidos no Brasil" da tela Descobrir. Separado do
/// [DiscoverViewModel] de propósito: não deve refazer a busca debounced
/// quando o usuário digita, nem sumir quando a busca começa.
///
/// `keepAlive` — o ranking muda pouco; cachear pela sessão evita rede à toa
/// ao voltar pra aba.

@ProviderFor(FeaturedViewModel)
final featuredViewModelProvider = FeaturedViewModelProvider._();

/// Carrossel "Mais ouvidos no Brasil" da tela Descobrir. Separado do
/// [DiscoverViewModel] de propósito: não deve refazer a busca debounced
/// quando o usuário digita, nem sumir quando a busca começa.
///
/// `keepAlive` — o ranking muda pouco; cachear pela sessão evita rede à toa
/// ao voltar pra aba.
final class FeaturedViewModelProvider
    extends $AsyncNotifierProvider<FeaturedViewModel, List<RankedPodcast>> {
  /// Carrossel "Mais ouvidos no Brasil" da tela Descobrir. Separado do
  /// [DiscoverViewModel] de propósito: não deve refazer a busca debounced
  /// quando o usuário digita, nem sumir quando a busca começa.
  ///
  /// `keepAlive` — o ranking muda pouco; cachear pela sessão evita rede à toa
  /// ao voltar pra aba.
  FeaturedViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredViewModelHash();

  @$internal
  @override
  FeaturedViewModel create() => FeaturedViewModel();
}

String _$featuredViewModelHash() => r'7ec5b6576d8a1bf9641f5c4825b164bbe5f9bf41';

/// Carrossel "Mais ouvidos no Brasil" da tela Descobrir. Separado do
/// [DiscoverViewModel] de propósito: não deve refazer a busca debounced
/// quando o usuário digita, nem sumir quando a busca começa.
///
/// `keepAlive` — o ranking muda pouco; cachear pela sessão evita rede à toa
/// ao voltar pra aba.

abstract class _$FeaturedViewModel extends $AsyncNotifier<List<RankedPodcast>> {
  FutureOr<List<RankedPodcast>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<RankedPodcast>>, List<RankedPodcast>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<RankedPodcast>>, List<RankedPodcast>>,
              AsyncValue<List<RankedPodcast>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
