import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/features/stats/stats_format.dart';

void main() {
  group('formatListenDuration', () {
    test('horas e minutos', () {
      expect(
        formatListenDuration(const Duration(hours: 12, minutes: 30)),
        '12h 30min',
      );
    });

    test('só minutos', () {
      expect(formatListenDuration(const Duration(minutes: 45)), '45min');
    });

    test('descarta segundos', () {
      expect(
        formatListenDuration(const Duration(minutes: 3, seconds: 40)),
        '3min',
      );
    });

    test('zero', () {
      expect(formatListenDuration(Duration.zero), '0min');
    });
  });
}
