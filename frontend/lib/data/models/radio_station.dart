import 'package:freezed_annotation/freezed_annotation.dart';

part 'radio_station.freezed.dart';

/// Uma rádio brasileira com transmissão ao vivo (Radio Browser API).
///
/// A tradução do JSON bruto pra este modelo acontece em
/// `data/sources/radio_browser_api.dart` — este arquivo não sabe de onde o
/// dado veio. [programacaoHoje] não existe na Radio Browser API — fica
/// nullable até surgir uma fonte que forneça grade de programação.
@freezed
abstract class RadioStation with _$RadioStation {
  const factory RadioStation({
    required String id,
    required String name,
    required String streamUrl,
    String? logoUrl,
    String? genre,
    String? state,
    String? programacaoHoje,
  }) = _RadioStation;
}
