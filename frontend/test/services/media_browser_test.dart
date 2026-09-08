import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/services/audio/media_browser.dart';
import 'package:podcast_app/services/audio/media_browser_controller.dart';

void main() {
  group('MediaBrowserIds — episódio', () {
    test('episodeMediaId/parseEpisodeMediaId round-trip com guid tipo URL', () {
      const guid = 'https://exemplo.com/podcast/ep/1?x=2';
      final id = MediaBrowserIds.episodeMediaId(7, guid);

      expect(id, 'ep/7/${Uri.encodeComponent(guid)}');

      final parsed = MediaBrowserIds.parseEpisodeMediaId(id);
      expect(parsed, isNotNull);
      expect(parsed!.podcastId, 7);
      expect(parsed.guid, guid);
    });

    test('parseEpisodeMediaId de string inválida → null', () {
      expect(MediaBrowserIds.parseEpisodeMediaId('sub/7'), isNull);
      expect(MediaBrowserIds.parseEpisodeMediaId('ep/7'), isNull);
      expect(MediaBrowserIds.parseEpisodeMediaId('ep/x/guid'), isNull);
      expect(MediaBrowserIds.parseEpisodeMediaId('root'), isNull);
      expect(MediaBrowserIds.parseEpisodeMediaId('ep/7/a/b'), isNull);
    });
  });

  group('MediaBrowserIds — podcast assinado', () {
    test('subMediaId/parseSubMediaId round-trip', () {
      final id = MediaBrowserIds.subMediaId(99);
      expect(id, 'sub/99');
      expect(MediaBrowserIds.parseSubMediaId(id), 99);
    });

    test('parseSubMediaId de string inválida → null', () {
      expect(MediaBrowserIds.parseSubMediaId('ep/1/g'), isNull);
      expect(MediaBrowserIds.parseSubMediaId('sub/x'), isNull);
      expect(MediaBrowserIds.parseSubMediaId('sub'), isNull);
    });
  });

  test('RepoMediaBrowserSource.getChildren(root) → 4 pastas não-tocáveis', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final source = container.read(mediaBrowserSourceProvider);
    final items = await source.getChildren(MediaBrowserIds.root);

    expect(items.map((i) => i.id), [
      MediaBrowserIds.continueRoot,
      MediaBrowserIds.queue,
      MediaBrowserIds.subs,
      MediaBrowserIds.downloads,
    ]);
    expect(items.every((i) => i.playable == false), isTrue);
  });
}
