// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Guids arquivados de um podcast, ao vivo (Fase 13). A lista do detalhe
/// vem do RSS; o filtro de arquivados é aplicado na View com este conjunto.

@ProviderFor(archivedGuids)
final archivedGuidsProvider = ArchivedGuidsFamily._();

/// Guids arquivados de um podcast, ao vivo (Fase 13). A lista do detalhe
/// vem do RSS; o filtro de arquivados é aplicado na View com este conjunto.

final class ArchivedGuidsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  /// Guids arquivados de um podcast, ao vivo (Fase 13). A lista do detalhe
  /// vem do RSS; o filtro de arquivados é aplicado na View com este conjunto.
  ArchivedGuidsProvider._({
    required ArchivedGuidsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'archivedGuidsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archivedGuidsHash();

  @override
  String toString() {
    return r'archivedGuidsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    final argument = this.argument as int;
    return archivedGuids(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArchivedGuidsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archivedGuidsHash() => r'e3b90e419f179915c4ca980e272155b389c00a77';

/// Guids arquivados de um podcast, ao vivo (Fase 13). A lista do detalhe
/// vem do RSS; o filtro de arquivados é aplicado na View com este conjunto.

final class ArchivedGuidsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Set<String>>, int> {
  ArchivedGuidsFamily._()
    : super(
        retry: null,
        name: r'archivedGuidsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Guids arquivados de um podcast, ao vivo (Fase 13). A lista do detalhe
  /// vem do RSS; o filtro de arquivados é aplicado na View com este conjunto.

  ArchivedGuidsProvider call(int podcastId) =>
      ArchivedGuidsProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'archivedGuidsProvider';
}

/// Config de gestão automática do podcast (auto-download / limpeza / velocidade).

@ProviderFor(subscriptionSettings)
final subscriptionSettingsProvider = SubscriptionSettingsFamily._();

/// Config de gestão automática do podcast (auto-download / limpeza / velocidade).

final class SubscriptionSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubscriptionSettings>,
          SubscriptionSettings,
          Stream<SubscriptionSettings>
        >
    with
        $FutureModifier<SubscriptionSettings>,
        $StreamProvider<SubscriptionSettings> {
  /// Config de gestão automática do podcast (auto-download / limpeza / velocidade).
  SubscriptionSettingsProvider._({
    required SubscriptionSettingsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'subscriptionSettingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subscriptionSettingsHash();

  @override
  String toString() {
    return r'subscriptionSettingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<SubscriptionSettings> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SubscriptionSettings> create(Ref ref) {
    final argument = this.argument as int;
    return subscriptionSettings(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubscriptionSettingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subscriptionSettingsHash() =>
    r'e07536561f14b05ce5c5315092ed07f8ab65c8b0';

/// Config de gestão automática do podcast (auto-download / limpeza / velocidade).

final class SubscriptionSettingsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<SubscriptionSettings>, int> {
  SubscriptionSettingsFamily._()
    : super(
        retry: null,
        name: r'subscriptionSettingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Config de gestão automática do podcast (auto-download / limpeza / velocidade).

  SubscriptionSettingsProvider call(int podcastId) =>
      SubscriptionSettingsProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'subscriptionSettingsProvider';
}
