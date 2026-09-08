import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/episode.dart';
import '../../data/models/podcast.dart';
import '../../data/repositories/library_repository.dart';
import '../../data/repositories/podcast_repository.dart';
import 'opml_service.dart';

part 'opml_import_service.freezed.dart';
part 'opml_import_service.g.dart';

/// Resultado agregado de um import de OPML.
@freezed
abstract class OpmlImportResult with _$OpmlImportResult {
  const factory OpmlImportResult({
    @Default(0) int added,
    @Default(0) int skipped,
    @Default(0) int failed,
    @Default(<String>[]) List<String> failedTitles,
  }) = _OpmlImportResult;
}

/// Normaliza pra comparar duas URLs de feed: sem espaços, sem querystring,
/// sem barra final, minúsculo. (Mesma regra da Fase 16.)
String normalizeFeedUrl(String url) {
  var normalized = url.trim();
  final queryStart = normalized.indexOf('?');
  if (queryStart != -1) normalized = normalized.substring(0, queryStart);
  if (normalized.endsWith('/')) normalized = normalized.substring(0, normalized.length - 1);
  return normalized.toLowerCase();
}

/// Orquestra o import: pra cada entry do OPML, pula se já assinado, senão
/// resolve o [Podcast] (iTunes ou sintético), busca os episódios e assina.
/// Sequencial de propósito — não martela a iTunes nem os feeds.
class OpmlImportService {
  OpmlImportService(this._ref);

  final Ref _ref;

  Future<OpmlImportResult> import(
    List<OpmlEntry> entries, {
    void Function(int done, int total)? onProgress,
  }) async {
    final library = _ref.read(libraryRepositoryProvider);
    final podcasts = _ref.read(podcastRepositoryProvider);

    final subscribed = {
      for (final p in await library.watchSubscriptions().first)
        normalizeFeedUrl(p.feedUrl),
    };

    var result = const OpmlImportResult();
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final wanted = normalizeFeedUrl(entry.feedUrl);
      try {
        if (subscribed.contains(wanted)) {
          result = result.copyWith(skipped: result.skipped + 1);
        } else {
          final podcast = await _resolvePodcast(podcasts, entry, wanted);
          List<Episode> episodes;
          try {
            episodes = await podcasts.episodesFor(podcast);
          } catch (_) {
            episodes = const [];
          }
          await library.subscribe(podcast, episodes);
          subscribed.add(wanted);
          result = result.copyWith(added: result.added + 1);
        }
      } catch (_) {
        result = result.copyWith(
          failed: result.failed + 1,
          failedTitles: [...result.failedTitles, entry.title],
        );
      }
      onProgress?.call(i + 1, entries.length);
    }
    return result;
  }

  /// Casa o feed com um resultado da iTunes (pelo `feedUrl` normalizado) pra
  /// ter o `collectionId` real; se não achar, sintetiza um id derivado da URL.
  Future<Podcast> _resolvePodcast(
    PodcastRepository podcasts,
    OpmlEntry entry,
    String wanted,
  ) async {
    try {
      final results = await podcasts.search(entry.title);
      for (final candidate in results) {
        if (normalizeFeedUrl(candidate.feedUrl) == wanted) return candidate;
      }
    } catch (_) {
      // busca da iTunes falhou — segue pro id sintético
    }
    return Podcast(
      id: entry.feedUrl.hashCode & 0x7fffffff,
      title: entry.title,
      author: '',
      feedUrl: entry.feedUrl,
    );
  }
}

@Riverpod(keepAlive: true)
OpmlImportService opmlImportService(Ref ref) => OpmlImportService(ref);
