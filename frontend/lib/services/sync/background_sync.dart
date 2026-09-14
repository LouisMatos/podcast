import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/database/app_database.dart';
import '../../core/diagnostics/error_log.dart';
import '../../core/prefs/preferences_store.dart';
import '../../data/repositories/library_repository.dart';
import '../../data/sources/rss_feed_parser.dart';
import '../notifications/notification_service.dart';
import 'feed_sync_scheduler.dart';

/// Entry point do isolate de background do `WorkManager` (Fase 10). Roda
/// fora do app — reconstrói o mínimo (banco, Dio, repositório) sem Riverpod.
@pragma('vm:entry-point')
void feedSyncCallbackDispatcher() {
  Workmanager().executeTask((taskName, _) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (taskName != FeedSyncScheduler.taskName) return true;
    return runFeedSync();
  });
}

/// Rebusca todos os feeds assinados e, se o usuário ligou, notifica os
/// episódios inéditos. Devolve `false` só se estourar (o WorkManager
/// reagenda com backoff).
Future<bool> runFeedSync() async {
  final store = PreferencesStore(await SharedPreferences.getInstance());
  if (!store.backgroundRefreshEnabled) return true;

  final db = AppDatabase();
  try {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    final repository = LibraryRepository(db, RssFeedParser(dio));
    final results = await repository.refreshAllSubscriptions();

    if (store.newEpisodeNotifications && results.isNotEmpty) {
      final notifications = await NotificationService.create();
      await notifications.notifyNewEpisodes(results);
    }
    return true;
  } catch (error, stack) {
    // Sem isso, um lock de banco (app aberto ao mesmo tempo) ou qualquer
    // outra falha aqui não deixa rastro nenhum pra diagnosticar no device.
    await ErrorLog.instance.record(error, stack, context: 'feedSyncCallbackDispatcher');
    return false;
  } finally {
    await db.close();
  }
}
