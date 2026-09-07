import 'package:drift/drift.dart' show BooleanExpressionOperators, OrderingTerm, Value, innerJoin;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/network/dio_client.dart';
import '../models/download_status.dart';
import '../models/episode.dart';
import '../models/podcast.dart';
import '../sources/rss_feed_parser.dart';

part 'library_repository.g.dart';

/// Progresso de escuta de um episódio, do jeito que a lista de episódios
/// precisa: posição atual e se já foi ouvido até o fim.
typedef EpisodeProgress = ({int positionSeconds, bool completed});

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

  Stream<List<Episode>> watchEpisodes(int podcastId) {
    final query = _db.select(_db.episodeCache)
      ..where((t) => t.podcastId.equals(podcastId))
      ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]);
    return query.watch().map((rows) => rows.map(_episodeFromRow).toList());
  }

  /// Mesma lista de [watchEpisodes], mas uma leitura só — usada como
  /// fallback quando o RSS não responde (sem internet, feed fora do ar) e
  /// já existe cache de uma visita anterior. Sem isso, um episódio baixado
  /// fica inacessível em modo avião: a tela de detalhe travaria no erro de
  /// rede antes de sequer mostrar a lista.
  Future<List<Episode>> cachedEpisodes(int podcastId) async {
    final query = _db.select(_db.episodeCache)
      ..where((t) => t.podcastId.equals(podcastId))
      ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]);
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

  /// Rebusca o RSS de um podcast assinado e faz upsert no cache. Devolve
  /// quantos episódios são novos (guid inédito). Sem `force`, pula se o
  /// feed foi atualizado há menos de [_refreshThrottle].
  Future<int> refreshFeed(int podcastId, {bool force = false}) async {
    final sub =
        await (_db.select(_db.subscriptions)..where((t) => t.id.equals(podcastId))).getSingleOrNull();
    if (sub == null) return 0;

    if (!force &&
        sub.lastRefreshedAt != null &&
        DateTime.now().difference(sub.lastRefreshedAt!) < _refreshThrottle) {
      return 0;
    }

    final fresh = await _feedParser.fetchEpisodes(sub.feedUrl);

    final existing =
        await (_db.select(_db.episodeCache)..where((t) => t.podcastId.equals(podcastId))).get();
    final existingGuids = {for (final row in existing) row.guid};
    final newCount = fresh.where((e) => !existingGuids.contains(e.guid)).length;

    await _cacheEpisodes(podcastId, fresh);
    await (_db.update(_db.subscriptions)..where((t) => t.id.equals(podcastId)))
        .write(SubscriptionsCompanion(lastRefreshedAt: Value(DateTime.now())));

    return newCount;
  }

  /// Rebusca todos os feeds assinados (respeitando o throttle por feed).
  /// Um feed fora do ar não impede os outros. Devolve o total de episódios
  /// novos.
  Future<int> refreshAllSubscriptions({bool force = false}) async {
    final subs = await _db.select(_db.subscriptions).get();
    var total = 0;
    for (final sub in subs) {
      try {
        total += await refreshFeed(sub.id, force: force);
      } catch (_) {
        // sem rede / feed quebrado — ignora, tenta os próximos
      }
    }
    return total;
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
      ..orderBy([OrderingTerm.desc(_db.episodeCache.publishedAt)]);
    return query
        .watch()
        .map((rows) => rows.map((r) => _episodeFromRow(r.readTable(_db.episodeCache))).toList());
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

  Future<void> _cacheEpisodes(int podcastId, List<Episode> episodes) {
    return _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.episodeCache,
        [
          for (final episode in episodes)
            EpisodeCacheCompanion.insert(
              podcastId: podcastId,
              guid: episode.guid,
              title: episode.title,
              audioUrl: episode.audioUrl,
              description: Value(episode.description),
              imageUrl: Value(episode.imageUrl),
              durationSeconds: Value(episode.duration?.inSeconds),
              publishedAt: Value(episode.publishedAt),
            ),
        ],
      );
    });
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
