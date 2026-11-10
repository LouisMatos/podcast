import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/diagnostics/error_log.dart';
import '../../core/network/dio_client.dart';
import '../models/radio_station.dart';

/// Rádios brasileiras com transmissão ao vivo (Radio Browser API, pública,
/// sem chave). Content-type já vem `application/json` — sem o hack de
/// `ResponseType.plain` usado pro iTunes/Apple.
class RadioBrowserApi {
  RadioBrowserApi(this._dio);

  final Dio _dio;

  static const String _baseUrl = 'https://de1.api.radio-browser.info';

  Future<List<RadioStation>> fetchBrStations() async {
    final response = await _dio.getWithDeadline<List<dynamic>>(
      '$_baseUrl/json/stations/bycountrycodeexact/BR',
    );
    final entries = response.data ?? const [];

    final stations = <RadioStation>[];
    for (final entry in entries) {
      if (entry is! Map<String, dynamic>) continue;
      if (entry['lastcheckok'] != 1 || (entry['url_resolved'] as String?)?.isNotEmpty != true) continue;
      final station = _toStation(entry);
      if (station != null) stations.add(station);
    }
    return stations;
  }

  /// `null` se o item vier malformado — um item ruim não pode derrubar a
  /// lista inteira (a Radio Browser API tem entradas com campos ausentes).
  RadioStation? _toStation(Map<String, dynamic> json) {
    final id = json['stationuuid'] as String?;
    final streamUrl = json['url_resolved'] as String?;
    if (id == null || id.isEmpty || streamUrl == null || streamUrl.isEmpty) {
      unawaited(ErrorLog.instance.record(
        'estação sem stationuuid/url_resolved válido: $json',
        StackTrace.current,
        context: 'RadioBrowserApi._toStation',
      ));
      return null;
    }
    return RadioStation(
      id: id,
      name: json['name'] as String? ?? '',
      streamUrl: streamUrl,
      logoUrl: (json['favicon'] as String?)?.isEmpty ?? true ? null : json['favicon'] as String,
      genre: (json['tags'] as String?)?.isEmpty ?? true ? null : json['tags'] as String,
      state: (json['state'] as String?)?.isEmpty ?? true ? null : json['state'] as String,
    );
  }
}
