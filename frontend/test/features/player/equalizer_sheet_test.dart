import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/theme/app_theme.dart';
import 'package:podcast_app/data/models/episode.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/features/player/view/player_screen.dart';
import 'package:podcast_app/features/player/view_model/player_state.dart';
import 'package:podcast_app/features/player/view_model/player_view_model.dart';

/// `_EqualizerSheet` é privado — o teste chega nele pela árvore: monta o
/// `PlayerScreen` com um `PlayerViewModel` de estado fixo, toca no botão de
/// áudio (`Icons.tune`) e inspeciona o sheet. O `build` do ViewModel é
/// substituído por um estado estático (sem streams, sem `_ticker`), então
/// nada bate em platform channel e não sobra timer pendente.
class _FakePlayerViewModel extends PlayerViewModel {
  _FakePlayerViewModel(this._initial);

  final PlayerState _initial;
  final List<bool> toggleEqualizerCalls = [];
  final List<EqualizerPreset> presetCalls = [];
  final List<({int index, double gain})> bandCalls = [];

  @override
  PlayerState build() => _initial;

  @override
  Future<void> toggleEqualizer(bool enabled) async {
    toggleEqualizerCalls.add(enabled);
    state = state.copyWith(equalizerEnabled: enabled);
  }

  @override
  Future<void> applyEqualizerPreset(EqualizerPreset preset) async {
    presetCalls.add(preset);
  }

  @override
  Future<void> setEqualizerBand(int index, double gain) async {
    bandCalls.add((index: index, gain: gain));
  }

  @override
  Future<void> setSkipSilence(bool enabled) async {
    state = state.copyWith(skipSilenceEnabled: enabled);
  }

  @override
  Future<void> setVolumeBoostEnabled(bool enabled) async {
    state = state.copyWith(volumeBoostEnabled: enabled);
  }

  @override
  Future<void> setVolumeBoostGain(double gainDb) async {
    state = state.copyWith(volumeBoostGainDb: gainDb);
  }
}

const _podcast = Podcast(id: 1, title: 'P', author: 'A', feedUrl: 'https://x/f.xml');
const _episode = Episode(guid: 'g1', title: 'E1', audioUrl: 'https://x/e.mp3');

const _bands = <EqualizerBand>[
  (index: 0, centerHz: 60, gain: 0),
  (index: 1, centerHz: 230, gain: 2),
  (index: 2, centerHz: 910, gain: -1),
];

/// Só as bandas do sheet (o `PlayerView` por baixo tem o slider da barra de
/// progresso — fora do `BottomSheet`).
Finder _sheetSliders() => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(Slider),
    );

Finder _equalizerSwitch() => find.descendant(
      of: find.widgetWithText(Row, 'Equalizador'),
      matching: find.byType(Switch),
    );

void main() {
  Future<_FakePlayerViewModel> openSheet(WidgetTester tester, PlayerState state) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final vm = _FakePlayerViewModel(state);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [playerViewModelProvider.overrideWith(() => vm)],
        child: MaterialApp(theme: AppTheme.light(), home: const PlayerScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    return vm;
  }

  testWidgets('sem áudio tocando: mostra o aviso e nenhum slider/preset', (tester) async {
    await openSheet(
      tester,
      const PlayerState(podcast: _podcast, episode: _episode, queue: [_episode]),
    );

    expect(find.text('Toque um episódio pra ajustar o equalizador.'), findsOneWidget);
    expect(_sheetSliders(), findsNothing);
    expect(find.byType(ActionChip), findsNothing);
  });

  testWidgets('com bandas: um slider por banda + presets Flat/Voz/Grave/Agudo', (tester) async {
    await openSheet(
      tester,
      const PlayerState(
        podcast: _podcast,
        episode: _episode,
        queue: [_episode],
        equalizerAvailable: true,
        equalizerEnabled: true,
        equalizerMinDb: -15,
        equalizerMaxDb: 15,
        equalizerBands: _bands,
      ),
    );

    expect(find.text('Toque um episódio pra ajustar o equalizador.'), findsNothing);
    expect(_sheetSliders(), findsNWidgets(_bands.length));
    for (final label in ['Flat', 'Voz', 'Grave', 'Agudo']) {
      expect(find.widgetWithText(ActionChip, label), findsOneWidget);
    }
  });

  testWidgets('o Switch "Equalizador" chama toggleEqualizer', (tester) async {
    final vm = await openSheet(
      tester,
      const PlayerState(
        podcast: _podcast,
        episode: _episode,
        queue: [_episode],
        equalizerAvailable: true,
        equalizerEnabled: true,
        equalizerMinDb: -15,
        equalizerMaxDb: 15,
        equalizerBands: _bands,
      ),
    );

    expect(_equalizerSwitch(), findsOneWidget);
    await tester.tap(_equalizerSwitch());
    await tester.pump();

    expect(vm.toggleEqualizerCalls, [false]);
  });

  testWidgets('presets e sliders desabilitados quando equalizerEnabled == false', (tester) async {
    await openSheet(
      tester,
      const PlayerState(
        podcast: _podcast,
        episode: _episode,
        queue: [_episode],
        equalizerAvailable: true,
        equalizerEnabled: false,
        equalizerMinDb: -15,
        equalizerMaxDb: 15,
        equalizerBands: _bands,
      ),
    );

    final flat = tester.widget<ActionChip>(find.widgetWithText(ActionChip, 'Flat'));
    expect(flat.onPressed, isNull);

    final firstBandSlider = tester.widget<Slider>(_sheetSliders().first);
    expect(firstBandSlider.onChanged, isNull);
  });
}
