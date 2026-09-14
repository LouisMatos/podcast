import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml/xml.dart';

import '../../../core/network/dio_client.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../data/repositories/podcast_repository.dart';
import '../../../data/sources/rss_feed_parser.dart';
import 'subscribe_feed_state.dart';

part 'subscribe_feed_view_model.g.dart';

/// Fluxo "assinar este feed RSS" — aberto por um deep link `http(s)://…`
/// (intent VIEW de outro app). Lê o feed, tenta casá-lo com um resultado da
/// iTunes (pra ter o `collectionId` real) e, se não achar, sintetiza um
/// [Podcast] com id derivado da URL.
@riverpod
class SubscribeFeedViewModel extends _$SubscribeFeedViewModel {
  @override
  SubscribeFeedState build(String feedUrl) {
    unawaited(_load(feedUrl));
    return const SubscribeFeedState();
  }

  Future<void> _load(String feedUrl) async {
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.getWithDeadline<String>(
        feedUrl,
        options: Options(responseType: ResponseType.plain),
      );
      final xml = response.data ?? '';
      if (xml.isEmpty) {
        state = state.copyWith(isLoading: false, error: 'Feed vazio ou inacessível.');
        return;
      }

      final title = _channelTitle(xml) ?? feedUrl;
      final episodes = parseRssEpisodes(xml);
      final podcast = await _resolvePodcast(feedUrl, title, episodes);

      final subscribed = await ref
          .read(libraryRepositoryProvider)
          .watchIsSubscribed(podcast.id)
          .first;

      state = state.copyWith(
        isLoading: false,
        podcast: podcast,
        episodes: episodes,
        alreadySubscribed: subscribed,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Não foi possível ler este feed.');
    }
  }

  /// Casa o feed com um resultado da iTunes (pelo `feedUrl` normalizado);
  /// se não achar, sintetiza. O id sintético (`hashCode` da URL) nunca bate
  /// com um `collectionId` real — o podcast fica assinado mas sem vínculo
  /// com a iTunes (sem ranking, sem "podcasts parecidos").
  Future<Podcast> _resolvePodcast(String feedUrl, String title, List<Episode> episodes) async {
    final wanted = _normalizeFeedUrl(feedUrl);
    try {
      final results = await ref.read(podcastRepositoryProvider).search(title);
      for (final candidate in results) {
        if (_normalizeFeedUrl(candidate.feedUrl) == wanted) return candidate;
      }
    } catch (_) {
      // busca da iTunes falhou — segue pro id sintético
    }

    return Podcast(
      id: feedUrl.hashCode & 0x7fffffff,
      title: title,
      author: '',
      feedUrl: feedUrl,
      artworkUrl: episodes.map((e) => e.imageUrl).firstWhere((u) => u != null, orElse: () => null),
      episodeCount: episodes.length,
    );
  }

  Future<void> subscribe() async {
    final current = state;
    final podcast = current.podcast;
    if (podcast == null || current.alreadySubscribed) return;
    await ref.read(libraryRepositoryProvider).subscribe(podcast, current.episodes);
    state = state.copyWith(alreadySubscribed: true);
  }
}

/// `<channel><title>` do feed, sem depender do `RssFeedParser` (que não o
/// expõe). Tolerante: XML inválido → `null`.
String? _channelTitle(String xml) {
  try {
    final document = XmlDocument.parse(xml);
    final channel = document.findAllElements('channel').firstOrNull;
    final title = channel?.getElement('title')?.innerText.trim();
    return (title == null || title.isEmpty) ? null : title;
  } on XmlException {
    return null;
  }
}

/// Normaliza pra comparar duas URLs de feed: sem espaços, sem querystring,
/// sem barra final.
String _normalizeFeedUrl(String url) {
  var normalized = url.trim();
  final queryStart = normalized.indexOf('?');
  if (queryStart != -1) normalized = normalized.substring(0, queryStart);
  if (normalized.endsWith('/')) normalized = normalized.substring(0, normalized.length - 1);
  return normalized.toLowerCase();
}
