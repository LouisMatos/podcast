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

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache local dos episódios de um podcast assinado. Existe pra biblioteca
/// funcionar offline e como base pro progresso de escuta (Fase 4) e
/// download (Fase 5) — a chave é `(podcastId, guid)` porque um guid de RSS
/// só é único dentro do feed de origem.
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

  @override
  Set<Column> get primaryKey => {podcastId, guid};
}

/// Posição de escuta de cada episódio. O schema já existe agora; quem
/// escreve nela é o player, na Fase 4 — a biblioteca vai poder mostrar
/// "continuar ouvindo" assim que isso existir.
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
