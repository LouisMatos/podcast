// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_audio_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Só existe de verdade depois de `AudioService.init` em `main.dart` — a
/// implementação aqui nunca roda, é sobrescrita via `overrideWithValue`
/// antes do primeiro `runApp`.

@ProviderFor(audioHandler)
final audioHandlerProvider = AudioHandlerProvider._();

/// Só existe de verdade depois de `AudioService.init` em `main.dart` — a
/// implementação aqui nunca roda, é sobrescrita via `overrideWithValue`
/// antes do primeiro `runApp`.

final class AudioHandlerProvider
    extends
        $FunctionalProvider<
          PodcastAudioHandler,
          PodcastAudioHandler,
          PodcastAudioHandler
        >
    with $Provider<PodcastAudioHandler> {
  /// Só existe de verdade depois de `AudioService.init` em `main.dart` — a
  /// implementação aqui nunca roda, é sobrescrita via `overrideWithValue`
  /// antes do primeiro `runApp`.
  AudioHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioHandlerHash();

  @$internal
  @override
  $ProviderElement<PodcastAudioHandler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PodcastAudioHandler create(Ref ref) {
    return audioHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodcastAudioHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodcastAudioHandler>(value),
    );
  }
}

String _$audioHandlerHash() => r'14813e229321a1bba18895a7e95cfc94dee5f44f';
