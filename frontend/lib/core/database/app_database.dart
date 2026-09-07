import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Subscriptions, EpisodeCache, PlaybackProgress, Downloads, QueueItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'podcast_app'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v1 -> v2 (Fase 5): download ganhou taskId (pra casar o evento
          // do flutter_downloader com a linha certa) e progress (0-100).
          if (from < 2) {
            await m.addColumn(downloads, downloads.taskId);
            await m.addColumn(downloads, downloads.progress);
          }
          // v2 -> v3 (Fase 9 — feeds vivos): cache de episódio ganha
          // addedAt; assinatura ganha lastRefreshedAt (throttle do refresh).
          // Ambas nullable — SQLite não deixa ADD COLUMN NOT NULL com
          // default de expressão (foi o bug que travou a tela no shimmer).
          if (from < 3) {
            await m.addColumn(subscriptions, subscriptions.lastRefreshedAt);
            await m.addColumn(episodeCache, episodeCache.addedAt);
            // Episódios já cacheados não são "novos" — usa a data de
            // publicação como aproximação de quando entraram.
            await m.database.customStatement(
              'UPDATE episode_cache SET added_at = published_at WHERE added_at IS NULL',
            );
          }
          // v3 -> v4 (Fase 12 — fila real): fila de reprodução persistente.
          if (from < 4) {
            await m.createTable(queueItems);
          }
        },
      );
}

/// `keepAlive`: a conexão com o banco vive pelo tempo do app — recriar a
/// cada tela seria caro e arriscaria reabrir o arquivo no meio de uma
/// consulta pendente.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
