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
import 'services/audio/media_browser_controller.dart';
import 'services/audio/podcast_audio_handler.dart';
import 'services/download/download_service.dart';
import 'services/notifications/notification_service.dart';
import 'services/shortcuts/app_shortcuts.dart';
import 'services/sync/background_sync.dart';
import 'services/sync/feed_sync_scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Precisa existir antes do primeiro `runApp` — é o que registra o serviço
  // de áudio em background com o sistema (notificação/lockscreen) e a árvore
  // de mídia do Android Auto.
  final handler = await AudioService.init(
    builder: PodcastAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.luismatos.podcast_app.playback',
      androidNotificationChannelName: 'Reprodução',
      // Fase 16: Android Auto mostra "Assinaturas"/"Baixados" como grade e os
      // episódios como lista.
      androidBrowsableRootExtras: {
        'android.media.browse.CONTENT_STYLE_SUPPORTED': true,
        'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2,
        'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1,
      },
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

  // App shortcuts (Fase 16): `register()` antes do runApp pra não perder o
  // atalho de cold start. O `_pending` guarda até o AppShell escutar.
  final shortcuts = AppShortcuts()..register();

  // Um único container/scope pro app inteiro (não é "double scope"): permite
  // ligar a árvore de mídia do Android Auto ao handler ANTES do runApp — o
  // Auto pode pedir `getChildren` com o app em processo frio, antes de
  // qualquer widget montar.
  final container = ProviderContainer(
    overrides: [
      audioHandlerProvider.overrideWithValue(handler),
      preferencesStoreProvider.overrideWithValue(store),
      notificationServiceProvider.overrideWithValue(notifications),
      appShortcutsProvider.overrideWithValue(shortcuts),
    ],
  );
  container.read(mediaBrowserWiringProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PodcastApp(),
    ),
  );
}
