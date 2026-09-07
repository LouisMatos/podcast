import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/features/settings/view_model/feed_refresh_settings_provider.dart';
import 'package:podcast_app/services/notifications/notification_service.dart';
import 'package:podcast_app/services/sync/feed_sync_scheduler.dart';

import '../../support/fake_preferences.dart';

class _MockScheduler extends Mock implements FeedSyncScheduler {}

class _MockNotifications extends Mock implements NotificationService {}

void main() {
  late PreferencesStore prefs;
  late _MockScheduler scheduler;
  late _MockNotifications notifications;

  Future<ProviderContainer> makeContainer([Map<String, Object> initial = const {}]) async {
    prefs = await fakePreferencesStore(initial);
    scheduler = _MockScheduler();
    notifications = _MockNotifications();
    when(() => scheduler.apply(enabled: any(named: 'enabled'), wifiOnly: any(named: 'wifiOnly')))
        .thenAnswer((_) async {});

    final c = ProviderContainer(overrides: [
      preferencesStoreProvider.overrideWithValue(prefs),
      feedSyncSchedulerProvider.overrideWithValue(scheduler),
      notificationServiceProvider.overrideWithValue(notifications),
    ]);
    addTearDown(c.dispose);
    return c;
  }

  test('estado inicial: background ligado, notificação/wifi desligados', () async {
    final c = await makeContainer();
    final s = c.read(feedRefreshSettingsProvider);
    expect(s.backgroundRefresh, isTrue);
    expect(s.notifications, isFalse);
    expect(s.wifiOnly, isFalse);
  });

  test('lê preferência já persistida', () async {
    final c = await makeContainer({
      'pref.background_refresh_enabled': false,
      'pref.refresh_wifi_only': true,
    });
    final s = c.read(feedRefreshSettingsProvider);
    expect(s.backgroundRefresh, isFalse);
    expect(s.wifiOnly, isTrue);
  });

  test('desligar background persiste e cancela a task (apply enabled:false)', () async {
    final c = await makeContainer();
    await c.read(feedRefreshSettingsProvider.notifier).setBackgroundRefresh(false);

    expect(prefs.backgroundRefreshEnabled, isFalse);
    verify(() => scheduler.apply(enabled: false, wifiOnly: false)).called(1);
  });

  test('ligar wifiOnly reagenda com wifiOnly:true', () async {
    final c = await makeContainer();
    await c.read(feedRefreshSettingsProvider.notifier).setWifiOnly(true);

    expect(prefs.refreshWifiOnly, isTrue);
    verify(() => scheduler.apply(enabled: true, wifiOnly: true)).called(1);
  });

  test('notificação: permissão concedida → liga e persiste', () async {
    final c = await makeContainer();
    when(() => notifications.requestPermission()).thenAnswer((_) async => true);

    await c.read(feedRefreshSettingsProvider.notifier).setNotifications(true);

    expect(prefs.newEpisodeNotifications, isTrue);
    expect(c.read(feedRefreshSettingsProvider).notifications, isTrue);
  });

  test('notificação: permissão negada → fica desligada, não persiste', () async {
    final c = await makeContainer();
    when(() => notifications.requestPermission()).thenAnswer((_) async => false);

    await c.read(feedRefreshSettingsProvider.notifier).setNotifications(true);

    expect(prefs.newEpisodeNotifications, isFalse);
    expect(c.read(feedRefreshSettingsProvider).notifications, isFalse);
  });
}
