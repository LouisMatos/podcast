import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/core/theme/app_theme.dart';
import 'package:podcast_app/data/models/radio_station.dart';
import 'package:podcast_app/data/repositories/radio_repository.dart';
import 'package:podcast_app/features/radio/view/radio_screen.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

import '../../../support/fake_preferences.dart';

class _MockRadioRepository extends Mock implements RadioRepository {}

void main() {
  late PreferencesStore prefs;

  setUp(() async {
    prefs = await fakePreferencesStore();
  });

  Widget wrap(Widget child, RadioRepository repo) {
    return ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(PodcastAudioHandler()),
        preferencesStoreProvider.overrideWithValue(prefs),
        radioRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: Scaffold(body: child)),
    );
  }

  testWidgets(
    'abas Todas/Favoritas continuam visíveis e tocáveis durante o loading '
    '(Fase 4: componente independente do skeleton da lista)',
    (tester) async {
      final repo = _MockRadioRepository();
      // `Completer` nunca completado — sem `Timer` de `Future.delayed` que
      // sobreviveria ao dispose e derrubaria o teardown do teste.
      when(() => repo.brStations()).thenAnswer(
        (_) => Completer<List<RadioStation>>().future,
      );
      when(() => repo.cachedBrStations()).thenAnswer((_) async => null);

      await tester.pumpWidget(wrap(const RadioScreen(), repo));
      await tester.pump();

      expect(find.text('Todas'), findsOneWidget);
      expect(find.text('Favoritas'), findsOneWidget);

      // Trocar de aba durante o loading não deve quebrar nem depender da lista.
      await tester.tap(find.text('Favoritas'));
      await tester.pump();
      expect(find.text('Favoritas'), findsOneWidget);
    },
  );

  testWidgets('busca continua editável durante o loading', (tester) async {
    final repo = _MockRadioRepository();
    when(() => repo.brStations()).thenAnswer(
      (_) => Completer<List<RadioStation>>().future,
    );
    when(() => repo.cachedBrStations()).thenAnswer((_) async => null);

    await tester.pumpWidget(wrap(const RadioScreen(), repo));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'jovem');
    await tester.pump();

    expect(find.text('jovem'), findsOneWidget);
  });
}
