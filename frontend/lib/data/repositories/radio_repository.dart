// Named param fica sem o underscore do campo privado (db, não _db) — mais
// legível pra quem chama o construtor — então não dá pra usar initializing
// formal aqui.
// ignore_for_file: prefer_initializing_formals

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/network/dio_client.dart';
import '../models/radio_station.dart';
import '../sources/radio_browser_api.dart';

part 'radio_repository.g.dart';

const _brStationsCacheKey = 'radio_stations:br';

/// Esconde a origem das rádios (Radio Browser API) atrás de uma API só —
/// mesmo papel do `PodcastRepository`, um source só, sem lógica extra.
///
/// Cache-aside via `QueryCache` (Fase 27): sucesso escreve a lista salva;
/// falha de rede cai pro último resultado salvo, se houver.
class RadioRepository {
  RadioRepository({required this.api, required AppDatabase db}) : _db = db;

  final RadioBrowserApi api;
  final AppDatabase _db;

  Future<List<RadioStation>> brStations() async {
    try {
      final result = await api.fetchBrStations();
      await _writeCache(result);
      return result;
    } catch (_) {
      final cached = await cachedBrStations();
      if (cached != null && cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  /// Última lista salva, `null` se nunca buscou.
  Future<List<RadioStation>?> cachedBrStations() async {
    final row = await (_db.select(_db.queryCache)..where((t) => t.cacheKey.equals(_brStationsCacheKey)))
        .getSingleOrNull();
    if (row == null) return null;
    final decoded = jsonDecode(row.payloadJson) as List<dynamic>;
    return decoded.map((e) => _stationFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _writeCache(List<RadioStation> stations) {
    return _db.into(_db.queryCache).insertOnConflictUpdate(
          QueryCacheCompanion.insert(
            cacheKey: _brStationsCacheKey,
            category: 'radio_stations',
            payloadJson: jsonEncode(stations.map(_stationToJson).toList()),
            fetchedAt: Value(DateTime.now()),
          ),
        );
  }
}

Map<String, dynamic> _stationToJson(RadioStation s) => {
      'id': s.id,
      'name': s.name,
      'streamUrl': s.streamUrl,
      'logoUrl': s.logoUrl,
      'genre': s.genre,
      'state': s.state,
      'programacaoHoje': s.programacaoHoje,
    };

RadioStation _stationFromJson(Map<String, dynamic> json) => RadioStation(
      id: json['id'] as String,
      name: json['name'] as String,
      streamUrl: json['streamUrl'] as String,
      logoUrl: json['logoUrl'] as String?,
      genre: json['genre'] as String?,
      state: json['state'] as String?,
      programacaoHoje: json['programacaoHoje'] as String?,
    );

/// `keepAlive`: sem estado próprio, mesmo padrão de `podcastRepositoryProvider`.
@Riverpod(keepAlive: true)
RadioRepository radioRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return RadioRepository(api: RadioBrowserApi(dio), db: ref.watch(appDatabaseProvider));
}
