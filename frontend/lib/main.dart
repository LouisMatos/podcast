import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/prefs/preferences_store.dart';
import 'services/audio/podcast_audio_handler.dart';
import 'services/download/download_service.dart';

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

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(handler),
        preferencesStoreProvider.overrideWithValue(PreferencesStore(prefs)),
      ],
      child: const PodcastApp(),
    ),
  );
}
