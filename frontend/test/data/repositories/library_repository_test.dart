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

  test('watchDownloadedEpisodes não mistura downloads de outro podcast', () async {
    const podcastB = Podcast(id: 2, title: 'P2', author: 'A2', feedUrl: 'https://x/f2.xml');

    await repo.subscribe(podcast, [Episode(guid: 'g1', title: 'A1', audioUrl: 'u1')]);
    await repo.subscribe(podcastB, [Episode(guid: 'g1', title: 'B1', audioUrl: 'u1')]);

    await db.into(db.downloads).insert(DownloadsCompanion.insert(
          podcastId: 1,
          episodeGuid: 'g1',
          status: const Value('complete'),
          localPath: const Value('/tmp/a-g1.mp3'),
        ));
    await db.into(db.downloads).insert(DownloadsCompanion.insert(
          podcastId: 2,
          episodeGuid: 'g1',
          status: const Value('complete'),
          localPath: const Value('/tmp/b-g1.mp3'),
        ));

    final epsA = await repo.watchDownloadedEpisodes(1).first;
    expect(epsA.map((e) => e.title), ['A1']);

    final epsB = await repo.watchDownloadedEpisodes(2).first;
    expect(epsB.map((e) => e.title), ['B1']);
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

    test(
      'refreshAllSubscriptions em lotes: mais assinaturas que concurrency, '
      'uma falha no meio do lote não derruba as outras',
      () async {
        // 6 assinaturas, concurrency=2 → 3 lotes; a 3ª (índice 2, no meio do
        // 2º lote) falha. Todas as outras devem completar independente da
        // posição/ordem de conclusão dentro do lote.
        for (var i = 1; i <= 6; i++) {
          await repo.subscribe(
            Podcast(id: i, title: 'P$i', author: 'A', feedUrl: 'https://x/f$i.xml'),
            [ep('g$i-0')],
          );
        }
        for (var i = 1; i <= 6; i++) {
          if (i == 3) {
            when(() => feedParser.fetchEpisodes('https://x/f$i.xml')).thenThrow(Exception('sem rede'));
          } else {
            when(() => feedParser.fetchEpisodes('https://x/f$i.xml'))
                .thenAnswer((_) async => [ep('g$i-0'), ep('g$i-1')]);
          }
        }

        final results = await repo.refreshAllSubscriptions(force: true, concurrency: 2);

        expect(results.map((r) => r.podcast.id).toSet(), {1, 2, 4, 5, 6});
        expect((await repo.cachedEpisodes(3)).length, 1); // feed 3 não avançou
        for (final id in [1, 2, 4, 5, 6]) {
          expect((await repo.cachedEpisodes(id)).length, 2);
        }
      },
    );

    test('throttle 1h respeitado mesmo com refresh em paralelo (concurrency > 1)', () async {
      await repo.subscribe(podcast, [ep('g1')]);
      await repo.subscribe(
        const Podcast(id: 2, title: 'P2', author: 'A', feedUrl: 'https://x/f2.xml'),
        [ep('h1')],
      );
      when(() => feedParser.fetchEpisodes(any())).thenAnswer((_) async => [ep('g1'), ep('h1')]);

      await repo.refreshAllSubscriptions(force: true, concurrency: 2);
      final segunda = await repo.refreshAllSubscriptions(concurrency: 2); // sem force

      expect(segunda, isEmpty);
      verify(() => feedParser.fetchEpisodes(any())).called(2); // só a 1ª rodada
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

  group('Fase 17 — estatísticas de escuta', () {
    Episode ep(String guid, {String? title, DateTime? published}) => Episode(
          guid: guid,
          title: title ?? guid,
          audioUrl: 'u-$guid',
          publishedAt: published,
        );

    DateTime midnight(DateTime d) => DateTime(d.year, d.month, d.day);

    test('recordListening soma no mesmo dia e ignora delta <= 0', () async {
      await repo.subscribe(podcast, [ep('g1')]);

      await repo.recordListening(
          podcastId: 1, episodeGuid: 'g1', delta: const Duration(seconds: 30));
      await repo.recordListening(
          podcastId: 1, episodeGuid: 'g1', delta: const Duration(seconds: 45));
      await repo.recordListening(
          podcastId: 1, episodeGuid: 'g1', delta: Duration.zero);
      await repo.recordListening(
          podcastId: 1, episodeGuid: 'g1', delta: const Duration(seconds: -10));

      final rows = await db.select(db.listenHistory).get();
      expect(rows, hasLength(1));
      expect(rows.single.secondsListened, 75);
      expect(rows.single.day, midnight(DateTime.now()));
    });

    test('watchListeningStats: total, streak de 2 dias e last7Days com zeros', () async {
      await repo.subscribe(podcast, [ep('g1')]);
      final today = midnight(DateTime.now());
      final yesterday = DateTime(today.year, today.month, today.day - 1);

      // Escreve `day` explícito — dois dias consecutivos terminando hoje.
      await db.into(db.listenHistory).insert(ListenHistoryCompanion.insert(
            podcastId: 1,
            episodeGuid: 'g1',
            day: yesterday,
            secondsListened: const Value(50),
          ));
      await db.into(db.listenHistory).insert(ListenHistoryCompanion.insert(
            podcastId: 1,
            episodeGuid: 'g1',
            day: today,
            secondsListened: const Value(100),
          ));

      final stats = await repo.watchListeningStats().first;
      expect(stats.total, const Duration(seconds: 150));
      expect(stats.streakDays, 2);
      expect(stats.last7Days, hasLength(7));
      expect(stats.last7Days.last.day, today);
      expect(stats.last7Days.last.listened, const Duration(seconds: 100));
      expect(stats.last7Days[5].listened, const Duration(seconds: 50));
      // Os 5 dias mais antigos da janela não têm registro.
      expect(
        stats.last7Days.take(5).every((d) => d.listened == Duration.zero),
        isTrue,
      );
    });

    test('watchListenHistory agrega por episódio, dia mais recente desc', () async {
      await repo.subscribe(podcast, [ep('g1', title: 'Ep 1'), ep('g2', title: 'Ep 2')]);
      final today = midnight(DateTime.now());
      final twoDaysAgo = DateTime(today.year, today.month, today.day - 2);

      await db.into(db.listenHistory).insert(ListenHistoryCompanion.insert(
            podcastId: 1, episodeGuid: 'g1', day: twoDaysAgo,
            secondsListened: const Value(10)));
      await db.into(db.listenHistory).insert(ListenHistoryCompanion.insert(
            podcastId: 1, episodeGuid: 'g1', day: today,
            secondsListened: const Value(20)));
      await db.into(db.listenHistory).insert(ListenHistoryCompanion.insert(
            podcastId: 1, episodeGuid: 'g2', day: twoDaysAgo,
            secondsListened: const Value(5)));

      final hist = await repo.watchListenHistory().first;
      expect(hist.map((i) => i.episode.guid), ['g1', 'g2']);
      expect(hist.first.listened, const Duration(seconds: 30));
      expect(hist.first.lastPlayedDay, today);
    });

    test('searchLibraryEpisodes casa por título, case-insensitive, sem arquivado', () async {
      await repo.subscribe(podcast, [
        ep('g1', title: 'Flutter na prática', published: DateTime(2026, 3, 1)),
        ep('g2', title: 'Dart avançado', published: DateTime(2026, 2, 1)),
        ep('g3', title: 'Outro sobre FLUTTER', published: DateTime(2026, 1, 1)),
      ]);
      await repo.setEpisodeArchived(1, 'g3', true);

      final hits = await repo.searchLibraryEpisodes('flutter');
      expect(hits.map((h) => h.episode.guid), ['g1']);

      expect(await repo.searchLibraryEpisodes('   '), isEmpty);
      expect((await repo.searchLibraryEpisodes('dart')).single.episode.guid, 'g2');
    });

    test('watchSubscriptionsWithMeta conta não-ouvidos e pega lastPublishedAt', () async {
      // segundos inteiros — o drift guarda published_at como unix em segundos.
      final nowSec = DateTime.fromMillisecondsSinceEpoch(
        (DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000,
      );
      final recent1 = nowSec.subtract(const Duration(days: 1));
      final recent2 = nowSec.subtract(const Duration(days: 3));
      final recent3 = nowSec.subtract(const Duration(days: 5));
      await repo.subscribe(podcast, [
        ep('g1', published: recent1),
        ep('g2', published: recent2),
        ep('g3', published: recent3),
      ]);
      // g1 ouvido até o fim → não conta; g3 arquivado → não conta; sobra g2.
      await repo.setEpisodeCompleted(1, 'g1', true);
      await repo.setEpisodeArchived(1, 'g3', true);

      final metas = await repo.watchSubscriptionsWithMeta().first;
      expect(metas, hasLength(1));
      expect(metas.single.podcast.id, 1);
      expect(metas.single.unplayedCount, 1);
      expect(metas.single.lastPublishedAt, recent1);
    });

    test('badge de não-ouvidos ignora episódio fora da janela (Fase 23 v3)', () async {
      final now = DateTime.now();
      await repo.subscribe(podcast, [
        ep('novo', published: now.subtract(const Duration(days: 2))),
        ep('velho', published: now.subtract(LibraryRepository.unplayedWindow * 2)),
      ]);

      final metas = await repo.watchSubscriptionsWithMeta().first;
      expect(metas.single.unplayedCount, 1); // só 'novo'
    });

    test('updateEpisodeDuration sobrescreve a duração cacheada (Fase 21 v3)', () async {
      await repo.subscribe(podcast, [
        Episode(guid: 'g1', title: 'E1', audioUrl: 'u1', duration: const Duration(minutes: 6)),
      ]);

      await repo.updateEpisodeDuration(1, 'g1', const Duration(seconds: 431));
      expect((await repo.cachedEpisodes(1)).single.duration, const Duration(seconds: 431));

      // valor não-positivo é no-op
      await repo.updateEpisodeDuration(1, 'g1', Duration.zero);
      expect((await repo.cachedEpisodes(1)).single.duration, const Duration(seconds: 431));

      // episódio fora do cache é no-op (não lança)
      await repo.updateEpisodeDuration(1, 'inexistente', const Duration(seconds: 10));
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

  // Reforço: o refresh do feed é a porta de entrada dos episódios novos —
  // aqui o foco é a integração entre `refreshFeed`/`refreshAllSubscriptions`
  // e as 3 queries da tela Início (`watchEpisodes`, `watchRecentEpisodes`,
  // `watchContinueListening`), não o refresh isolado (Fases 9/10).
  group('Fase 18 — integração refresh', () {
    Episode ep(String guid, {DateTime? pub}) =>
        Episode(guid: guid, title: guid, audioUrl: 'u-$guid', publishedAt: pub);

    const p2 = Podcast(id: 2, title: 'P2', author: 'B', feedUrl: 'https://x/f2.xml');

    test('episódio novo do feed propaga pras 3 queries de Início', () async {
      await repo.subscribe(podcast, [ep('g1', pub: DateTime(2026, 1, 1))]);
      when(() => feedParser.fetchEpisodes('https://x/f.xml')).thenAnswer((_) async => [
            ep('g1', pub: DateTime(2026, 1, 1)),
            ep('g2', pub: DateTime(2026, 6, 1)),
          ]);

      final novos = await repo.refreshFeed(1, force: true);
      expect(novos.map((e) => e.guid), ['g2']);

      // watchEpisodes: cache antigo + inédito, por publishedAt desc.
      expect((await repo.watchEpisodes(1).first).map((e) => e.guid), ['g2', 'g1']);

      // watchRecentEpisodes: o inédito lidera (data mais nova).
      expect(
        (await repo.watchRecentEpisodes().first).map((i) => i.episode.guid),
        ['g2', 'g1'],
      );

      // Começar o inédito → aparece em "continuar ouvindo".
      await repo.savePlaybackPosition(
        podcastId: 1,
        episodeGuid: 'g2',
        position: const Duration(seconds: 30),
        completed: false,
      );
      expect(
        (await repo.watchContinueListening().first).map((i) => i.episode.guid),
        ['g2'],
      );
    });

    test('refreshAllSubscriptions parcial: só o feed vivo entra nas queries', () async {
      await repo.subscribe(podcast, [ep('g1', pub: DateTime(2026, 1, 1))]);
      await repo.subscribe(p2, [ep('h1', pub: DateTime(2026, 1, 2))]);
      when(() => feedParser.fetchEpisodes('https://x/f.xml')).thenThrow(Exception('sem rede'));
      when(() => feedParser.fetchEpisodes('https://x/f2.xml')).thenAnswer((_) async => [
            ep('h1', pub: DateTime(2026, 1, 2)),
            ep('h2', pub: DateTime(2026, 7, 1)),
          ]);

      final results = await repo.refreshAllSubscriptions(force: true);
      expect(results.map((r) => r.podcast.id), [2]);

      // h2 (inédito, feed vivo) na frente; g1 do feed que falhou segue no cache.
      expect(
        (await repo.watchRecentEpisodes().first).map((i) => i.episode.guid),
        ['h2', 'h1', 'g1'],
      );
      expect((await repo.cachedEpisodes(1)).map((e) => e.guid), ['g1']);
    });

    test('throttle de 1h: 2º refresh sem force não rebusca nem muda watchEpisodes', () async {
      await repo.subscribe(podcast, [ep('g1', pub: DateTime(2026, 1, 1))]);
      when(() => feedParser.fetchEpisodes(any())).thenAnswer((_) async => [
            ep('g1', pub: DateTime(2026, 1, 1)),
            ep('g2', pub: DateTime(2026, 2, 1)),
          ]);
      await repo.refreshFeed(1, force: true); // marca lastRefreshedAt = agora

      // O feed passou a ter g3, mas o throttle barra a segunda busca.
      when(() => feedParser.fetchEpisodes(any()))
          .thenAnswer((_) async => [ep('g3', pub: DateTime(2026, 3, 1))]);
      final novos = await repo.refreshFeed(1);

      expect(novos, isEmpty);
      expect((await repo.watchEpisodes(1).first).map((e) => e.guid), ['g2', 'g1']);
    });
  });
}
