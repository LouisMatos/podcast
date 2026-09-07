import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workmanager/workmanager.dart';

part 'feed_sync_scheduler.g.dart';

/// Agenda (ou cancela) a task periódica do `WorkManager` que rebusca os
/// feeds em background (Fase 10). Fina de propósito — a lógica de sync mora
/// em `background_sync.dart`, chamada pelo `callbackDispatcher`.
class FeedSyncScheduler {
  const FeedSyncScheduler();

  /// Nome do dispatch (casado no `callbackDispatcher`) e nome único da task
  /// no WorkManager (pra atualizar/cancelar).
  static const taskName = 'com.luismatos.podcast_app.feedRefresh';
  static const uniqueName = 'podcast-feed-refresh';

  /// 6h é o padrão sugerido; o mínimo real do WorkManager é ~15min.
  static const _frequency = Duration(hours: 6);

  /// Registra a task se [enabled]; senão cancela. [wifiOnly] vira a
  /// constraint de rede do WorkManager (não tarifada vs. qualquer conexão).
  Future<void> apply({required bool enabled, required bool wifiOnly}) async {
    if (!enabled) {
      await Workmanager().cancelByUniqueName(uniqueName);
      return;
    }
    await Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: _frequency,
      constraints: Constraints(
        networkType: wifiOnly ? NetworkType.unmetered : NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    );
  }
}

@Riverpod(keepAlive: true)
FeedSyncScheduler feedSyncScheduler(Ref ref) => const FeedSyncScheduler();
