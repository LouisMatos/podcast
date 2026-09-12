import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../models/radio_station.dart';
import '../sources/radio_browser_api.dart';

part 'radio_repository.g.dart';

/// Esconde a origem das rádios (Radio Browser API) atrás de uma API só —
/// mesmo papel do `PodcastRepository`, um source só, sem lógica extra.
class RadioRepository {
  RadioRepository({required this.api});

  final RadioBrowserApi api;

  Future<List<RadioStation>> brStations() => api.fetchBrStations();
}

/// `keepAlive`: sem estado próprio, mesmo padrão de `podcastRepositoryProvider`.
@Riverpod(keepAlive: true)
RadioRepository radioRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return RadioRepository(api: RadioBrowserApi(dio));
}
