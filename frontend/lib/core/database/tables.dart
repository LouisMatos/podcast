import 'package:drift/drift.dart';

/// Todas as classes de linha geradas aqui terminam em `Row` de propósito —
/// evita colidir com os modelos de domínio (`Podcast`, `Episode` em
/// `data/models/`), que são coisas diferentes: a Row é o formato de
/// persistência, o modelo é o que o resto do app enxerga.

/// Podcasts que o usuário assinou. `id` é o `collectionId` da iTunes
/// Search API — já é estável e único, não precisamos gerar outro.
@DataClassName('SubscriptionRow')
class Subscriptions extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get author => text()();
  TextColumn get feedUrl => text()();
  TextColumn get artworkUrl => text().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get episodeCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get subscribedAt => dateTime().withDefault(currentDateAndTime)();

  /// Última vez que o feed foi rebuscado e o cache atualizado (Fase 9).
  /// `null` = nunca desde a assinatura. Usado pra não rebuscar o mesmo feed
  /// toda hora ao abrir o app.
  DateTimeColumn get lastRefreshedAt => dateTime().nullable()();

  /// Gestão automática por podcast (Fase 13). Defaults = comportamento
  /// atual (nada automático).
  ///
  /// `autoDownload`: `never` | `wifi` | `always`.
  TextColumn get autoDownload => text().withDefault(const Constant('never'))();

  /// Quantos episódios recentes manter baixados automaticamente.
  IntColumn get autoDownloadLimit => integer().withDefault(const Constant(3))();

  /// Apagar download já ouvido depois de N dias. `0` = nunca.
  IntColumn get autoDeletePlayedDays => integer().withDefault(const Constant(0))();

  /// Velocidade fixa pra este podcast (`null` = usa a global). Consumida
  /// pelo player na Fase 13/14.
  RealColumn get playbackSpeedOverride => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache local dos episódios de um podcast assinado. Existe pra biblioteca
/// funcionar offline e como base pro progresso de escuta (Fase 4) e
/// download (Fase 5) — a chave é `(podcastId, guid)` porque um guid de RSS
/// só é único dentro do feed de origem.
///
/// Índice em `(archived, publishedAt)`: `watchRecentEpisodes` no
/// `LibraryRepository` filtra por `archived` e ordena por `publishedAt`
/// cruzando todos os podcasts (sem prefixo de PK pra usar).
@TableIndex(name: 'idx_episode_cache_recent', columns: {#archived, #publishedAt})
@DataClassName('EpisodeCacheRow')
class EpisodeCache extends Table {
  IntColumn get podcastId => integer().references(Subscriptions, #id, onDelete: KeyAction.cascade)();
  TextColumn get guid => text()();
  TextColumn get title => text()();
  TextColumn get audioUrl => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();

  /// Quando o episódio entrou no cache local (Fase 9). `null` = já estava
  /// no cache antes da v3 (não dá pra saber). Feeds mentem `publishedAt`;
  /// quando presente, isto é confiável pra "novos desde a última visita".
  /// Nullable de propósito: SQLite não deixa `ADD COLUMN NOT NULL` com
  /// default de expressão — quem preenche em INSERT é o `LibraryRepository`.
  DateTimeColumn get addedAt => dateTime().nullable()();

  /// Arquivado (Fase 13) — some das listas mas não desassina nem apaga o
  /// cache. Default `false` = comportamento atual.
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  /// Metadados avançados do feed (Fase 14). Todos nullable: feed antigo /
  /// linha antiga simplesmente não tem, e `ADD COLUMN NOT NULL` com default
  /// de expressão trava a migração.
  IntColumn get seasonNumber => integer().nullable()();
  IntColumn get episodeNumber => integer().nullable()();

  /// `full` | `trailer` | `bonus` (itunes:episodeType). `null` = o feed não
  /// declarou.
  TextColumn get episodeType => text().nullable()();

  /// `<link>` do item — página do episódio no site do podcast.
  TextColumn get link => text().nullable()();

  /// URL do JSON de capítulos (`<podcast:chapters url="...">`). Quem baixa e
  /// persiste é o `ChapterService`.
  TextColumn get chaptersUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {podcastId, guid};
}

/// Capítulos de um episódio (Fase 14), vindos do JSON apontado por
/// `episodeCache.chaptersUrl` (podcast namespace).
///
/// **Sem FK de propósito**: a fila pode tocar episódio de podcast não
/// assinado, então nem sempre existe linha em `subscriptions`/`episodeCache`
/// pra referenciar. A limpeza é por reescrita, não por cascade.
@DataClassName('ChapterRow')
class Chapters extends Table {
  IntColumn get podcastId => integer()();
  TextColumn get episodeGuid => text()();

  /// Início do capítulo em milissegundos (o JSON traz segundos fracionários).
  IntColumn get startMs => integer()();
  TextColumn get title => text()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {podcastId, episodeGuid, startMs};
}

/// Histórico de escuta agregado por dia (Fase 17). Uma linha por
/// `(podcast, episódio, dia)`: quantos segundos foram ouvidos daquele
/// episódio naquele dia.
///
/// **Sem FK de propósito**: o histórico (e as estatísticas de escuta /
/// streak) sobrevive a desassinar o podcast.
@DataClassName('ListenHistoryRow')
class ListenHistory extends Table {
  IntColumn get podcastId => integer()();
  TextColumn get episodeGuid => text()();

  /// Meia-noite local do dia em que ouviu — agrupa por dia pra streak/semana.
  DateTimeColumn get day => dateTime()();
  IntColumn get secondsListened => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {podcastId, episodeGuid, day};
}

/// Posição de escuta de cada episódio. O schema já existe agora; quem
/// escreve nela é o player, na Fase 4 — a biblioteca vai poder mostrar
/// "continuar ouvindo" assim que isso existir.
///
/// Índice em `(completed, updatedAt)`: `watchContinueListening` filtra por
/// `completed` e ordena por `updatedAt` cruzando todos os podcasts.
@TableIndex(name: 'idx_playback_progress_continue', columns: {#completed, #updatedAt})
@DataClassName('PlaybackProgressRow')
class PlaybackProgress extends Table {
  IntColumn get podcastId => integer().references(Subscriptions, #id, onDelete: KeyAction.cascade)();
  TextColumn get episodeGuid => text()();
  IntColumn get positionSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {podcastId, episodeGuid};
}

/// Fila de reprodução persistente (Fase 12) — cross-podcast, sobrevive ao
/// kill do app. `position` é 0-based e contígua: o `QueueRepository`
/// reescreve todas as linhas a cada mutação (a fila é pequena). O item em
/// `position = 0` é o que está tocando/em foco.
///
/// Dados do episódio/podcast ficam **desnormalizados** de propósito: a fila
/// pode conter episódios de um podcast que não está assinado (tocado direto
/// da busca), e nesse caso não há linha em `episodeCache`/`subscriptions`
/// pra fazer join.
@DataClassName('QueueItemRow')
class QueueItems extends Table {
  IntColumn get position => integer()();
  IntColumn get podcastId => integer()();
  TextColumn get podcastTitle => text()();
  TextColumn get podcastAuthor => text()();
  TextColumn get podcastFeedUrl => text()();
  TextColumn get podcastArtworkUrl => text().nullable()();
  TextColumn get episodeGuid => text()();
  TextColumn get episodeTitle => text()();
  TextColumn get audioUrl => text()();
  TextColumn get episodeImageUrl => text().nullable()();
  IntColumn get episodeDurationSeconds => integer().nullable()();
  DateTimeColumn get episodePublishedAt => dateTime().nullable()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {podcastId, episodeGuid};
}

/// Estado de download de um episódio. Escrito pelo `DownloadService`
/// (Fase 5) a partir dos eventos do `flutter_downloader`. `taskId` é o
/// identificador que o próprio `flutter_downloader` dá à tarefa — é por
/// ele que encontramos a linha certa quando um evento de progresso chega
/// (o evento só traz o `taskId`, não `podcastId`/`episodeGuid`).
///
/// Índice em `taskId`: é assim que todo evento de progresso do
/// `flutter_downloader` encontra a linha (não é a PK).
@TableIndex(name: 'idx_downloads_task_id', columns: {#taskId})
@DataClassName('DownloadRow')
class Downloads extends Table {
  IntColumn get podcastId => integer().references(Subscriptions, #id, onDelete: KeyAction.cascade)();
  TextColumn get episodeGuid => text()();
  TextColumn get taskId => text().nullable()();
  TextColumn get localPath => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('queued'))();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {podcastId, episodeGuid};
}
