import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'services/audio/podcast_audio_handler.dart';

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

  runApp(
    ProviderScope(
      overrides: [audioHandlerProvider.overrideWithValue(handler)],
      child: const PodcastApp(),
    ),
  );
}
