import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/services/download/auto_download_service.dart';
import 'package:podcast_app/services/download/download_service.dart';

class _MockLibrary extends Mock implements LibraryRepository {}

class _MockDownloadService extends Mock implements DownloadService {}

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  setUpAll(() {
    registerFallbackValue(const Episode(guid: '', title: '', audioUrl: ''));
    registerFallbackValue(Duration.zero);
  });

  late _MockLibrary library;
  late _MockDownloadService downloads;
  late _MockConnectivity connectivity;
  late AutoDownloadService service;

  const p1 = Podcast(id: 1, title: 'P1', author: 'A', feedUrl: 'f1');
  Episode ep(String g) => Episode(guid: g, title: g, audioUrl: 'u-$g');

  SubscriptionSettings settings({
    AutoDownloadMode auto = AutoDownloadMode.never,
    int limit = 3,
    int deleteDays = 0,
  }) =>
      (
        autoDownload: auto,
        autoDownloadLimit: limit,
        autoDeletePlayedDays: deleteDays,
        playbackSpeedOverride: null,
      );

  setUp(() {
    library = _MockLibrary();
    downloads = _MockDownloadService();
    connectivity = _MockConnectivity();
    service = AutoDownloadService(library, downloads, connectivity);
    when(() => connectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(() => downloads.download(podcastId: any(named: 'podcastId'), episode: any(named: 'episode')))
        .thenAnswer((_) async {});
    when(() => downloads.remove(
        podcastId: any(named: 'podcastId'),
        episodeGuid: any(named: 'episodeGuid'))).thenAnswer((_) async {});
    when(() => library.recentUndownloadedEpisodes(any(), limit: any(named: 'limit')))
        .thenAnswer((_) async => []);
    when(() => library.playedDownloadsToPrune(any(), any())).thenAnswer((_) async => []);
  });

  test('no-op quando nenhuma assinatura tem gestão automática', () async {
    when(() => library.allSubscriptionsWithSettings())
        .thenAnswer((_) async => [(podcast: p1, settings: settings())]);

    await service.run();

    verifyNever(() => library.recentUndownloadedEpisodes(any(), limit: any(named: 'limit')));
    verifyNever(() => downloads.download(
        podcastId: any(named: 'podcastId'), episode: any(named: 'episode')));
  });

  test('autoDownload=always baixa os candidatos', () async {
    when(() => library.allSubscriptionsWithSettings()).thenAnswer(
        (_) async => [(podcast: p1, settings: settings(auto: AutoDownloadMode.always, limit: 2))]);
    when(() => library.recentUndownloadedEpisodes(1, limit: 2))
        .thenAnswer((_) async => [ep('a'), ep('b')]);

    await service.run();

    verify(() => downloads.download(podcastId: 1, episode: any(named: 'episode'))).called(2);
  });

  test('autoDownload=wifi não baixa em rede tarifada', () async {
    when(() => connectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.mobile]);
    when(() => library.allSubscriptionsWithSettings()).thenAnswer(
        (_) async => [(podcast: p1, settings: settings(auto: AutoDownloadMode.wifi))]);
    when(() => library.recentUndownloadedEpisodes(any(), limit: any(named: 'limit')))
        .thenAnswer((_) async => [ep('a')]);

    await service.run();

    verifyNever(() => downloads.download(
        podcastId: any(named: 'podcastId'), episode: any(named: 'episode')));
  });

  test('uma falha no download de um episódio não impede os demais nem a próxima assinatura', () async {
    const p2 = Podcast(id: 2, title: 'P2', author: 'A', feedUrl: 'f2');
    when(() => library.allSubscriptionsWithSettings()).thenAnswer(
      (_) async => [
        (podcast: p1, settings: settings(auto: AutoDownloadMode.always, limit: 2)),
        (podcast: p2, settings: settings(auto: AutoDownloadMode.always, limit: 1)),
      ],
    );
    when(() => library.recentUndownloadedEpisodes(1, limit: 2))
        .thenAnswer((_) async => [ep('a'), ep('b')]);
    when(() => library.recentUndownloadedEpisodes(2, limit: 1))
        .thenAnswer((_) async => [ep('c')]);
    when(() => downloads.download(podcastId: 1, episode: ep('a')))
        .thenThrow(Exception('enqueue travou'));

    await service.run();

    verify(() => downloads.download(podcastId: 1, episode: ep('b'))).called(1);
    verify(() => downloads.download(podcastId: 2, episode: ep('c'))).called(1);
  });

  test('autoDeletePlayedDays > 0 remove os ouvidos antigos', () async {
    when(() => library.allSubscriptionsWithSettings()).thenAnswer(
        (_) async => [(podcast: p1, settings: settings(deleteDays: 7))]);
    when(() => library.playedDownloadsToPrune(1, const Duration(days: 7)))
        .thenAnswer((_) async => ['velho1', 'velho2']);

    await service.run();

    verify(() => downloads.remove(podcastId: 1, episodeGuid: 'velho1')).called(1);
    verify(() => downloads.remove(podcastId: 1, episodeGuid: 'velho2')).called(1);
  });
}
