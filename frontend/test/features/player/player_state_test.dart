import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/features/player/view_model/player_state.dart';

const _ep1 = Episode(guid: '1', title: 'Um', audioUrl: 'https://x.com/1.mp3');
const _ep2 = Episode(guid: '2', title: 'Dois', audioUrl: 'https://x.com/2.mp3');

void main() {
  group('isIdle', () {
    test('true no estado inicial (sem episódio)', () {
      expect(const PlayerState().isIdle, isTrue);
    });

    test('false assim que um episódio está definido', () {
      expect(const PlayerState(episode: _ep1).isIdle, isFalse);
    });
  });

  group('hasNextInQueue', () {
    test('false sem episódio atual', () {
      expect(const PlayerState(queue: [_ep1, _ep2]).hasNextInQueue, isFalse);
    });

    test('false quando é o último da fila', () {
      const state = PlayerState(episode: _ep2, queue: [_ep1, _ep2]);
      expect(state.hasNextInQueue, isFalse);
    });

    test('true quando tem episódio depois na fila', () {
      const state = PlayerState(episode: _ep1, queue: [_ep1, _ep2]);
      expect(state.hasNextInQueue, isTrue);
    });

    test('false quando o episódio atual nem está na fila', () {
      const outro = Episode(guid: '3', title: 'Três', audioUrl: 'https://x.com/3.mp3');
      const state = PlayerState(episode: outro, queue: [_ep1, _ep2]);
      expect(state.hasNextInQueue, isFalse);
    });
  });
}
