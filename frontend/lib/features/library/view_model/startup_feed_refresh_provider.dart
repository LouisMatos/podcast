import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/library_repository.dart';
import '../../../services/download/auto_download_service.dart';

part 'startup_feed_refresh_provider.g.dart';

/// Dispara um refresh dos feeds assinados quando o app abre (Fase 9).
/// Respeita o throttle por feed (`LibraryRepository.refreshFeed` só rebusca
/// o que está velho). Observado uma vez pela casca (`AppShell`) — o
/// resultado não importa pra UI.
@riverpod
Future<int> startupFeedRefresh(Ref ref) async {
  final results = await ref.read(libraryRepositoryProvider).refreshAllSubscriptions();
  // Gestão automática (Fase 13): auto-download dos recentes + limpeza dos
  // ouvidos. No-op se nenhuma assinatura tem config.
  await ref.read(autoDownloadServiceProvider).run();
  return results.fold<int>(0, (total, r) => total + r.newEpisodes.length);
}
