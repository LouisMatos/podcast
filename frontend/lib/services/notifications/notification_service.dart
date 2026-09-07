import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/library_repository.dart';

part 'notification_service.g.dart';

/// Notificações locais de "episódio novo" (Fase 10). Único ponto do app que
/// fala com `flutter_local_notifications` — chamado tanto da UI (Ajustes,
/// pra pedir permissão) quanto do isolate de background (`background_sync`).
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'com.luismatos.podcast_app.new_episodes';
  static const _channelName = 'Novos episódios';
  static const _channelDescription =
      'Avisa quando sai episódio novo de um podcast assinado';

  /// Inicializa o plugin. [onTap] recebe o payload (`podcast:<id>`) quando o
  /// usuário toca na notificação.
  static Future<NotificationService> create({
    DidReceiveNotificationResponseCallback? onTap,
  }) async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: onTap,
    );
    return NotificationService(plugin);
  }

  /// Pede a permissão de notificação (Android 13+). Devolve `true` se
  /// concedida (ou se a versão do Android nem exige).
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;
    return await android.requestNotificationsPermission() ?? false;
  }

  /// Uma notificação por podcast com episódio inédito + um resumo do grupo.
  /// O id da notificação é o `podcast.id` — reabrir com dado novo substitui
  /// a anterior em vez de empilhar.
  Future<void> notifyNewEpisodes(List<FeedRefreshResult> results) async {
    if (results.isEmpty) return;

    for (final result in results) {
      final count = result.newEpisodes.length;
      await _plugin.show(
        id: result.podcast.id,
        title: result.podcast.title,
        body: count == 1
            ? result.newEpisodes.first.title
            : '$count episódios novos',
        notificationDetails: _details(),
        payload: 'podcast:${result.podcast.id}',
      );
    }

    if (results.length > 1) {
      final total = results.fold<int>(0, (sum, r) => sum + r.newEpisodes.length);
      await _plugin.show(
        id: 0,
        title: 'Novos episódios',
        body: '$total episódios de ${results.length} podcasts',
        notificationDetails: _details(groupSummary: true),
      );
    }
  }

  NotificationDetails _details({bool groupSummary = false}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        groupKey: _channelId,
        setAsGroupSummary: groupSummary,
      ),
    );
  }
}

/// Sobrescrito em `main.dart` com a instância inicializada (mesmo padrão de
/// `audioHandlerProvider`).
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  throw UnimplementedError('notificationServiceProvider precisa de overrideWithValue em main.dart');
}
