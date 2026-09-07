import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/prefs/preferences_store.dart';
import 'core/router/app_router.dart';
import 'services/audio/podcast_audio_handler.dart';
import 'services/download/download_service.dart';
import 'services/notifications/notification_service.dart';
import 'services/sync/background_sync.dart';
import 'services/sync/feed_sync_scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Precisa existir antes do primeiro `runApp` — é o que registra o serviço
  // de áudio em background com o sistema (notificação/lockscreen).
  final handler = await AudioService.init(
    builder: PodcastAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.luismatos.podcast_app.playback',
      androidNotificationChannelName: 'Reprodução',
    ),
  );

  // Também precisa vir antes do runApp — `registerCallback` liga o
  // isolate de background do flutter_downloader ao `downloadCallback`
  // top-level (ver services/download/download_service.dart).
  await FlutterDownloader.initialize();
  await FlutterDownloader.registerCallback(downloadCallback, step: 1);

  // Fase 10: refresh dos feeds em background. `initialize` liga o isolate
  // do WorkManager ao `feedSyncCallbackDispatcher` top-level.
  await Workmanager().initialize(feedSyncCallbackDispatcher);

  final prefs = await SharedPreferences.getInstance();
  final store = PreferencesStore(prefs);

  // Notificações locais — tocar abre o app na aba Início (os novos episódios
  // já estão lá).
  final notifications = await NotificationService.create(
    onTap: (_) => rootNavigatorKey.currentContext?.go('/home'),
  );

  // (Re)agenda a task periódica conforme a preferência atual.
  await const FeedSyncScheduler().apply(
    enabled: store.backgroundRefreshEnabled,
    wifiOnly: store.refreshWifiOnly,
  );

  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(handler),
        preferencesStoreProvider.overrideWithValue(store),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const PodcastApp(),
    ),
  );
}
