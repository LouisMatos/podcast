import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:podcast_app/app.dart';

void main() {
  testWidgets('app abre na tela Descobrir com a casca de navegação', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PodcastApp()));
    await tester.pumpAndSettle();

    expect(find.text('Descobrir'), findsWidgets);
    expect(find.text('Biblioteca'), findsOneWidget);
    expect(find.text('Ajustes'), findsOneWidget);
  });
}
