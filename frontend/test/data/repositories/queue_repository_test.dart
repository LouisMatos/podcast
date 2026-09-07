import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/database/app_database.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/repositories/queue_repository.dart';

void main() {
  late AppDatabase db;
  late QueueRepository repo;

  const p1 = Podcast(id: 1, title: 'P1', author: 'A', feedUrl: 'https://x/1.xml');
  const p2 = Podcast(id: 2, title: 'P2', author: 'B', feedUrl: 'https://x/2.xml');

  Episode ep(String guid) => Episode(guid: guid, title: guid.toUpperCase(), audioUrl: 'u-$guid');

  List<String> guids(List<QueueEntry> q) => [for (final e in q) e.episode.guid];

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = QueueRepository(db);
  });
  tearDown(() => db.close());

  test('replaceWith + addToEnd mantém ordem e reindexa posição', () async {
    await repo.replaceWith([(podcast: p1, episode: ep('a'))]);
    await repo.addToEnd(p2, ep('b'));
    await repo.addToEnd(p1, ep('c'));

    expect(guids(await repo.currentQueue()), ['a', 'b', 'c']);
  });

  test('addToEnd não duplica episódio já na fila', () async {
    await repo.addToEnd(p1, ep('a'));
    await repo.addToEnd(p1, ep('a'));

    expect(guids(await repo.currentQueue()), ['a']);
  });

  test('playNow põe na frente preservando o resto da fila', () async {
    await repo.replaceWith([
      (podcast: p1, episode: ep('a')),
      (podcast: p1, episode: ep('b')),
    ]);

    await repo.playNow(p2, ep('novo'));
    expect(guids(await repo.currentQueue()), ['novo', 'a', 'b']);

    // já na fila: sobe pra frente, não duplica
    await repo.playNow(p1, ep('b'));
    expect(guids(await repo.currentQueue()), ['b', 'novo', 'a']);
  });

  test('playNextAfter insere logo após o item atual', () async {
    await repo.replaceWith([
      (podcast: p1, episode: ep('atual')),
      (podcast: p1, episode: ep('x')),
    ]);

    await repo.playNextAfter(p2, ep('novo'), 'atual');

    expect(guids(await repo.currentQueue()), ['atual', 'novo', 'x']);
  });

  test('playNextAfter sem item atual vai pra frente', () async {
    await repo.addToEnd(p1, ep('x'));
    await repo.playNextAfter(p1, ep('y'), null);

    expect(guids(await repo.currentQueue()), ['y', 'x']);
  });

  test('move reordena e removeAt tira pela posição', () async {
    await repo.replaceWith([
      (podcast: p1, episode: ep('a')),
      (podcast: p1, episode: ep('b')),
      (podcast: p1, episode: ep('c')),
    ]);

    await repo.move(2, 0);
    expect(guids(await repo.currentQueue()), ['c', 'a', 'b']);

    await repo.removeAt(1);
    expect(guids(await repo.currentQueue()), ['c', 'b']);
  });

  test('removeEpisode tira pelo par (podcastId, guid) — cross-podcast', () async {
    await repo.addToEnd(p1, ep('a'));
    await repo.addToEnd(p2, ep('a')); // mesmo guid, outro podcast

    await repo.removeEpisode(1, 'a');

    final q = await repo.currentQueue();
    expect(q.length, 1);
    expect(q.single.podcast.id, 2);
  });

  test('a fila sobrevive a um "restart" (rehidrata do disco)', () async {
    await repo.replaceWith([
      (podcast: p1, episode: ep('a')),
      (podcast: p2, episode: ep('b')),
    ]);

    // Novo repositório sobre o mesmo banco = reabrir o app.
    final again = QueueRepository(db);
    final q = await again.currentQueue();
    expect(guids(q), ['a', 'b']);
    expect(q.first.podcast.title, 'P1');
  });

  test('watchQueue emite a cada mutação', () async {
    expect(await repo.watchQueue().first, isEmpty);
    await repo.addToEnd(p1, ep('a'));
    expect(guids(await repo.watchQueue().first), ['a']);
  });
}
