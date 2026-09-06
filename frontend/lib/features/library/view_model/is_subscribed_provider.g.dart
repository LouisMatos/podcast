// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_subscribed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Se um podcast está assinado, ao vivo — usado pelo botão de
/// assinar/desassinar no detalhe do podcast. Fica reativo porque a
/// assinatura pode mudar em outra tela (ex: desassinar pela Biblioteca).

@ProviderFor(isSubscribed)
final isSubscribedProvider = IsSubscribedFamily._();

/// Se um podcast está assinado, ao vivo — usado pelo botão de
/// assinar/desassinar no detalhe do podcast. Fica reativo porque a
/// assinatura pode mudar em outra tela (ex: desassinar pela Biblioteca).

final class IsSubscribedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Se um podcast está assinado, ao vivo — usado pelo botão de
  /// assinar/desassinar no detalhe do podcast. Fica reativo porque a
  /// assinatura pode mudar em outra tela (ex: desassinar pela Biblioteca).
  IsSubscribedProvider._({
    required IsSubscribedFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'isSubscribedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isSubscribedHash();

  @override
  String toString() {
    return r'isSubscribedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    final argument = this.argument as int;
    return isSubscribed(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsSubscribedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isSubscribedHash() => r'e45053c60c068e4a144310837e119f0f0727aaf2';

/// Se um podcast está assinado, ao vivo — usado pelo botão de
/// assinar/desassinar no detalhe do podcast. Fica reativo porque a
/// assinatura pode mudar em outra tela (ex: desassinar pela Biblioteca).

final class IsSubscribedFamily extends $Family
    with $FunctionalFamilyOverride<Stream<bool>, int> {
  IsSubscribedFamily._()
    : super(
        retry: null,
        name: r'isSubscribedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Se um podcast está assinado, ao vivo — usado pelo botão de
  /// assinar/desassinar no detalhe do podcast. Fica reativo porque a
  /// assinatura pode mudar em outra tela (ex: desassinar pela Biblioteca).

  IsSubscribedProvider call(int podcastId) =>
      IsSubscribedProvider._(argument: podcastId, from: this);

  @override
  String toString() => r'isSubscribedProvider';
}
