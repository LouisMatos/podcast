import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Subscriptions,
    EpisodeCache,
    PlaybackProgress,
    Downloads,
    QueueItems,
    Chapters,
    ListenHistory,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(
          executor ??
              driftDatabase(
                name: 'podcast_app',
                native: DriftNativeOptions(
                  // Sem isso: rollback-journal (padrão do sqlite3) + sem
                  // busy_timeout. O app principal e o isolate do WorkManager
                  // (`background_sync.dart`) abrem conexões separadas pro
                  // mesmo arquivo — sem WAL, uma escrita de um bloqueia
                  // leitura do outro; sem busy_timeout, a segunda conexão
                  // lança `SQLITE_BUSY` na hora em vez de esperar.
                  setup: (db) {
                    db.execute('PRAGMA journal_mode=WAL');
                    db.execute('PRAGMA busy_timeout=5000');
                  },
                ),
              ),
        );

  @override
  int get schemaVersion => 8;

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
          // v4 -> v5 (Fase 13 — gestão de episódios): arquivar + gestão
          // automática por podcast. Todos os defaults são constantes
          // (SQLite aceita `ADD COLUMN` com default constante).
          if (from < 5) {
            await m.addColumn(episodeCache, episodeCache.archived);
            await m.addColumn(subscriptions, subscriptions.autoDownload);
            await m.addColumn(subscriptions, subscriptions.autoDownloadLimit);
            await m.addColumn(subscriptions, subscriptions.autoDeletePlayedDays);
            await m.addColumn(subscriptions, subscriptions.playbackSpeedOverride);
          }
          // v5 -> v6 (Fase 14 — player avançado): metadados avançados do
          // episódio + tabela de capítulos. As 5 colunas são nullable (sem
          // default), então o `ADD COLUMN` passa.
          if (from < 6) {
            await m.addColumn(episodeCache, episodeCache.seasonNumber);
            await m.addColumn(episodeCache, episodeCache.episodeNumber);
            await m.addColumn(episodeCache, episodeCache.episodeType);
            await m.addColumn(episodeCache, episodeCache.link);
            await m.addColumn(episodeCache, episodeCache.chaptersUrl);
            await m.createTable(chapters);
          }
          // v6 -> v7 (Fase 17 — estatísticas de escuta): tabela nova
          // `listen_history` (sem FK — sobrevive a desassinar o podcast).
          if (from < 7) {
            await m.createTable(listenHistory);
          }
          // v7 -> v8 (ponytail — perf em aparelho fraco): índices pras
          // consultas cross-podcast que hoje escaneiam a tabela inteira
          // (`watchRecentEpisodes`/`watchContinueListening`) e pro lookup
          // de download por `taskId` (evento do flutter_downloader).
          if (from < 8) {
            await m.database.customStatement(
              'CREATE INDEX IF NOT EXISTS idx_episode_cache_recent ON episode_cache (archived, published_at)',
            );
            await m.database.customStatement(
              'CREATE INDEX IF NOT EXISTS idx_playback_progress_continue ON playback_progress (completed, updated_at)',
            );
            await m.database.customStatement(
              'CREATE INDEX IF NOT EXISTS idx_downloads_task_id ON downloads (task_id)',
            );
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
