import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../models/episode.dart';
import '../models/podcast.dart';

part 'queue_repository.g.dart';

/// Um item da fila: episódio + o podcast a que pertence. A fila é
/// cross-podcast, então cada item carrega seu próprio podcast.
typedef QueueEntry = ({Podcast podcast, Episode episode});

/// Fila de reprodução persistente (Fase 12). O item em `position = 0` é o
/// que está tocando / em foco; o resto é "a seguir".
///
/// Toda mutação reescreve a tabela inteira com posições 0..n contíguas —
/// a fila é pequena (dezenas de itens no máximo) e isso elimina toda a
/// classe de bug de posição furada / duplicada.
class QueueRepository {
  QueueRepository(this._db);

  final AppDatabase _db;

  Stream<List<QueueEntry>> watchQueue() {
    final query = _db.select(_db.queueItems)
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    return query.watch().map((rows) => rows.map(_entryFromRow).toList());
  }

  Future<List<QueueEntry>> currentQueue() => _read();

  /// Substitui a fila inteira.
  Future<void> replaceWith(List<QueueEntry> entries) =>
      _mutate((list) => list
        ..clear()
        ..addAll(entries));

  /// "Tocar agora": põe o episódio na frente (posição 0) **preservando** o
  /// resto da fila. Se já estava na fila, é movido pra frente. É o que
  /// acontece ao tocar um episódio solto (Fase 12, decisão b — não
  /// substitui a fila pela lista inteira do podcast).
  Future<void> playNow(Podcast podcast, Episode episode) => _mutate((list) {
        list.removeWhere((e) => _same(e, podcast.id, episode.guid));
        list.insert(0, (podcast: podcast, episode: episode));
      });

  /// Adiciona ao fim. No-op se o episódio já está na fila.
  Future<void> addToEnd(Podcast podcast, Episode episode) => _mutate((list) {
        if (list.any((e) => _same(e, podcast.id, episode.guid))) return;
        list.add((podcast: podcast, episode: episode));
      });

  /// Insere logo após o item atual (`currentGuid`) — "tocar a seguir".
  /// Se o episódio já estava na fila, é movido pra essa posição.
  Future<void> playNextAfter(Podcast podcast, Episode episode, String? currentGuid) =>
      _mutate((list) {
        list.removeWhere((e) => _same(e, podcast.id, episode.guid));
        final currentIndex =
            currentGuid == null ? -1 : list.indexWhere((e) => e.episode.guid == currentGuid);
        list.insert(currentIndex + 1, (podcast: podcast, episode: episode));
      });

  Future<void> removeAt(int index) => _mutate((list) {
        if (index >= 0 && index < list.length) list.removeAt(index);
      });

  Future<void> removeEpisode(int podcastId, String episodeGuid) => _mutate(
        (list) => list.removeWhere((e) => _same(e, podcastId, episodeGuid)),
      );

  Future<void> move(int oldIndex, int newIndex) => _mutate((list) {
        if (oldIndex < 0 || oldIndex >= list.length) return;
        final item = list.removeAt(oldIndex);
        list.insert(newIndex.clamp(0, list.length), item);
      });

  Future<void> clear() => _mutate((list) => list.clear());

  Future<void> _mutate(void Function(List<QueueEntry>) change) {
    return _db.transaction(() async {
      final list = await _read();
      change(list);
      await _db.delete(_db.queueItems).go();
      await _db.batch((batch) {
        for (var i = 0; i < list.length; i++) {
          batch.insert(_db.queueItems, _companion(list[i], i));
        }
      });
    });
  }

  Future<List<QueueEntry>> _read() async {
    final rows = await (_db.select(_db.queueItems)
          ..orderBy([(t) => OrderingTerm.asc(t.position)]))
        .get();
    return rows.map(_entryFromRow).toList();
  }

  bool _same(QueueEntry e, int podcastId, String guid) =>
      e.podcast.id == podcastId && e.episode.guid == guid;

  QueueItemsCompanion _companion(QueueEntry entry, int position) {
    final p = entry.podcast;
    final e = entry.episode;
    return QueueItemsCompanion.insert(
      position: position,
      podcastId: p.id,
      podcastTitle: p.title,
      podcastAuthor: p.author,
      podcastFeedUrl: p.feedUrl,
      podcastArtworkUrl: Value(p.artworkUrl),
      episodeGuid: e.guid,
      episodeTitle: e.title,
      audioUrl: e.audioUrl,
      episodeImageUrl: Value(e.imageUrl),
      episodeDurationSeconds: Value(e.duration?.inSeconds),
      episodePublishedAt: Value(e.publishedAt),
    );
  }

  QueueEntry _entryFromRow(QueueItemRow row) {
    return (
      podcast: Podcast(
        id: row.podcastId,
        title: row.podcastTitle,
        author: row.podcastAuthor,
        feedUrl: row.podcastFeedUrl,
        artworkUrl: row.podcastArtworkUrl,
      ),
      episode: Episode(
        guid: row.episodeGuid,
        title: row.episodeTitle,
        audioUrl: row.audioUrl,
        imageUrl: row.episodeImageUrl,
        duration: row.episodeDurationSeconds == null
            ? null
            : Duration(seconds: row.episodeDurationSeconds!),
        publishedAt: row.episodePublishedAt,
      ),
    );
  }
}

@Riverpod(keepAlive: true)
QueueRepository queueRepository(Ref ref) => QueueRepository(ref.watch(appDatabaseProvider));

/// Stream reativo da fila persistida — a fonte de verdade da ordem.
/// `keepAlive`: consumido pelo `PlayerViewModel` (que também é keepAlive).
@Riverpod(keepAlive: true)
Stream<List<QueueEntry>> queue(Ref ref) => ref.watch(queueRepositoryProvider).watchQueue();
