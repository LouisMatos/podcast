// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel da aba Rádio. Sem import de Flutter — testável sem widget.
/// Toca direto no `PodcastAudioHandler` compartilhado, fora do fluxo de
/// fila/progresso/capítulos do `PlayerViewModel` — o `MediaItem` da rádio
/// carrega `extras: {'isRadio': true}`, que o `PlayerViewModel` ignora.

@ProviderFor(RadioViewModel)
final radioViewModelProvider = RadioViewModelProvider._();

/// ViewModel da aba Rádio. Sem import de Flutter — testável sem widget.
/// Toca direto no `PodcastAudioHandler` compartilhado, fora do fluxo de
/// fila/progresso/capítulos do `PlayerViewModel` — o `MediaItem` da rádio
/// carrega `extras: {'isRadio': true}`, que o `PlayerViewModel` ignora.
final class RadioViewModelProvider
    extends $NotifierProvider<RadioViewModel, RadioState> {
  /// ViewModel da aba Rádio. Sem import de Flutter — testável sem widget.
  /// Toca direto no `PodcastAudioHandler` compartilhado, fora do fluxo de
  /// fila/progresso/capítulos do `PlayerViewModel` — o `MediaItem` da rádio
  /// carrega `extras: {'isRadio': true}`, que o `PlayerViewModel` ignora.
  RadioViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'radioViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$radioViewModelHash();

  @$internal
  @override
  RadioViewModel create() => RadioViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RadioState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RadioState>(value),
    );
  }
}

String _$radioViewModelHash() => r'9cab9dd1ff40acf217110ffd2c24ea0b016ef6ed';

/// ViewModel da aba Rádio. Sem import de Flutter — testável sem widget.
/// Toca direto no `PodcastAudioHandler` compartilhado, fora do fluxo de
/// fila/progresso/capítulos do `PlayerViewModel` — o `MediaItem` da rádio
/// carrega `extras: {'isRadio': true}`, que o `PlayerViewModel` ignora.

abstract class _$RadioViewModel extends $Notifier<RadioState> {
  RadioState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RadioState, RadioState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RadioState, RadioState>,
              RadioState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
