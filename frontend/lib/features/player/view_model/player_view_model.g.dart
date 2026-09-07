// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel do player — o único que fala com o [PodcastAudioHandler].
/// `keepAlive`: o áudio toca em background e o mini-player aparece em
/// qualquer tela, então esse estado precisa sobreviver a trocas de tela.

@ProviderFor(PlayerViewModel)
final playerViewModelProvider = PlayerViewModelProvider._();

/// ViewModel do player — o único que fala com o [PodcastAudioHandler].
/// `keepAlive`: o áudio toca em background e o mini-player aparece em
/// qualquer tela, então esse estado precisa sobreviver a trocas de tela.
final class PlayerViewModelProvider
    extends $NotifierProvider<PlayerViewModel, PlayerState> {
  /// ViewModel do player — o único que fala com o [PodcastAudioHandler].
  /// `keepAlive`: o áudio toca em background e o mini-player aparece em
  /// qualquer tela, então esse estado precisa sobreviver a trocas de tela.
  PlayerViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerViewModelHash();

  @$internal
  @override
  PlayerViewModel create() => PlayerViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerState>(value),
    );
  }
}

String _$playerViewModelHash() => r'6df3a3a655096c5abccd4b977298d1d1998c4296';

/// ViewModel do player — o único que fala com o [PodcastAudioHandler].
/// `keepAlive`: o áudio toca em background e o mini-player aparece em
/// qualquer tela, então esse estado precisa sobreviver a trocas de tela.

abstract class _$PlayerViewModel extends $Notifier<PlayerState> {
  PlayerState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PlayerState, PlayerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerState, PlayerState>,
              PlayerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
