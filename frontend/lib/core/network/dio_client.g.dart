// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
/// uma rede ruim não travar a UI por muito tempo.
///
/// `keepAlive`: singleton de app — repositórios `keepAlive` dependem dele
/// (`riverpod_lint: only_use_keep_alive_inside_keep_alive`).
///
/// [RetryInterceptor] reenvia GETs que caíram por rede instável ou erro
/// transitório do servidor (502/503/504).

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

/// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
/// uma rede ruim não travar a UI por muito tempo.
///
/// `keepAlive`: singleton de app — repositórios `keepAlive` dependem dele
/// (`riverpod_lint: only_use_keep_alive_inside_keep_alive`).
///
/// [RetryInterceptor] reenvia GETs que caíram por rede instável ou erro
/// transitório do servidor (502/503/504).

final class DioClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
  /// uma rede ruim não travar a UI por muito tempo.
  ///
  /// `keepAlive`: singleton de app — repositórios `keepAlive` dependem dele
  /// (`riverpod_lint: only_use_keep_alive_inside_keep_alive`).
  ///
  /// [RetryInterceptor] reenvia GETs que caíram por rede instável ou erro
  /// transitório do servidor (502/503/504).
  DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioClientHash() => r'039e66c601eb1ca2e1c06d6d55fbd73dcea5744a';
