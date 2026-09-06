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
