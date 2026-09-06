import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/features/player/view_model/player_state.dart';
import 'package:podcast_app/features/player/view_model/player_view_model.dart';

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

  group('defaults de volume / equalizador', () {
    test('estado inicial', () {
      const s = PlayerState();
      expect(s.volume, 1.0);
      expect(s.equalizerEnabled, isFalse);
      expect(s.equalizerAvailable, isFalse);
      expect(s.equalizerBands, isEmpty);
    });
  });

  group('equalizerPresetGains', () {
    test('flat = tudo zero', () {
      expect(equalizerPresetGains(EqualizerPreset.flat, 5, -15, 15), everyElement(0.0));
    });

    test('grave levanta a primeira banda e abaixa a última', () {
      final g = equalizerPresetGains(EqualizerPreset.grave, 5, -15, 15);
      expect(g.first, greaterThan(0));
      expect(g.last, lessThan(0));
    });

    test('agudo é o espelho: última banda pra cima', () {
      final g = equalizerPresetGains(EqualizerPreset.agudo, 5, -15, 15);
      expect(g.last, greaterThan(0));
      expect(g.first, lessThan(0));
    });

    test('respeita o nº de bandas do device e o limite de dB', () {
      final g = equalizerPresetGains(EqualizerPreset.grave, 3, -6, 6);
      expect(g, hasLength(3));
      expect(g.every((v) => v >= -6 && v <= 6), isTrue);
    });

    test('0 bandas devolve lista vazia', () {
      expect(equalizerPresetGains(EqualizerPreset.voz, 0, -15, 15), isEmpty);
    });
  });
}
