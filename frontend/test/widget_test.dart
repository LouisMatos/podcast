import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:podcast_app/app.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

void main() {
  testWidgets('app abre na tela Descobrir com a casca de navegação', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        // Em produção isso vem de `AudioService.init` em main.dart. Nos
        // testes não existe app real rodando pra registrar o serviço, só
        // precisamos de uma instância pra MiniPlayer/PlayerViewModel terem
        // o que observar.
        overrides: [audioHandlerProvider.overrideWithValue(PodcastAudioHandler())],
        child: const PodcastApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Descobrir'), findsWidgets);
    expect(find.text('Biblioteca'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
  });
}
