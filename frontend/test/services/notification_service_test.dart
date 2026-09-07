import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/services/notifications/notification_service.dart';

class _MockPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

void main() {
  setUpAll(() => registerFallbackValue(const NotificationDetails()));

  late _MockPlugin plugin;
  late NotificationService service;

  Episode ep(String t) => Episode(guid: t, title: t, audioUrl: 'u-$t');
  Podcast pod(int id, String title) =>
      Podcast(id: id, title: title, author: 'A', feedUrl: 'f-$id');

  setUp(() {
    plugin = _MockPlugin();
    service = NotificationService(plugin);
    when(
      () => plugin.show(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
  });

  test('1 podcast / 1 episódio: título = podcast, corpo = episódio, sem resumo', () async {
    await service.notifyNewEpisodes([
      (podcast: pod(7, 'NerdCast'), newEpisodes: [ep('Ep 42')]),
    ]);

    verify(
      () => plugin.show(
        id: 7,
        title: 'NerdCast',
        body: 'Ep 42',
        notificationDetails: any(named: 'notificationDetails'),
        payload: 'podcast:7',
      ),
    ).called(1);
    verifyNever(() => plugin.show(id: 0, title: any(named: 'title'), body: any(named: 'body'), notificationDetails: any(named: 'notificationDetails')));
  });

  test('vários episódios de um podcast: corpo é a contagem', () async {
    await service.notifyNewEpisodes([
      (podcast: pod(7, 'NerdCast'), newEpisodes: [ep('a'), ep('b'), ep('c')]),
    ]);

    verify(
      () => plugin.show(
        id: 7,
        title: 'NerdCast',
        body: '3 episódios novos',
        notificationDetails: any(named: 'notificationDetails'),
        payload: 'podcast:7',
      ),
    ).called(1);
  });

  test('2+ podcasts: 1 notificação por podcast + resumo do grupo (id 0)', () async {
    await service.notifyNewEpisodes([
      (podcast: pod(1, 'P1'), newEpisodes: [ep('a')]),
      (podcast: pod(2, 'P2'), newEpisodes: [ep('b'), ep('c')]),
    ]);

    verify(() => plugin.show(id: 1, title: 'P1', body: any(named: 'body'), notificationDetails: any(named: 'notificationDetails'), payload: 'podcast:1')).called(1);
    verify(() => plugin.show(id: 2, title: 'P2', body: any(named: 'body'), notificationDetails: any(named: 'notificationDetails'), payload: 'podcast:2')).called(1);
    verify(() => plugin.show(id: 0, title: 'Novos episódios', body: '3 episódios de 2 podcasts', notificationDetails: any(named: 'notificationDetails'))).called(1);
  });

  test('lista vazia não dispara nada', () async {
    await service.notifyNewEpisodes(const <FeedRefreshResult>[]);
    verifyNever(() => plugin.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          notificationDetails: any(named: 'notificationDetails'),
          payload: any(named: 'payload'),
        ));
  });
}
