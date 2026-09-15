import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';

/// Camada fina sobre a tabela `QueryCache` (Fase 27), compartilhada por
/// `PodcastRepository` e `RadioRepository` — antes duplicada em cada um.
///
/// Cache-aside: sucesso escreve no cache; falha de rede cai pro último
/// resultado salvo, se houver. Resposta de rede vazia **não** sobrescreve
/// um cache já preenchido — uma API que devolve 200 com lista vazia
/// (falha soft, sem exceção) não pode apagar o fallback offline que o
/// cache existe pra proteger.
class QueryCacheStore {
  QueryCacheStore(this._db);

  final AppDatabase _db;

  Future<List<T>> cacheAside<T>({
    required String key,
    required String category,
    required Future<List<T>> Function() fetch,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final result = await fetch();
      if (result.isNotEmpty) {
        await write(key, category, result, toJson);
      } else {
        final cached = await read(key, fromJson);
        if (cached == null || cached.isEmpty) {
          await write(key, category, result, toJson);
        }
      }
      return result;
    } catch (_) {
      final cached = await read(key, fromJson);
      if (cached != null && cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<void> write<T>(
    String key,
    String category,
    List<T> items,
    Map<String, dynamic> Function(T) toJson,
  ) {
    return _db.into(_db.queryCache).insertOnConflictUpdate(
          QueryCacheCompanion.insert(
            cacheKey: key,
            category: category,
            payloadJson: jsonEncode(items.map(toJson).toList()),
            fetchedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<List<T>?> read<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final row = await (_db.select(_db.queryCache)..where((t) => t.cacheKey.equals(key))).getSingleOrNull();
    if (row == null) return null;
    final decoded = jsonDecode(row.payloadJson) as List<dynamic>;
    return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
