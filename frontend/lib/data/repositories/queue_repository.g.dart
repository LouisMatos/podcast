// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(queueRepository)
final queueRepositoryProvider = QueueRepositoryProvider._();

final class QueueRepositoryProvider
    extends
        $FunctionalProvider<QueueRepository, QueueRepository, QueueRepository>
    with $Provider<QueueRepository> {
  QueueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueRepositoryHash();

  @$internal
  @override
  $ProviderElement<QueueRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QueueRepository create(Ref ref) {
    return queueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueueRepository>(value),
    );
  }
}

String _$queueRepositoryHash() => r'2ce760897cdb0b76c26cd744083fcbfacc3363f5';

/// Stream reativo da fila persistida — a fonte de verdade da ordem.

@ProviderFor(queue)
final queueProvider = QueueProvider._();

/// Stream reativo da fila persistida — a fonte de verdade da ordem.

final class QueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QueueEntry>>,
          List<QueueEntry>,
          Stream<List<QueueEntry>>
        >
    with $FutureModifier<List<QueueEntry>>, $StreamProvider<List<QueueEntry>> {
  /// Stream reativo da fila persistida — a fonte de verdade da ordem.
  QueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueHash();

  @$internal
  @override
  $StreamProviderElement<List<QueueEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<QueueEntry>> create(Ref ref) {
    return queue(ref);
  }
}

String _$queueHash() => r'8864982a8cdc70dc9bdfee5765e21d021783636b';
