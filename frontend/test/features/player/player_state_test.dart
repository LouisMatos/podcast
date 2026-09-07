import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/data/models/chapter.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/features/player/view_model/player_state.dart';
import 'package:podcast_app/features/player/view_model/player_view_model.dart';

const _ep1 = Episode(guid: '1', title: 'Um', audioUrl: 'https://x.com/1.mp3');
const _ep2 = Episode(guid: '2', title: 'Dois', audioUrl: 'https://x.com/2.mp3');

const _chapters = [
  Chapter(start: Duration.zero, title: 'Intro'),
  Chapter(start: Duration(minutes: 2), title: 'Assunto'),
  Chapter(start: Duration(minutes: 10), title: 'Fim'),
];

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

  group('currentChapterIndex', () {
    test('null sem capítulos', () {
      expect(const PlayerState().currentChapterIndex, isNull);
    });

    test('null antes do primeiro capítulo (posição < start[0] impossível aqui, mas lista vazia)', () {
      const s = PlayerState(position: Duration(seconds: 30));
      expect(s.currentChapterIndex, isNull);
    });

    test('acompanha a posição', () {
      const s0 = PlayerState(chapters: _chapters, position: Duration(seconds: 10));
      const s1 = PlayerState(chapters: _chapters, position: Duration(minutes: 3));
      const s2 = PlayerState(chapters: _chapters, position: Duration(minutes: 42));
      expect(s0.currentChapterIndex, 0);
      expect(s1.currentChapterIndex, 1);
      expect(s2.currentChapterIndex, 2);
      expect(s1.currentChapter?.title, 'Assunto');
    });
  });

  group('hasSleepTimer', () {
    test('off por padrão', () {
      expect(const PlayerState().hasSleepTimer, isFalse);
    });

    test('true nos dois modos', () {
      expect(const PlayerState(sleepTimerMode: SleepTimerMode.duration).hasSleepTimer, isTrue);
      expect(const PlayerState(sleepTimerMode: SleepTimerMode.endOfEpisode).hasSleepTimer, isTrue);
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
