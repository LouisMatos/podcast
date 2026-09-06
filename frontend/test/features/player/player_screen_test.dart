import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/theme/app_theme.dart';
import 'package:podcast_app/features/player/view/mini_player.dart';
import 'package:podcast_app/features/player/view/player_screen.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

/// `PodcastAudioHandler()` aqui não toca nada de verdade: seu construtor só
/// cria um `just_audio.AudioPlayer` e assina os próprios streams — nenhum
/// método que bata em platform channel (`setAudioSource`/`play`) é chamado
/// enquanto a tela só observa o estado ocioso.
void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
      overrides: [audioHandlerProvider.overrideWithValue(PodcastAudioHandler())],
      child: MaterialApp(theme: AppTheme.light(), home: child),
    );
  }

  testWidgets('PlayerScreen mostra placeholder quando nada está tocando', (tester) async {
    await tester.pumpWidget(wrap(const PlayerScreen()));
    await tester.pump();

    expect(find.text('Nada tocando'), findsOneWidget);
  });

  testWidgets('MiniPlayer não mostra nenhum controle quando está ocioso', (tester) async {
    await tester.pumpWidget(wrap(const Scaffold(bottomNavigationBar: MiniPlayer())));
    await tester.pump();

    expect(find.byIcon(Icons.play_circle_fill), findsNothing);
    expect(find.byIcon(Icons.pause_circle_filled), findsNothing);
  });
}
