import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/library_repository.dart';
import 'package:podcast_app/data/sources/rss_feed_parser.dart';

class _MockFeedParser extends Mock implements RssFeedParser {}

void main() {
  late AppDatabase db;
  late _MockFeedParser feedParser;
  late LibraryRepository repo;

  const podcast = Podcast(id: 1, title: 'P', author: 'A', feedUrl: 'https://x/f.xml');

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    feedParser = _MockFeedParser();
    repo = LibraryRepository(db, feedParser);
  });

  tearDown(() => db.close());

  test('watchProgressForPodcast reage a savePlaybackPosition', () async {
    await repo.subscribe(podcast, [
      Episode(guid: 'g1', title: 'E1', audioUrl: 'u1'),
      Episode(guid: 'g2', title: 'E2', audioUrl: 'u2'),
    ]);

    expect(await repo.watchProgressForPodcast(1).first, isEmpty);

    await repo.savePlaybackPosition(
      podcastId: 1,
      episodeGuid: 'g1',
      position: const Duration(seconds: 90),
      completed: false,
    );
    await repo.savePlaybackPosition(
      podcastId: 1,
      episodeGuid: 'g2',
      position: const Duration(seconds: 100),
      completed: true,
    );

    final map = await repo.watchProgressForPodcast(1).first;
    expect(map['g1'], (positionSeconds: 90, completed: false));
    expect(map['g2'], (positionSeconds: 100, completed: true));
  });

  test('watchDownloadedEpisodes só devolve episódio com download completo', () async {
    await repo.subscribe(podcast, [
      Episode(guid: 'g1', title: 'Baixado', audioUrl: 'u1'),
      Episode(guid: 'g2', title: 'Baixando', audioUrl: 'u2'),
      Episode(guid: 'g3', title: 'Nada', audioUrl: 'u3'),
    ]);

    await db.into(db.downloads).insert(DownloadsCompanion.insert(
          podcastId: 1,
          episodeGuid: 'g1',
          status: const Value('complete'),
          localPath: const Value('/tmp/g1.mp3'),
        ));
    await db.into(db.downloads).insert(DownloadsCompanion.insert(
          podcastId: 1,
          episodeGuid: 'g2',
          status: const Value('running'),
        ));

    final eps = await repo.watchDownloadedEpisodes(1).first;
    expect(eps.map((e) => e.guid), ['g1']);
  });

  group('Fase 9 — feeds vivos', () {
    Episode ep(String guid) => Episode(guid: guid, title: guid, audioUrl: 'u-$guid');

    test('refreshFeed traz episódio novo e conta só os inéditos', () async {
      await repo.subscribe(podcast, [ep('g1')]);
      when(() => feedParser.fetchEpisodes('https://x/f.xml'))
          .thenAnswer((_) async => [ep('g1'), ep('g2')]);

      final novos = await repo.refreshFeed(1, force: true);

      expect(novos.map((e) => e.guid), ['g2']);
      expect((await repo.cachedEpisodes(1)).map((e) => e.guid).toSet(), {'g1', 'g2'});
    });

    test('refreshFeed repetido não duplica e conta 0', () async {
      await repo.subscribe(podcast, [ep('g1')]);
      when(() => feedParser.fetchEpisodes(any())).thenAnswer((_) async => [ep('g1')]);

      await repo.refreshFeed(1, force: true);
      final novos = await repo.refreshFeed(1, force: true);

      expect(novos, isEmpty);
      expect((await repo.cachedEpisodes(1)).length, 1);
    });

    test('sem force, pula feed rebuscado há menos de 1h', () async {
      await repo.subscribe(podcast, [ep('g1')]);
      when(() => feedParser.fetchEpisodes(any())).thenAnswer((_) async => [ep('g1'), ep('g2')]);

      await repo.refreshFeed(1, force: true); // marca lastRefreshedAt = agora
      final novos = await repo.refreshFeed(1); // sem force → throttle

      expect(novos, isEmpty);
      verify(() => feedParser.fetchEpisodes(any())).called(1); // não rebuscou de novo
    });

    test('refreshAllSubscriptions ignora feed que falha e segue nos outros', () async {
      await repo.subscribe(podcast, [ep('g1')]);
      await repo.subscribe(
        const Podcast(id: 2, title: 'P2', author: 'A', feedUrl: 'https://x/f2.xml'),
        [ep('h1')],
      );
      when(() => feedParser.fetchEpisodes('https://x/f.xml')).thenThrow(Exception('sem rede'));
      when(() => feedParser.fetchEpisodes('https://x/f2.xml'))
          .thenAnswer((_) async => [ep('h1'), ep('h2')]);

      final results = await repo.refreshAllSubscriptions(force: true);

      // só o podcast 2 teve episódio inédito (h2)
      expect(results.map((r) => r.podcast.id), [2]);
      expect(results.single.newEpisodes.map((e) => e.guid), ['h2']);
      expect((await repo.cachedEpisodes(2)).length, 2);
    });

    test('cacheEpisodesIfSubscribed não faz nada se não assinado', () async {
      await repo.cacheEpisodesIfSubscribed(99, [ep('g1')]);
      expect(await repo.cachedEpisodes(99), isEmpty);
    });
  });

  group('Fase 11 — tela Início', () {
    Episode ep(String guid, {DateTime? date, Duration? dur}) =>
        Episode(guid: guid, title: guid, audioUrl: 'u-$guid', publishedAt: date, duration: dur);

    const p2 = Podcast(id: 2, title: 'P2', author: 'B', feedUrl: 'https://x/f2.xml');

    test('watchContinueListening: só começados e não terminados, por updatedAt desc', () async {
      await repo.subscribe(podcast, [ep('g1'), ep('g2'), ep('g3')]);

      await repo.savePlaybackPosition(
        podcastId: 1,
        episodeGuid: 'g1',
        position: const Duration(seconds: 30),
        completed: false,
      );
      // `updatedAt` do drift é unix em segundos — precisa de > 1s de gap
      // pra ordenar de forma determinística.
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      await repo.savePlaybackPosition(
        podcastId: 1,
        episodeGuid: 'g2',
        position: const Duration(seconds: 60),
        completed: false,
      );
      // ouvido até o fim → fora
      await repo.savePlaybackPosition(
        podcastId: 1,
        episodeGuid: 'g3',
        position: const Duration(seconds: 999),
        completed: true,
      );

      final items = await repo.watchContinueListening().first;
      expect(items.map((i) => i.episode.guid), ['g2', 'g1']); // g2 salvo por último
      expect(items.first.positionSeconds, 60);
    });

    test('watchContinueListening ignora progresso com posição 0', () async {
      await repo.subscribe(podcast, [ep('g1')]);
      await repo.savePlaybackPosition(
        podcastId: 1,
        episodeGuid: 'g1',
        position: Duration.zero,
        completed: false,
      );
      expect(await repo.watchContinueListening().first, isEmpty);
    });

    test('watchRecentEpisodes: cross-assinatura, por publishedAt desc, sem data fora', () async {
      await repo.subscribe(podcast, [
        ep('a', date: DateTime(2026, 1, 1)),
        ep('b', date: DateTime(2026, 3, 1)),
        ep('semdata'),
      ]);
      await repo.subscribe(p2, [ep('c', date: DateTime(2026, 2, 1))]);

      final items = await repo.watchRecentEpisodes().first;
      expect(items.map((i) => i.episode.guid), ['b', 'c', 'a']);
      expect(items.map((i) => i.podcast.id), [1, 2, 1]);
    });
  });

  group('Fase 13 — gestão de episódios', () {
    Episode ep(String guid, {DateTime? added, DateTime? published}) => Episode(
          guid: guid,
          title: guid,
          audioUrl: 'u-$guid',
          publishedAt: published,
        );

    test('setEpisodeArchived tira o episódio de watchEpisodes / watchRecentEpisodes', () async {
      await repo.subscribe(podcast, [
        ep('a', published: DateTime(2026, 1, 1)),
        ep('b', published: DateTime(2026, 2, 1)),
      ]);

      await repo.setEpisodeArchived(1, 'b', true);

      expect((await repo.watchEpisodes(1).first).map((e) => e.guid), ['a']);
      expect((await repo.watchEpisodes(1, includeArchived: true).first).map((e) => e.guid).toSet(),
          {'a', 'b'});
      expect(await repo.watchArchivedGuids(1).first, {'b'});
      expect((await repo.watchRecentEpisodes().first).map((e) => e.episode.guid), ['a']);

      await repo.setEpisodeArchived(1, 'b', false);
      expect(await repo.watchArchivedGuids(1).first, isEmpty);
    });

    test('setEpisodeCompleted marca / desmarca ouvido', () async {
      await repo.subscribe(podcast, [ep('a')]);

      await repo.setEpisodeCompleted(1, 'a', true);
      expect((await repo.watchProgressForPodcast(1).first)['a']?.completed, isTrue);

      await repo.setEpisodeCompleted(1, 'a', false);
      final p = (await repo.watchProgressForPodcast(1).first)['a'];
      expect(p?.completed, isFalse);
      expect(p?.positionSeconds, 0);
    });

    test('updateAutoManagement + watchSubscriptionSettings', () async {
      await repo.subscribe(podcast, [ep('a')]);
      expect((await repo.watchSubscriptionSettings(1).first).autoDownload, AutoDownloadMode.never);

      await repo.updateAutoManagement(1,
          autoDownload: AutoDownloadMode.wifi, autoDownloadLimit: 5, autoDeletePlayedDays: 14);
      await repo.setPlaybackSpeedOverride(1, 1.5);

      final s = await repo.watchSubscriptionSettings(1).first;
      expect(s.autoDownload, AutoDownloadMode.wifi);
      expect(s.autoDownloadLimit, 5);
      expect(s.autoDeletePlayedDays, 14);
      expect(s.playbackSpeedOverride, 1.5);

      await repo.setPlaybackSpeedOverride(1, null);
      expect((await repo.watchSubscriptionSettings(1).first).playbackSpeedOverride, null);
    });

    test('recentUndownloadedEpisodes: recentes, não baixados, respeita limite', () async {
      await repo.subscribe(podcast, [ep('a'), ep('b'), ep('c')]);
      // `subscribe` grava addedAt = agora nos três.
      await db.into(db.downloads).insert(DownloadsCompanion.insert(
            podcastId: 1,
            episodeGuid: 'a',
            status: const Value('complete'),
          ));

      final out = await repo.recentUndownloadedEpisodes(1, limit: 5);
      expect(out.map((e) => e.guid).toSet(), {'b', 'c'});

      expect(await repo.recentUndownloadedEpisodes(1, limit: 1), hasLength(1));
      expect(await repo.recentUndownloadedEpisodes(1, limit: 0), isEmpty);
    });

    test('playedDownloadsToPrune: só download completo + ouvido + antigo', () async {
      await repo.subscribe(podcast, [ep('velho'), ep('novo'), ep('naoouvido')]);
      for (final g in ['velho', 'novo', 'naoouvido']) {
        await db.into(db.downloads).insert(DownloadsCompanion.insert(
              podcastId: 1,
              episodeGuid: g,
              status: const Value('complete'),
            ));
      }
      // 'velho' ouvido há 40 dias, 'novo' ouvido agora, 'naoouvido' sem progresso.
      await db.into(db.playbackProgress).insert(PlaybackProgressCompanion.insert(
            podcastId: 1,
            episodeGuid: 'velho',
            completed: const Value(true),
            updatedAt: Value(DateTime.now().subtract(const Duration(days: 40))),
          ));
      await repo.setEpisodeCompleted(1, 'novo', true);

      final prune = await repo.playedDownloadsToPrune(1, const Duration(days: 14));
      expect(prune, ['velho']);
    });
  });

  group('Fase 14 — metadados avançados', () {
    test('round-trip dos campos novos pelo cache', () async {
      await repo.subscribe(podcast, [
        const Episode(
          guid: 'g1',
          title: 'E1',
          audioUrl: 'u1',
          seasonNumber: 2,
          episodeNumber: 7,
          episodeType: 'bonus',
          link: 'https://x/eps/1',
          chaptersUrl: 'https://x/eps/1/chapters.json',
        ),
      ]);

      final cached = (await repo.cachedEpisodes(1)).single;
      expect(cached.seasonNumber, 2);
      expect(cached.episodeNumber, 7);
      expect(cached.episodeType, 'bonus');
      expect(cached.link, 'https://x/eps/1');
      expect(cached.chaptersUrl, 'https://x/eps/1/chapters.json');
    });

    test('refresh atualiza os campos novos de episódio já cacheado', () async {
      // Cacheado antes do feed declarar temporada/capítulos.
      await repo.subscribe(podcast, [
        const Episode(guid: 'g1', title: 'E1', audioUrl: 'u1'),
      ]);
      when(() => feedParser.fetchEpisodes(any())).thenAnswer((_) async => [
            const Episode(
              guid: 'g1',
              title: 'E1',
              audioUrl: 'u1',
              seasonNumber: 4,
              chaptersUrl: 'https://x/eps/1/chapters.json',
            ),
          ]);

      final novos = await repo.refreshFeed(1, force: true);

      expect(novos, isEmpty); // não é episódio inédito, só metadado novo
      final cached = (await repo.cachedEpisodes(1)).single;
      expect(cached.seasonNumber, 4);
      expect(cached.chaptersUrl, 'https://x/eps/1/chapters.json');
    });
  });
}
