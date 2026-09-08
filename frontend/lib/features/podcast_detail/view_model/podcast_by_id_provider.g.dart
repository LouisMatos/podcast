// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_by_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolve um [Podcast] pelo `id` (collectionId iTunes). Usado pelo
/// resolvedor de deep link — o link só traz o id, a tela de detalhe precisa
/// do modelo completo.
///
/// Primeiro tenta as assinaturas (offline, instantâneo); só cai na iTunes
/// Search API se não estiver assinado. `null` = não encontrado.

@ProviderFor(podcastById)
final podcastByIdProvider = PodcastByIdFamily._();

/// Resolve um [Podcast] pelo `id` (collectionId iTunes). Usado pelo
/// resolvedor de deep link — o link só traz o id, a tela de detalhe precisa
/// do modelo completo.
///
/// Primeiro tenta as assinaturas (offline, instantâneo); só cai na iTunes
/// Search API se não estiver assinado. `null` = não encontrado.

final class PodcastByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Podcast?>, Podcast?, FutureOr<Podcast?>>
    with $FutureModifier<Podcast?>, $FutureProvider<Podcast?> {
  /// Resolve um [Podcast] pelo `id` (collectionId iTunes). Usado pelo
  /// resolvedor de deep link — o link só traz o id, a tela de detalhe precisa
  /// do modelo completo.
  ///
  /// Primeiro tenta as assinaturas (offline, instantâneo); só cai na iTunes
  /// Search API se não estiver assinado. `null` = não encontrado.
  PodcastByIdProvider._({
    required PodcastByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'podcastByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$podcastByIdHash();

  @override
  String toString() {
    return r'podcastByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Podcast?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Podcast?> create(Ref ref) {
    final argument = this.argument as int;
    return podcastById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PodcastByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$podcastByIdHash() => r'8ce9b07762f36459978633330767b51f1d2eab38';

/// Resolve um [Podcast] pelo `id` (collectionId iTunes). Usado pelo
/// resolvedor de deep link — o link só traz o id, a tela de detalhe precisa
/// do modelo completo.
///
/// Primeiro tenta as assinaturas (offline, instantâneo); só cai na iTunes
/// Search API se não estiver assinado. `null` = não encontrado.

final class PodcastByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Podcast?>, int> {
  PodcastByIdFamily._()
    : super(
        retry: null,
        name: r'podcastByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolve um [Podcast] pelo `id` (collectionId iTunes). Usado pelo
  /// resolvedor de deep link — o link só traz o id, a tela de detalhe precisa
  /// do modelo completo.
  ///
  /// Primeiro tenta as assinaturas (offline, instantâneo); só cai na iTunes
  /// Search API se não estiver assinado. `null` = não encontrado.

  PodcastByIdProvider call(int id) =>
      PodcastByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'podcastByIdProvider';
}
