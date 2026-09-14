// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel da tela de descoberta. Sem import de Flutter — testável sem
/// widget. A View só chama [onQueryChanged] / [setMode] e lê o [DiscoverState].

@ProviderFor(DiscoverViewModel)
final discoverViewModelProvider = DiscoverViewModelProvider._();

/// ViewModel da tela de descoberta. Sem import de Flutter — testável sem
/// widget. A View só chama [onQueryChanged] / [setMode] e lê o [DiscoverState].
final class DiscoverViewModelProvider
    extends $NotifierProvider<DiscoverViewModel, DiscoverState> {
  /// ViewModel da tela de descoberta. Sem import de Flutter — testável sem
  /// widget. A View só chama [onQueryChanged] / [setMode] e lê o [DiscoverState].
  DiscoverViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverViewModelHash();

  @$internal
  @override
  DiscoverViewModel create() => DiscoverViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoverState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoverState>(value),
    );
  }
}

String _$discoverViewModelHash() => r'63803f58ae0afbf4a39cc3aee1aa193c81121c6f';

/// ViewModel da tela de descoberta. Sem import de Flutter — testável sem
/// widget. A View só chama [onQueryChanged] / [setMode] e lê o [DiscoverState].

abstract class _$DiscoverViewModel extends $Notifier<DiscoverState> {
  DiscoverState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DiscoverState, DiscoverState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiscoverState, DiscoverState>,
              DiscoverState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
