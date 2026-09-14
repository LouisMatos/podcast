import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/query_cache_maintenance.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../services/download/auto_download_service.dart';
import '../../../services/download/download_service.dart';

part 'startup_feed_refresh_provider.g.dart';

/// Dispara um refresh dos feeds assinados quando o app abre (Fase 9).
/// Respeita o throttle por feed (`LibraryRepository.refreshFeed` só rebusca
/// o que está velho). Observado uma vez pela casca (`AppShell`) — o
/// resultado não importa pra UI.
@riverpod
Future<int> startupFeedRefresh(Ref ref) async {
  // Limpeza do cache de busca/listagem (Fase 27) — fire-and-forget, não
  // atrasa nada abaixo nem derruba o boot se falhar.
  unawaited(pruneStaleQueryCache(ref.read(appDatabaseProvider)).catchError((_) => 0));

  // Reconcilia downloads presos em queued/running/paused antes de mais
  // nada — se o app foi morto no meio de um download, essa é a única
  // chance de destravar a tela de Downloads sem intervenção manual.
  await ref.read(downloadServiceProvider).reconcileStuckDownloads();

  // Concorrência menor que o pull-to-refresh (default 4): fire-and-forget no
  // boot, não deve competir por I/O/CPU com o primeiro frame da UI.
  final results = await ref
      .read(libraryRepositoryProvider)
      .refreshAllSubscriptions(concurrency: 2);
  // Gestão automática (Fase 13): auto-download dos recentes + limpeza dos
  // ouvidos. No-op se nenhuma assinatura tem config.
  await ref.read(autoDownloadServiceProvider).run();
  return results.fold<int>(0, (total, r) => total + r.newEpisodes.length);
}
