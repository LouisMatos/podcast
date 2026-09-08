// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Estatísticas de escuta (Fase 17) — total, semana, sequência e os últimos
/// 7 dias, recalculadas ao vivo.

@ProviderFor(StatsViewModel)
final statsViewModelProvider = StatsViewModelProvider._();

/// Estatísticas de escuta (Fase 17) — total, semana, sequência e os últimos
/// 7 dias, recalculadas ao vivo.
final class StatsViewModelProvider
    extends $StreamNotifierProvider<StatsViewModel, ListeningStats> {
  /// Estatísticas de escuta (Fase 17) — total, semana, sequência e os últimos
  /// 7 dias, recalculadas ao vivo.
  StatsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsViewModelHash();

  @$internal
  @override
  StatsViewModel create() => StatsViewModel();
}

String _$statsViewModelHash() => r'b852e821938e807dc4154cded7de28bb216ff2cd';

/// Estatísticas de escuta (Fase 17) — total, semana, sequência e os últimos
/// 7 dias, recalculadas ao vivo.

abstract class _$StatsViewModel extends $StreamNotifier<ListeningStats> {
  Stream<ListeningStats> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ListeningStats>, ListeningStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ListeningStats>, ListeningStats>,
              AsyncValue<ListeningStats>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
