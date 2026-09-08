// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Histórico de escuta (Fase 17) — episódios já ouvidos, agregados por
/// episódio, do mais recente pro mais antigo.

@ProviderFor(HistoryViewModel)
final historyViewModelProvider = HistoryViewModelProvider._();

/// Histórico de escuta (Fase 17) — episódios já ouvidos, agregados por
/// episódio, do mais recente pro mais antigo.
final class HistoryViewModelProvider
    extends $StreamNotifierProvider<HistoryViewModel, List<ListenHistoryItem>> {
  /// Histórico de escuta (Fase 17) — episódios já ouvidos, agregados por
  /// episódio, do mais recente pro mais antigo.
  HistoryViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyViewModelHash();

  @$internal
  @override
  HistoryViewModel create() => HistoryViewModel();
}

String _$historyViewModelHash() => r'384045130c76cd77fe488867c9260480817e0c52';

/// Histórico de escuta (Fase 17) — episódios já ouvidos, agregados por
/// episódio, do mais recente pro mais antigo.

abstract class _$HistoryViewModel
    extends $StreamNotifier<List<ListenHistoryItem>> {
  Stream<List<ListenHistoryItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ListenHistoryItem>>,
              List<ListenHistoryItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ListenHistoryItem>>,
                List<ListenHistoryItem>
              >,
              AsyncValue<List<ListenHistoryItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
