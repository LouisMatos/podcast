import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/services/share/episode_share.dart';

void main() {
  group('buildShareText', () {
    test('sem link e sem position: só "título — podcast"', () {
      expect(
        buildShareText(episodeTitle: 'Ep 1', podcastTitle: 'Meu Podcast'),
        'Ep 1 — Meu Podcast',
      );
    });

    test('com link acrescenta linha do link', () {
      expect(
        buildShareText(
          episodeTitle: 'Ep 1',
          podcastTitle: 'Meu Podcast',
          link: 'https://exemplo.com/ep/1',
        ),
        'Ep 1 — Meu Podcast\nhttps://exemplo.com/ep/1',
      );
    });

    test('position < 1h formata como M:SS', () {
      expect(
        buildShareText(
          episodeTitle: 'Ep 1',
          podcastTitle: 'Meu Podcast',
          position: const Duration(minutes: 3, seconds: 7),
        ),
        'Ep 1 — Meu Podcast\n(em 3:07)',
      );
    });

    test('position >= 1h formata como H:MM:SS', () {
      expect(
        buildShareText(
          episodeTitle: 'Ep 1',
          podcastTitle: 'Meu Podcast',
          position: const Duration(hours: 1, minutes: 2, seconds: 5),
        ),
        'Ep 1 — Meu Podcast\n(em 1:02:05)',
      );
    });

    test('position zero é omitida', () {
      expect(
        buildShareText(
          episodeTitle: 'Ep 1',
          podcastTitle: 'Meu Podcast',
          position: Duration.zero,
        ),
        'Ep 1 — Meu Podcast',
      );
    });

    test('link + position juntos: as duas linhas, nessa ordem', () {
      expect(
        buildShareText(
          episodeTitle: 'Ep 1',
          podcastTitle: 'Meu Podcast',
          link: 'https://exemplo.com/ep/1',
          position: const Duration(minutes: 12, seconds: 40),
        ),
        'Ep 1 — Meu Podcast\nhttps://exemplo.com/ep/1\n(em 12:40)',
      );
    });
  });
}
