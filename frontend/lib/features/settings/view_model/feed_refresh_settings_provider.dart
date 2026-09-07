import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/prefs/preferences_store.dart';
import '../../../services/notifications/notification_service.dart';
import '../../../services/sync/feed_sync_scheduler.dart';

part 'feed_refresh_settings_provider.freezed.dart';

/// Ajustes de "Atualização" (Fase 10). Persistido no [PreferencesStore];
/// cada mudança reagenda (ou cancela) a task do WorkManager.
@freezed
abstract class FeedRefreshSettings with _$FeedRefreshSettings {
  const factory FeedRefreshSettings({
    required bool backgroundRefresh,
    required bool notifications,
    required bool wifiOnly,
  }) = _FeedRefreshSettings;
}

class FeedRefreshSettingsNotifier extends Notifier<FeedRefreshSettings> {
  @override
  FeedRefreshSettings build() {
    final store = ref.read(preferencesStoreProvider);
    return FeedRefreshSettings(
      backgroundRefresh: store.backgroundRefreshEnabled,
      notifications: store.newEpisodeNotifications,
      wifiOnly: store.refreshWifiOnly,
    );
  }

  Future<void> setBackgroundRefresh(bool value) async {
    await ref.read(preferencesStoreProvider).setBackgroundRefreshEnabled(value);
    state = state.copyWith(backgroundRefresh: value);
    await _reschedule();
  }

  Future<void> setWifiOnly(bool value) async {
    await ref.read(preferencesStoreProvider).setRefreshWifiOnly(value);
    state = state.copyWith(wifiOnly: value);
    await _reschedule();
  }

  /// Ligar exige a permissão `POST_NOTIFICATIONS` — se negada, o toggle
  /// volta pra desligado.
  Future<void> setNotifications(bool value) async {
    if (value) {
      final granted =
          await ref.read(notificationServiceProvider).requestPermission();
      if (!granted) {
        state = state.copyWith(notifications: false);
        return;
      }
    }
    await ref.read(preferencesStoreProvider).setNewEpisodeNotifications(value);
    state = state.copyWith(notifications: value);
  }

  Future<void> _reschedule() => ref.read(feedSyncSchedulerProvider).apply(
        enabled: state.backgroundRefresh,
        wifiOnly: state.wifiOnly,
      );
}

final feedRefreshSettingsProvider =
    NotifierProvider<FeedRefreshSettingsNotifier, FeedRefreshSettings>(
  FeedRefreshSettingsNotifier.new,
);
