import 'package:dio/dio.dart';

import '../models/radio_station.dart';

/// Rádios brasileiras com transmissão ao vivo (Radio Browser API, pública,
/// sem chave). Content-type já vem `application/json` — sem o hack de
/// `ResponseType.plain` usado pro iTunes/Apple.
class RadioBrowserApi {
  RadioBrowserApi(this._dio);

  final Dio _dio;

  static const String _baseUrl = 'https://de1.api.radio-browser.info';

  Future<List<RadioStation>> fetchBrStations() async {
    final response = await _dio.get<List<dynamic>>(
      '$_baseUrl/json/stations/bycountrycodeexact/BR',
    );
    final entries = response.data ?? const [];

    return entries
        .cast<Map<String, dynamic>>()
        .where((e) => e['lastcheckok'] == 1 && (e['url_resolved'] as String?)?.isNotEmpty == true)
        .map(_toStation)
        .toList();
  }

  RadioStation _toStation(Map<String, dynamic> json) {
    return RadioStation(
      id: json['stationuuid'] as String,
      name: json['name'] as String? ?? '',
      streamUrl: json['url_resolved'] as String,
      logoUrl: (json['favicon'] as String?)?.isEmpty ?? true ? null : json['favicon'] as String,
      genre: (json['tags'] as String?)?.isEmpty ?? true ? null : json['tags'] as String,
      state: (json['state'] as String?)?.isEmpty ?? true ? null : json['state'] as String,
    );
  }
}
