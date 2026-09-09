import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/services/deeplinks/deep_link_service.dart';

void main() {
  group('parseDeepLink', () {
    test('podcastapp://podcast/<id> numérico vira DeepLinkPodcast', () {
      expect(
        parseDeepLink(Uri.parse('podcastapp://podcast/123')),
        const DeepLinkPodcast(123),
      );
    });

    test('podcastapp://podcast/<id> não-numérico vira DeepLinkUnknown', () {
      expect(
        parseDeepLink(Uri.parse('podcastapp://podcast/abc')),
        const DeepLinkUnknown(),
      );
    });

    test('podcastapp://podcast sem id vira DeepLinkUnknown', () {
      expect(
        parseDeepLink(Uri.parse('podcastapp://podcast')),
        const DeepLinkUnknown(),
      );
    });

    test('podcastapp://episode/<podcastId>/<guid> simples', () {
      expect(
        parseDeepLink(Uri.parse('podcastapp://episode/42/guid-simples')),
        const DeepLinkEpisode(42, 'guid-simples'),
      );
    });

    test('guid url-encodado (guid é uma URL) é decodificado', () {
      final uri = Uri.parse(
        'podcastapp://episode/42/https%3A%2F%2Fexemplo.com%2Fep%2F1',
      );
      expect(
        parseDeepLink(uri),
        const DeepLinkEpisode(42, 'https://exemplo.com/ep/1'),
      );
    });

    test('guid com barras literais no path é remontado', () {
      expect(
        parseDeepLink(Uri.parse('podcastapp://episode/42/a/b/c')),
        const DeepLinkEpisode(42, 'a/b/c'),
      );
    });

    test('episode com podcastId não-numérico vira DeepLinkUnknown', () {
      expect(
        parseDeepLink(Uri.parse('podcastapp://episode/x/guid')),
        const DeepLinkUnknown(),
      );
    });

    test('episode sem guid vira DeepLinkUnknown', () {
      expect(
        parseDeepLink(Uri.parse('podcastapp://episode/42')),
        const DeepLinkUnknown(),
      );
    });

    test('host desconhecido no scheme podcastapp vira DeepLinkUnknown', () {
      expect(
        parseDeepLink(Uri.parse('podcastapp://coisa/42')),
        const DeepLinkUnknown(),
      );
    });

    test('http/https/content/file viram DeepLinkFeed com a uri inteira', () {
      for (final url in const [
        'https://exemplo.com/feed.xml',
        'http://exemplo.com/rss',
        'content://com.app/documento/1',
        'file:///sdcard/feed.xml',
      ]) {
        expect(parseDeepLink(Uri.parse(url)), DeepLinkFeed(url));
      }
    });

    test('scheme desconhecido vira DeepLinkUnknown', () {
      expect(
        parseDeepLink(Uri.parse('mailto:alguem@exemplo.com')),
        const DeepLinkUnknown(),
      );
    });

    test('guid que decodifica pra um % solto não lança — vira DeepLinkUnknown (Fase 22 v3)', () {
      // pathSegments já vem decodificado ("50% off"); o decodeComponent extra
      // veria um % sem par hex e lançava ArgumentError.
      expect(
        parseDeepLink(Uri.parse('podcastapp://episode/42/50%25%20off')),
        const DeepLinkUnknown(),
      );
    });
  });

  group('locationForDeepLink (round-trip via parseDeepLink)', () {
    String loc(String uri) => locationForDeepLink(parseDeepLink(Uri.parse(uri)));

    test('podcast → /resolve/podcast/<id>', () {
      expect(loc('podcastapp://podcast/123'), '/resolve/podcast/123');
    });

    test('episode → /resolve/episode/<id>?guid=<encoded>', () {
      expect(
        loc('podcastapp://episode/42/guid-simples'),
        '/resolve/episode/42?guid=guid-simples',
      );
    });

    test('episode com guid-URL encoda o guid no query', () {
      expect(
        loc('podcastapp://episode/42/https%3A%2F%2Fexemplo.com%2Fep%2F1'),
        Uri(
          path: '/resolve/episode/42',
          queryParameters: {'guid': 'https://exemplo.com/ep/1'},
        ).toString(),
      );
    });

    test('feed → /resolve/feed?url=<encoded>', () {
      expect(
        loc('https://exemplo.com/feed.xml'),
        Uri(
          path: '/resolve/feed',
          queryParameters: {'url': 'https://exemplo.com/feed.xml'},
        ).toString(),
      );
    });

    test('unknown → /resolve/invalid (Fase 22 v3 — antes ia mudo pra /home)', () {
      expect(loc('mailto:alguem@exemplo.com'), '/resolve/invalid');
    });
  });
}
