import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/sources/rss_feed_parser.dart';

class _MockDio extends Mock implements Dio {}

const _feedUrl = 'https://example.com/feed.xml';

const _sampleRss = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
  <channel>
    <title>Podcast de Teste</title>
    <image><url>https://example.com/capa-podcast.png</url></image>
    <item>
      <title>Episódio 1</title>
      <description><![CDATA[<p>Descrição <b>com</b> HTML.</p>]]></description>
      <guid>ep-1</guid>
      <pubDate>Wed, 15 Jun 2026 19:00:00 +0000</pubDate>
      <itunes:duration>01:02:03</itunes:duration>
      <itunes:image href="https://example.com/capa-ep1.png"/>
      <enclosure url="https://example.com/ep1.mp3" type="audio/mpeg" length="123"/>
    </item>
    <item>
      <title>Episódio sem áudio (deve ser ignorado)</title>
      <guid>ep-sem-audio</guid>
    </item>
    <item>
      <title>Episódio sem imagem própria</title>
      <guid>ep-2</guid>
      <enclosure url="https://example.com/ep2.mp3" type="audio/mpeg" length="456"/>
    </item>
  </channel>
</rss>
''';

/// Feed "completo": metadados avançados da Fase 14 (temporada/número/tipo,
/// `<link>`, `content:encoded` e `<podcast:chapters>`).
const _richRss = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     xmlns:podcast="https://podcastindex.org/namespace/1.0">
  <channel>
    <title>Podcast Completo</title>
    <item>
      <title>Episódio rico</title>
      <link>https://example.com/eps/rico</link>
      <guid>ep-rico</guid>
      <itunes:summary>Resumo curto.</itunes:summary>
      <content:encoded><![CDATA[<p>Show notes <b>bem</b> mais longos que o resumo curto.</p>]]></content:encoded>
      <itunes:season>3</itunes:season>
      <itunes:episode>12</itunes:episode>
      <itunes:episodeType>bonus</itunes:episodeType>
      <podcast:chapters url="https://example.com/eps/rico/chapters.json" type="application/json+chapters"/>
      <enclosure url="https://example.com/rico.mp3" type="audio/mpeg" length="1"/>
    </item>
    <item>
      <title>Episódio simples</title>
      <guid>ep-simples</guid>
      <enclosure url="https://example.com/simples.mp3" type="audio/mpeg" length="1"/>
    </item>
  </channel>
</rss>
''';

/// Mesmo `<podcast:chapters>`, mas com outro prefixo de namespace — o parse
/// casa pelo nome local, não pelo prefixo.
const _oddPrefixRss = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:pi="https://podcastindex.org/namespace/1.0">
  <channel>
    <item>
      <title>Prefixo esquisito</title>
      <guid>ep-prefixo</guid>
      <pi:chapters url="https://example.com/outro/chapters.json"/>
      <enclosure url="https://example.com/prefixo.mp3" type="audio/mpeg" length="1"/>
    </item>
  </channel>
</rss>
''';

void main() {
  late _MockDio dio;
  late RssFeedParser parser;

  setUp(() {
    dio = _MockDio();
    parser = RssFeedParser(dio);
  });

  Future<List<Episode>> fetchWith(String xml) {
    when(() => dio.get<String>(any(), options: any(named: 'options'))).thenAnswer(
      (_) async => Response<String>(data: xml, requestOptions: RequestOptions(path: _feedUrl)),
    );
    return parser.fetchEpisodes(_feedUrl);
  }

  test('extrai guid, título, áudio, duração e data do episódio', () async {
    final episodes = await fetchWith(_sampleRss);
    final ep1 = episodes.firstWhere((e) => e.guid == 'ep-1');

    expect(ep1.title, 'Episódio 1');
    expect(ep1.audioUrl, 'https://example.com/ep1.mp3');
    expect(ep1.duration, const Duration(hours: 1, minutes: 2, seconds: 3));
    expect(ep1.publishedAt, DateTime.utc(2026, 6, 15, 19, 0, 0));
  });

  test('tira as tags HTML da descrição', () async {
    final episodes = await fetchWith(_sampleRss);
    final ep1 = episodes.firstWhere((e) => e.guid == 'ep-1');

    expect(ep1.description, 'Descrição com HTML.');
  });

  test('prefere itunes:image do episódio, cai pra capa do feed quando não tem', () async {
    final episodes = await fetchWith(_sampleRss);

    final ep1 = episodes.firstWhere((e) => e.guid == 'ep-1');
    expect(ep1.imageUrl, 'https://example.com/capa-ep1.png');

    final ep2 = episodes.firstWhere((e) => e.guid == 'ep-2');
    expect(ep2.imageUrl, 'https://example.com/capa-podcast.png');
  });

  test('ignora item sem enclosure (sem áudio pra tocar)', () async {
    final episodes = await fetchWith(_sampleRss);
    expect(episodes.any((e) => e.guid == 'ep-sem-audio'), isFalse);
  });

  test('feed vazio devolve lista vazia', () async {
    when(() => dio.get<String>(any(), options: any(named: 'options'))).thenAnswer(
      (_) async => Response<String>(data: '', requestOptions: RequestOptions(path: _feedUrl)),
    );
    final episodes = await parser.fetchEpisodes(_feedUrl);
    expect(episodes, isEmpty);
  });

  test('data em formato inesperado vira publishedAt nulo, sem derrubar o parse', () async {
    const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"><channel>
  <item>
    <title>Episódio data ruim</title>
    <guid>ep-data-ruim</guid>
    <pubDate>não é uma data</pubDate>
    <enclosure url="https://example.com/ep3.mp3" type="audio/mpeg" length="1"/>
  </item>
</channel></rss>
''';
    final episodes = await fetchWith(xml);
    expect(episodes.single.publishedAt, isNull);
  });

  test('extrai temporada, número, tipo, link e url dos capítulos', () async {
    final episodes = await fetchWith(_richRss);
    final rico = episodes.firstWhere((e) => e.guid == 'ep-rico');

    expect(rico.seasonNumber, 3);
    expect(rico.episodeNumber, 12);
    expect(rico.episodeType, 'bonus');
    expect(rico.link, 'https://example.com/eps/rico');
    expect(rico.chaptersUrl, 'https://example.com/eps/rico/chapters.json');
  });

  test('prefere content:encoded quando é mais longo que o itunes:summary', () async {
    final episodes = await fetchWith(_richRss);
    final rico = episodes.firstWhere((e) => e.guid == 'ep-rico');

    expect(rico.description, 'Show notes bem mais longos que o resumo curto.');
  });

  test('item sem os elementos avançados deixa os campos nulos, sem crash', () async {
    final episodes = await fetchWith(_richRss);
    final simples = episodes.firstWhere((e) => e.guid == 'ep-simples');

    expect(simples.seasonNumber, isNull);
    expect(simples.episodeNumber, isNull);
    // `rss_dart` assumiria "full" aqui; queremos distinguir ausência.
    expect(simples.episodeType, isNull);
    expect(simples.link, isNull);
    expect(simples.chaptersUrl, isNull);
    expect(simples.description, isNull);
  });

  test('feed antigo (sem namespace podcast:) não ganha chaptersUrl', () async {
    final episodes = await fetchWith(_sampleRss);
    expect(episodes.every((e) => e.chaptersUrl == null), isTrue);
    expect(episodes.every((e) => e.episodeType == null), isTrue);
  });

  test('acha os capítulos mesmo com outro prefixo de namespace', () async {
    final episodes = await fetchWith(_oddPrefixRss);
    expect(episodes.single.chaptersUrl, 'https://example.com/outro/chapters.json');
  });
}
