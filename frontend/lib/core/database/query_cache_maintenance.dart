import 'package:drift/drift.dart';

import 'app_database.dart';

/// Remove entradas de `QueryCache` (Fase 27 — cache offline de busca/
/// listagem) mais velhas que [maxAge]. Chamado fire-and-forget no boot
/// (`startupFeedRefreshProvider`) — cache velho só ocupa espaço, ninguém
/// espera por essa limpeza. Devolve quantas linhas foram removidas.
Future<int> pruneStaleQueryCache(AppDatabase db, {Duration maxAge = const Duration(days: 30)}) {
  final cutoff = DateTime.now().subtract(maxAge);
  return (db.delete(db.queryCache)..where((t) => t.fetchedAt.isSmallerThanValue(cutoff))).go();
}
