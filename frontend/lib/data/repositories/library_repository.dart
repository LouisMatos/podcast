import 'package:drift/drift.dart'
    show
        ArithmeticExpr,
        BooleanExpressionOperators,
        ComparableExpr,
        Constant,
        DoUpdate,
        InsertMode,
        OrderingTerm,
        StringExpressionOperators,
        Value,
        Variable,
        innerJoin;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/network/dio_client.dart';
import '../models/download_status.dart';
import '../models/episode.dart';
import '../models/listening_stats.dart';
import '../models/podcast.dart';
import '../models/subscription_settings.dart';
import '../sources/rss_feed_parser.dart';

export '../models/listening_stats.dart';
export '../models/subscription_settings.dart';

part 'library_repository.g.dart';

/// Progresso de escuta de um episódio, do jeito que a lista de episódios
/// precisa: posição atual e se já foi ouvido até o fim.
typedef EpisodeProgress = ({int positionSeconds, bool completed});

/// Um item "continuar ouvindo" da tela Início — episódio + podcast + onde
/// parou. Cross-assinatura.
typedef ContinueListeningItem = ({Podcast podcast, Episode episode, int positionSeconds});

/// Um episódio recente de qualquer assinatura, pra seção "Novos episódios".
typedef RecentEpisodeItem = ({Podcast podcast, Episode episode});

/// Uma linha do histórico de escuta (Fase 17): episódio + podcast + o dia
/// mais recente em que foi ouvido + o total ouvido (somado por episódio).
typedef ListenHistoryItem = ({
  Podcast podcast,
  Episode episode,
  DateTime lastPlayedDay,
  Duration listened,
});

/// Uma assinatura da biblioteca com os metadados que a lista precisa
/// (Fase 17): quantos episódios não-ouvidos e a data do episódio mais
/// recente.
typedef LibrarySubscription = ({
  Podcast podcast,
  int unplayedCount,
  DateTime? lastPublishedAt,
});

/// Resultado do refresh de um feed: o podcast e os episódios inéditos que
/// entraram no cache agora (pra notificação da Fase 10).
typedef FeedRefreshResult = ({Podcast podcast, List<Episode> newEpisodes});

/// Biblioteca do usuário: assinaturas e o cache local de episódios, tudo em
/// SQLite via drift. Um ViewModel nunca fala com `AppDatabase` direto — só
/// com este repositório, que devolve/recebe os modelos de domínio
/// (`Podcast`, `Episode`), nunca as `*Row` geradas pelo drift.
class LibraryRepository {
  LibraryRepository(this._db, this._feedParser);

  final AppDatabase _db;
  final RssFeedParser _feedParser;

  /// Não rebusca o mesmo feed com menos de 1h desde o último refresh
  /// (a menos que `force`).
  static const _refreshThrottle = Duration(hours: 1);

  Stream<List<Podcast>> watchSubscriptions() {
    return _db.select(_db.subscriptions).watch().map(
          (rows) => rows.map(_podcastFromRow).toList(),
        );
  }

  Stream<bool> watchIsSubscribed(int podcastId) {
    final query = _db.select(_db.subscriptions)..where((t) => t.id.equals(podcastId));
    return query.watchSingleOrNull().map((row) => row != null);
  }

  Stream<List<Episode>> watchEpisodes(int podcastId, {bool includeArchived = false}) {
    final query = _db.select(_db.episodeCache)
      ..where((t) => t.podcastId.equals(podcastId))
      ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]);
    if (!includeArchived) query.where((t) => t.archived.equals(false));
    return query.watch().map((rows) => rows.map(_episodeFromRow).toList());
  }

  /// Guids arquivados de um podcast, ao vivo (Fase 13). A lista do detalhe
  /// vem do RSS ao vivo, não do cache — então o filtro de arquivados é
  /// aplicado na View com este conjunto, igual ao progresso.
  Stream<Set<String>> watchArchivedGuids(int podcastId) {
    final query = _db.select(_db.episodeCache)
      ..where((t) => t.podcastId.equals(podcastId) & t.archived.equals(true));
    return query.watch().map((rows) => {for (final row in rows) row.guid});
  }

  /// Arquiva / desarquiva um episódio (no-op se não estiver no cache —
  /// só episódio de podcast assinado tem linha).
  Future<void> setEpisodeArchived(int podcastId, String episodeGuid, bool archived) {
    return (_db.update(_db.episodeCache)
          ..where((t) => t.podcastId.equals(podcastId) & t.guid.equals(episodeGuid)))
        .write(EpisodeCacheCompanion(archived: Value(archived)));
  }

  /// Corrige a duração cacheada com a real que o player descobriu (Fase 21 v3
  /// — `itunes:duration` costuma vir errado/arredondado). No-op se não estiver
  /// no cache ou se o valor já bate.
  Future<void> updateEpisodeDuration(int podcastId, String episodeGuid, Duration real) {
    final seconds = real.inSeconds;
    if (seconds <= 0) return Future.value();
    return (_db.update(_db.episodeCache)
          ..where((t) =>
              t.podcastId.equals(podcastId) &
              t.guid.equals(episodeGuid) &
              (t.durationSeconds.isNull() | t.durationSeconds.equals(seconds).not())))
        .write(EpisodeCacheCompanion(durationSeconds: Value(seconds)));
  }

  /// Marca ouvido / não-ouvido na mão (Fase 13). "Não ouvido" zera a
  /// posição; "ouvido" só levanta a flag.
  Future<void> setEpisodeCompleted(int podcastId, String episodeGuid, bool completed) {
    return _db.into(_db.playbackProgress).insertOnConflictUpdate(
          PlaybackProgressCompanion.insert(
            podcastId: podcastId,
            episodeGuid: episodeGuid,
            positionSeconds: const Value(0),
            completed: Value(completed),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Mesma lista de [watchEpisodes], mas uma leitura só — usada como
  /// fallback quando o RSS não responde (sem internet, feed fora do ar) e
  /// já existe cache de uma visita anterior. Sem isso, um episódio baixado
  /// fica inacessível em modo avião: a tela de detalhe travaria no erro de
  /// rede antes de sequer mostrar a lista.
  Future<List<Episode>> cachedEpisodes(int podcastId, {bool includeArchived = false}) async {
    final query = _db.select(_db.episodeCache)
      ..where((t) => t.podcastId.equals(podcastId))
      ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]);
    if (!includeArchived) query.where((t) => t.archived.equals(false));
    final rows = await query.get();
    return rows.map(_episodeFromRow).toList();
  }

  Future<void> subscribe(Podcast podcast, List<Episode> episodes) async {
    await _db.into(_db.subscriptions).insertOnConflictUpdate(
          SubscriptionsCompanion.insert(
            id: Value(podcast.id),
            title: podcast.title,
            author: podcast.author,
            feedUrl: podcast.feedUrl,
            artworkUrl: Value(podcast.artworkUrl),
            genre: Value(podcast.genre),
            episodeCount: Value(podcast.episodeCount),
          ),
        );
    await _cacheEpisodes(podcast.id, episodes);
  }

  Future<void> unsubscribe(int podcastId) async {
    // As linhas de `episodeCache`/`playbackProgress`/`downloads` somem
    // sozinhas via `onDelete: cascade` nas referências.
    await (_db.delete(_db.subscriptions)..where((t) => t.id.equals(podcastId))).go();
  }

  /// Faz upsert dos episódios no cache **se** o podcast está assinado
  /// (senão a FK barra). Chamado pelo detalhe toda vez que ele carrega com
  /// rede — é o que mantém o cache fresco (Fase 9).
  Future<void> cacheEpisodesIfSubscribed(int podcastId, List<Episode> episodes) async {
    final sub =
        await (_db.select(_db.subscriptions)..where((t) => t.id.equals(podcastId))).getSingleOrNull();
    if (sub == null) return;
    await _cacheEpisodes(podcastId, episodes);
  }

  /// Rebusca o RSS de um podcast assinado e faz upsert no cache. Devolve os
  /// episódios inéditos (guid nunca visto). Sem `force`, pula se o feed foi
  /// atualizado há menos de [_refreshThrottle] (devolve lista vazia).
  Future<List<Episode>> refreshFeed(int podcastId, {bool force = false}) async {
    final sub =
        await (_db.select(_db.subscriptions)..where((t) => t.id.equals(podcastId))).getSingleOrNull();
    if (sub == null) return const [];

    if (!force &&
        sub.lastRefreshedAt != null &&
        DateTime.now().difference(sub.lastRefreshedAt!) < _refreshThrottle) {
      return const [];
    }

    final fresh = await _feedParser.fetchEpisodes(sub.feedUrl);

    final existing =
        await (_db.select(_db.episodeCache)..where((t) => t.podcastId.equals(podcastId))).get();
    final existingGuids = {for (final row in existing) row.guid};
    final newEpisodes = fresh.where((e) => !existingGuids.contains(e.guid)).toList();

    await _cacheEpisodes(podcastId, fresh);
    await (_db.update(_db.subscriptions)..where((t) => t.id.equals(podcastId)))
        .write(SubscriptionsCompanion(lastRefreshedAt: Value(DateTime.now())));

    return newEpisodes;
  }

  /// Rebusca todos os feeds assinados em lotes concorrentes (respeitando o
  /// throttle por feed). Um feed lento/fora do ar não trava os outros —
  /// antes era sequencial, e um feed morto (timeout 10s + até 3 retentativas
  /// ≈ 1min) segurava o refresh inteiro até chegar nele. `concurrency`
  /// controla quantos feeds em paralelo por lote: pull-to-refresh (usuário
  /// esperando) usa um valor maior que o refresh de startup (fire-and-forget,
  /// não deve competir por I/O/CPU com o primeiro frame da UI).
  Future<List<FeedRefreshResult>> refreshAllSubscriptions({
    bool force = false,
    int concurrency = 4,
  }) async {
    final subs = await _db.select(_db.subscriptions).get();
    final results = <FeedRefreshResult>[];
    for (var i = 0; i < subs.length; i += concurrency) {
      final chunk = subs.skip(i).take(concurrency);
      final chunkResults = await Future.wait(chunk.map((sub) async {
        try {
          final newEpisodes = await refreshFeed(sub.id, force: force);
          if (newEpisodes.isNotEmpty) {
            return (podcast: _podcastFromRow(sub), newEpisodes: newEpisodes);
          }
        } catch (_) {
          // sem rede / feed quebrado — ignora, tenta os próximos
        }
        return null;
      }));
      results.addAll(chunkResults.whereType<FeedRefreshResult>());
    }
    return results;
  }

  /// Posição salva de um episódio, ou `null` se nunca tocou. Usado pelo
  /// player (Fase 4) pra retomar de onde parou.
  Future<Duration?> playbackPositionFor(int podcastId, String episodeGuid) async {
    final query = _db.select(_db.playbackProgress)
      ..where((t) => t.podcastId.equals(podcastId) & t.episodeGuid.equals(episodeGuid));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return Duration(seconds: row.positionSeconds);
  }

  /// Progresso de escuta de todos os episódios de um podcast, ao vivo —
  /// pra lista de episódios mostrar barra de progresso e selo "ouvido".
  /// Mapa por `episodeGuid`; um guid ausente = nunca tocou.
  Stream<Map<String, EpisodeProgress>> watchProgressForPodcast(int podcastId) {
    final query = _db.select(_db.playbackProgress)..where((t) => t.podcastId.equals(podcastId));
    return query.watch().map((rows) => {
          for (final row in rows)
            row.episodeGuid: (positionSeconds: row.positionSeconds, completed: row.completed),
        });
  }

  /// Episódios de um podcast com download concluído, ao vivo — pra aba
  /// "Baixados" do detalhe. Devolve o [Episode] completo (do cache), então
  /// dá pra tocar e reusar o mesmo tile da aba de episódios.
  Stream<List<Episode>> watchDownloadedEpisodes(int podcastId) {
    final query = _db.select(_db.episodeCache).join([
      innerJoin(
        _db.downloads,
        _db.downloads.podcastId.equalsExp(_db.episodeCache.podcastId) &
            _db.downloads.episodeGuid.equalsExp(_db.episodeCache.guid) &
            _db.downloads.status.equals(DownloadStatus.complete.name),
      ),
    ])
      ..where(_db.episodeCache.podcastId.equals(podcastId))
      ..orderBy([OrderingTerm.desc(_db.episodeCache.publishedAt)]);
    return query
        .watch()
        .map((rows) => rows.map((r) => _episodeFromRow(r.readTable(_db.episodeCache))).toList());
  }

  /// "Continuar ouvindo" da tela Início: episódios começados e não
  /// terminados, de qualquer assinatura, do mais recente pro mais antigo
  /// (por `updatedAt` do progresso).
  Stream<List<ContinueListeningItem>> watchContinueListening({int limit = 20}) {
    final query = _db.select(_db.playbackProgress).join([
      innerJoin(
        _db.episodeCache,
        _db.episodeCache.podcastId.equalsExp(_db.playbackProgress.podcastId) &
            _db.episodeCache.guid.equalsExp(_db.playbackProgress.episodeGuid),
      ),
      innerJoin(
        _db.subscriptions,
        _db.subscriptions.id.equalsExp(_db.playbackProgress.podcastId),
      ),
    ])
      ..where(
        _db.playbackProgress.completed.equals(false) &
            _db.playbackProgress.positionSeconds.isBiggerThan(const Constant(0)) &
            _db.episodeCache.archived.equals(false),
      )
      ..orderBy([OrderingTerm.desc(_db.playbackProgress.updatedAt)])
      ..limit(limit);

    return query.watch().map((rows) => [
          for (final row in rows)
            (
              podcast: _podcastFromRow(row.readTable(_db.subscriptions)),
              episode: _episodeFromRow(row.readTable(_db.episodeCache)),
              positionSeconds: row.readTable(_db.playbackProgress).positionSeconds,
            ),
        ]);
  }

  /// "Novos episódios" da tela Início: episódios (com data) de qualquer
  /// assinatura, do mais recente pro mais antigo por `publishedAt`.
  Stream<List<RecentEpisodeItem>> watchRecentEpisodes({int limit = 30}) {
    final query = _db.select(_db.episodeCache).join([
      innerJoin(
        _db.subscriptions,
        _db.subscriptions.id.equalsExp(_db.episodeCache.podcastId),
      ),
    ])
      ..where(
        _db.episodeCache.publishedAt.isNotNull() &
            _db.episodeCache.archived.equals(false),
      )
      ..orderBy([OrderingTerm.desc(_db.episodeCache.publishedAt)])
      ..limit(limit);

    return query.watch().map((rows) => [
          for (final row in rows)
            (
              podcast: _podcastFromRow(row.readTable(_db.subscriptions)),
              episode: _episodeFromRow(row.readTable(_db.episodeCache)),
            ),
        ]);
  }

  Future<void> savePlaybackPosition({
    required int podcastId,
    required String episodeGuid,
    required Duration position,
    required bool completed,
  }) {
    return _db.into(_db.playbackProgress).insertOnConflictUpdate(
          PlaybackProgressCompanion.insert(
            podcastId: podcastId,
            episodeGuid: episodeGuid,
            positionSeconds: Value(position.inSeconds),
            completed: Value(completed),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  // ---- Gestão automática por podcast (Fase 13) ----

  Stream<SubscriptionSettings> watchSubscriptionSettings(int podcastId) {
    final query = _db.select(_db.subscriptions)..where((t) => t.id.equals(podcastId));
    return query.watchSingleOrNull().map(
          (row) => row == null ? defaultSubscriptionSettings : _settingsFromRow(row),
        );
  }

  Future<List<({Podcast podcast, SubscriptionSettings settings})>>
      allSubscriptionsWithSettings() async {
    final rows = await _db.select(_db.subscriptions).get();
    return [
      for (final row in rows) (podcast: _podcastFromRow(row), settings: _settingsFromRow(row)),
    ];
  }

  Future<void> updateAutoManagement(
    int podcastId, {
    AutoDownloadMode? autoDownload,
    int? autoDownloadLimit,
    int? autoDeletePlayedDays,
  }) {
    return (_db.update(_db.subscriptions)..where((t) => t.id.equals(podcastId))).write(
      SubscriptionsCompanion(
        autoDownload:
            autoDownload == null ? const Value.absent() : Value(autoDownload.name),
        autoDownloadLimit: autoDownloadLimit == null
            ? const Value.absent()
            : Value(autoDownloadLimit),
        autoDeletePlayedDays: autoDeletePlayedDays == null
            ? const Value.absent()
            : Value(autoDeletePlayedDays),
      ),
    );
  }

  /// `null` volta pra velocidade global.
  Future<void> setPlaybackSpeedOverride(int podcastId, double? speed) {
    return (_db.update(_db.subscriptions)..where((t) => t.id.equals(podcastId)))
        .write(SubscriptionsCompanion(playbackSpeedOverride: Value(speed)));
  }

  /// Episódios recentes (entraram no cache dentro de [within]) de um podcast
  /// que ainda não têm download — candidatos ao auto-download.
  Future<List<Episode>> recentUndownloadedEpisodes(
    int podcastId, {
    required int limit,
    Duration within = const Duration(days: 7),
  }) async {
    if (limit <= 0) return const [];
    final cutoff = DateTime.now().subtract(within);
    // Sem `LIMIT` no SQL de propósito: o corte por `limit` é aplicado
    // depois de tirar os que já têm download.
    final recent = await (_db.select(_db.episodeCache)
          ..where((t) =>
              t.podcastId.equals(podcastId) &
              t.archived.equals(false) &
              t.addedAt.isBiggerThanValue(cutoff))
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .get();
    final downloadedGuids = {
      for (final row
          in await (_db.select(_db.downloads)..where((t) => t.podcastId.equals(podcastId))).get())
        row.episodeGuid,
    };
    return [
      for (final row in recent)
        if (!downloadedGuids.contains(row.guid)) _episodeFromRow(row),
    ].take(limit).toList();
  }

  /// Guids de downloads concluídos + ouvidos até o fim há mais de
  /// [olderThan] — candidatos à limpeza automática.
  Future<List<String>> playedDownloadsToPrune(int podcastId, Duration olderThan) async {
    final cutoff = DateTime.now().subtract(olderThan);
    final query = _db.select(_db.downloads).join([
      innerJoin(
        _db.playbackProgress,
        _db.playbackProgress.podcastId.equalsExp(_db.downloads.podcastId) &
            _db.playbackProgress.episodeGuid.equalsExp(_db.downloads.episodeGuid) &
            _db.playbackProgress.completed.equals(true) &
            _db.playbackProgress.updatedAt.isSmallerThanValue(cutoff),
      ),
    ])
      ..where(
        _db.downloads.podcastId.equals(podcastId) &
            _db.downloads.status.equals(DownloadStatus.complete.name),
      );
    final rows = await query.get();
    return [for (final row in rows) row.readTable(_db.downloads).episodeGuid];
  }

  // ---- Estatísticas de escuta (Fase 17) ----

  /// Soma [delta] segundos ao histórico de hoje pra este episódio (upsert em
  /// `listen_history`, chave `{podcastId, episodeGuid, dia}`). No-op se
  /// `delta <= 0`. Chamado pelo player conforme o áudio avança.
  Future<void> recordListening({
    required int podcastId,
    required String episodeGuid,
    required Duration delta,
  }) async {
    if (delta <= Duration.zero) return;
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    await _db.into(_db.listenHistory).insert(
          ListenHistoryCompanion.insert(
            podcastId: podcastId,
            episodeGuid: episodeGuid,
            day: day,
            secondsListened: Value(delta.inSeconds),
            updatedAt: Value(now),
          ),
          onConflict: DoUpdate(
            (old) => ListenHistoryCompanion.custom(
              secondsListened: old.secondsListened + Constant(delta.inSeconds),
              updatedAt: Constant(now),
            ),
            target: [
              _db.listenHistory.podcastId,
              _db.listenHistory.episodeGuid,
              _db.listenHistory.day,
            ],
          ),
        );
  }

  /// Histórico de escuta agregado por episódio: o dia mais recente ouvido +
  /// o total ouvido. INNER com o cache — só aparece o que ainda está em
  /// `episode_cache`. Ordena por dia desc; corta em [limit].
  Stream<List<ListenHistoryItem>> watchListenHistory({int limit = 50}) {
    return _db.select(_db.listenHistory).watch().asyncMap((rows) async {
      final agg = <(int, String), ({DateTime lastDay, int seconds})>{};
      for (final row in rows) {
        final key = (row.podcastId, row.episodeGuid);
        final prev = agg[key];
        agg[key] = (
          lastDay: prev == null || row.day.isAfter(prev.lastDay) ? row.day : prev.lastDay,
          seconds: (prev?.seconds ?? 0) + row.secondsListened,
        );
      }
      final ordered = agg.entries.toList()
        ..sort((a, b) => b.value.lastDay.compareTo(a.value.lastDay));

      final items = <ListenHistoryItem>[];
      for (final entry in ordered) {
        if (items.length >= limit) break;
        final (podcastId, guid) = entry.key;
        final epRow = await (_db.select(_db.episodeCache)
              ..where((t) => t.podcastId.equals(podcastId) & t.guid.equals(guid)))
            .getSingleOrNull();
        if (epRow == null) continue;
        final subRow = await (_db.select(_db.subscriptions)..where((t) => t.id.equals(podcastId)))
            .getSingleOrNull();
        if (subRow == null) continue;
        items.add((
          podcast: _podcastFromRow(subRow),
          episode: _episodeFromRow(epRow),
          lastPlayedDay: entry.value.lastDay,
          listened: Duration(seconds: entry.value.seconds),
        ));
      }
      return items;
    });
  }

  /// Estatísticas derivadas de toda a `listen_history`, ao vivo: total,
  /// tempo desta semana (a partir de segunda 00:00 local), streak de dias
  /// consecutivos terminando hoje ou ontem, e os últimos 7 dias (hoje +
  /// 6 anteriores, cronológico, 0 nos dias vazios).
  Stream<ListeningStats> watchListeningStats() {
    return _db.select(_db.listenHistory).watch().map((rows) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final monday = _addDays(today, -(today.weekday - 1));

      final perDay = <DateTime, int>{};
      var totalSeconds = 0;
      for (final row in rows) {
        final day = DateTime(row.day.year, row.day.month, row.day.day);
        perDay.update(day, (v) => v + row.secondsListened,
            ifAbsent: () => row.secondsListened);
        totalSeconds += row.secondsListened;
      }

      var weekSeconds = 0;
      perDay.forEach((day, secs) {
        if (!day.isBefore(monday)) weekSeconds += secs;
      });

      var streak = 0;
      var cursor = perDay.containsKey(today) ? today : _addDays(today, -1);
      while (perDay.containsKey(cursor)) {
        streak++;
        cursor = _addDays(cursor, -1);
      }

      final last7 = List<DailyListening>.generate(7, (idx) {
        final day = _addDays(today, idx - 6);
        return DailyListening(day: day, listened: Duration(seconds: perDay[day] ?? 0));
      });

      return ListeningStats(
        total: Duration(seconds: totalSeconds),
        thisWeek: Duration(seconds: weekSeconds),
        streakDays: streak,
        last7Days: last7,
      );
    });
  }

  /// Janela do badge de não-ouvidos: só conta episódio publicado nos últimos
  /// [unplayedWindow] (Fase 23 v3 — antes contava o catálogo inteiro em cache,
  /// milhares, inútil como sinal de "tem novidade").
  static const unplayedWindow = Duration(days: 30);

  /// Todas as assinaturas + `unplayedCount` (episódios recentes — ver
  /// [unplayedWindow] —, não arquivados, sem `playback_progress.completed = 1`)
  /// + `lastPublishedAt` (maior `published_at` do podcast). Ao vivo.
  Stream<List<LibrarySubscription>> watchSubscriptionsWithMeta() {
    final cutoff = DateTime.now().subtract(unplayedWindow);
    final query = _db.customSelect(
      'SELECT s.id, s.title, s.author, s.feed_url, s.artwork_url, s.genre, s.episode_count, '
      '(SELECT COUNT(*) FROM episode_cache e '
      ' WHERE e.podcast_id = s.id AND e.archived = 0 '
      '   AND e.published_at >= ? '
      '   AND NOT EXISTS (SELECT 1 FROM playback_progress p '
      '     WHERE p.podcast_id = e.podcast_id AND p.episode_guid = e.guid '
      '       AND p.completed = 1)) AS unplayed_count, '
      '(SELECT MAX(e2.published_at) FROM episode_cache e2 '
      ' WHERE e2.podcast_id = s.id) AS last_published_at '
      'FROM subscriptions s '
      'ORDER BY s.title COLLATE NOCASE',
      variables: [Variable.withDateTime(cutoff)],
      readsFrom: {_db.subscriptions, _db.episodeCache, _db.playbackProgress},
    );
    return query.watch().map((rows) => [
          for (final row in rows)
            (
              podcast: Podcast(
                id: row.read<int>('id'),
                title: row.read<String>('title'),
                author: row.read<String>('author'),
                feedUrl: row.read<String>('feed_url'),
                artworkUrl: row.readNullable<String>('artwork_url'),
                genre: row.readNullable<String>('genre'),
                episodeCount: row.read<int>('episode_count'),
              ),
              unplayedCount: row.read<int>('unplayed_count'),
              lastPublishedAt: row.readNullable<DateTime>('last_published_at'),
            ),
        ]);
  }

  /// Busca episódios de TODAS as assinaturas por `title` (contém [query],
  /// case-insensitive), não arquivados, do mais recente pro mais antigo.
  /// [query] só de espaço → `[]`.
  Future<List<RecentEpisodeItem>> searchLibraryEpisodes(String query, {int limit = 50}) async {
    final term = query.trim();
    if (term.isEmpty) return const [];
    final pattern = '%${term.toLowerCase()}%';
    final rows = await (_db.select(_db.episodeCache).join([
      innerJoin(
        _db.subscriptions,
        _db.subscriptions.id.equalsExp(_db.episodeCache.podcastId),
      ),
    ])
          ..where(_db.episodeCache.archived.equals(false) &
              _db.episodeCache.title.lower().like(pattern))
          ..orderBy([OrderingTerm.desc(_db.episodeCache.publishedAt)])
          ..limit(limit))
        .get();
    return [
      for (final row in rows)
        (
          podcast: _podcastFromRow(row.readTable(_db.subscriptions)),
          episode: _episodeFromRow(row.readTable(_db.episodeCache)),
        ),
    ];
  }

  /// Soma [n] dias de calendário a [d] (o construtor normaliza o overflow —
  /// evita o buraco de DST do `Duration`).
  static DateTime _addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

  SubscriptionSettings _settingsFromRow(SubscriptionRow row) => (
        autoDownload: AutoDownloadMode.fromName(row.autoDownload),
        autoDownloadLimit: row.autoDownloadLimit,
        autoDeletePlayedDays: row.autoDeletePlayedDays,
        playbackSpeedOverride: row.playbackSpeedOverride,
      );

  Future<void> _cacheEpisodes(int podcastId, List<Episode> episodes) {
    final now = DateTime.now();
    return _db.batch((batch) {
      // 1) novos: marca `addedAt = agora`; `insertOrIgnore` preserva o
      //    `addedAt` de quem já está no cache.
      batch.insertAll(
        _db.episodeCache,
        [
          for (final episode in episodes)
            _episodeCompanion(podcastId, episode, addedAt: Value(now)),
        ],
        mode: InsertMode.insertOrIgnore,
      );
      // 2) todos: atualiza os metadados (título/descrição/...) sem tocar
      //    em `addedAt` — a companion não o inclui, então o SET não o
      //    sobrescreve.
      batch.insertAllOnConflictUpdate(
        _db.episodeCache,
        [for (final episode in episodes) _episodeCompanion(podcastId, episode)],
      );
    });
  }

  EpisodeCacheCompanion _episodeCompanion(
    int podcastId,
    Episode episode, {
    Value<DateTime?> addedAt = const Value.absent(),
  }) {
    return EpisodeCacheCompanion.insert(
      podcastId: podcastId,
      guid: episode.guid,
      title: episode.title,
      audioUrl: episode.audioUrl,
      description: Value(episode.description),
      imageUrl: Value(episode.imageUrl),
      durationSeconds: Value(episode.duration?.inSeconds),
      publishedAt: Value(episode.publishedAt),
      addedAt: addedAt,
      // Fase 14 — entram nas DUAS passadas do `_cacheEpisodes` de propósito:
      // um feed que só depois passou a declarar temporada/capítulos precisa
      // atualizar episódio já cacheado.
      seasonNumber: Value(episode.seasonNumber),
      episodeNumber: Value(episode.episodeNumber),
      episodeType: Value(episode.episodeType),
      link: Value(episode.link),
      chaptersUrl: Value(episode.chaptersUrl),
    );
  }

  Podcast _podcastFromRow(SubscriptionRow row) {
    return Podcast(
      id: row.id,
      title: row.title,
      author: row.author,
      feedUrl: row.feedUrl,
      artworkUrl: row.artworkUrl,
      genre: row.genre,
      episodeCount: row.episodeCount,
    );
  }

  Episode _episodeFromRow(EpisodeCacheRow row) {
    return Episode(
      guid: row.guid,
      title: row.title,
      audioUrl: row.audioUrl,
      description: row.description,
      imageUrl: row.imageUrl,
      duration: row.durationSeconds == null ? null : Duration(seconds: row.durationSeconds!),
      publishedAt: row.publishedAt,
      seasonNumber: row.seasonNumber,
      episodeNumber: row.episodeNumber,
      episodeType: row.episodeType,
      link: row.link,
      chaptersUrl: row.chaptersUrl,
    );
  }
}

@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(Ref ref) {
  return LibraryRepository(
    ref.watch(appDatabaseProvider),
    RssFeedParser(ref.watch(dioClientProvider)),
  );
}
