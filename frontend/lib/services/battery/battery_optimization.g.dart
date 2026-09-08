// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_optimization.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(batteryOptimization)
final batteryOptimizationProvider = BatteryOptimizationProvider._();

final class BatteryOptimizationProvider
    extends
        $FunctionalProvider<
          BatteryOptimization,
          BatteryOptimization,
          BatteryOptimization
        >
    with $Provider<BatteryOptimization> {
  BatteryOptimizationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batteryOptimizationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batteryOptimizationHash();

  @$internal
  @override
  $ProviderElement<BatteryOptimization> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BatteryOptimization create(Ref ref) {
    return batteryOptimization(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatteryOptimization value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatteryOptimization>(value),
    );
  }
}

String _$batteryOptimizationHash() =>
    r'655b05d75e098e1376c2563af0905b2268336528';

@ProviderFor(batteryOptimizationIgnored)
final batteryOptimizationIgnoredProvider =
    BatteryOptimizationIgnoredProvider._();

final class BatteryOptimizationIgnoredProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  BatteryOptimizationIgnoredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batteryOptimizationIgnoredProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batteryOptimizationIgnoredHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return batteryOptimizationIgnored(ref);
  }
}

String _$batteryOptimizationIgnoredHash() =>
    r'1623681353e2239e4c281e8f4434559b6344b46c';
