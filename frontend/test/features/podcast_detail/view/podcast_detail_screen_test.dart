import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_app/core/prefs/preferences_store.dart';
import 'package:podcast_app/core/theme/app_theme.dart';
import 'package:podcast_app/data/models/podcast.dart';
import 'package:podcast_app/data/models/radio_station.dart';
import 'package:podcast_app/data/repositories/queue_repository.dart';
import 'package:podcast_app/data/repositories/radio_repository.dart';
import 'package:podcast_app/features/library/view_model/is_subscribed_provider.dart';
import 'package:podcast_app/features/podcast_detail/view/podcast_detail_screen.dart';
import 'package:podcast_app/features/podcast_detail/view_model/podcast_detail_state.dart';
import 'package:podcast_app/features/podcast_detail/view_model/podcast_detail_view_model.dart';
import 'package:podcast_app/services/audio/podcast_audio_handler.dart';

import '../../../support/fake_preferences.dart';

const _podcast = Podcast(id: 1, title: 'Podcast Teste', author: 'Autor', feedUrl: 'https://x/f.xml');

/// Substitui o build() real (rede + drift) por um erro imediato — sem cache
/// pra cair, é exatamente o caminho que a tela precisa tratar sem perder o
/// header (Fase 4).
class _ThrowingViewModel extends PodcastDetailViewModel {
  @override
  Future<PodcastDetailState> build(Podcast podcast) async {
    throw Exception('sem rede');
  }
}

void main() {
  late PreferencesStore prefs;

  setUp(() async {
    prefs = await fakePreferencesStore();
  });

  Widget wrap(Widget child) {
    return ProviderScope(
      // Riverpod 3 reretenta provider que lança erro (até 10x, backoff até
      // 6.4s) antes de assentar em AsyncError — desliga aqui pro teste não
      // esperar isso, sem afetar o comportamento real do app.
      retry: (retryCount, error) => null,
      overrides: [
        podcastDetailViewModelProvider(_podcast).overrideWith(_ThrowingViewModel.new),
        // Drift real dentro de testWidgets deixa Timer pendente no dispose
        // (CLAUDE.md) — sobrescrever o provider de dado direto, não uma
        // instância de repositório com DB de verdade.
        isSubscribedProvider(_podcast.id).overrideWith((ref) => Stream.value(false)),
        // Setup obrigatório pra montar telas com player (CLAUDE.md) — sem
        // isso, UnimplementedError mascarado de RenderFlex overflow.
        audioHandlerProvider.overrideWithValue(PodcastAudioHandler()),
        preferencesStoreProvider.overrideWithValue(prefs),
        queueProvider.overrideWith((ref) => Stream.value(const <QueueEntry>[])),
        // `AppBottomBar` embute `MiniPlayer` -> `_RadioBar` -> `RadioViewModel`,
        // que carrega estações ao montar — sem stub, bateria rede de verdade.
        radioRepositoryProvider.overrideWithValue(_radioRepoStub()),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: child),
    );
  }

  testWidgets(
    'erro de rede sem cache: header/artwork/subscribe/tabs continuam visíveis '
    '(Fase 4: só a lista de episódios mostra o erro)',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(wrap(const PodcastDetailScreen(podcast: _podcast)));
      await tester.pump();
      await tester.pump();

      // Header (título) e abas continuam de pé — não viraram um EmptyState
      // de tela inteira. Título aparece 2x (AppBar + header).
      expect(find.text('Podcast Teste'), findsWidgets);
      expect(find.text('Episódios'), findsOneWidget);
      expect(find.text('Baixados'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget); // botão de assinar

      // Erro + retry só na área de episódios.
      expect(find.text('Não foi possível carregar os episódios'), findsOneWidget);
      expect(find.text('Tentar de novo'), findsOneWidget);
    },
  );
}

class _MockRadioRepository extends Mock implements RadioRepository {}

RadioRepository _radioRepoStub() {
  final repo = _MockRadioRepository();
  when(() => repo.brStations()).thenAnswer((_) async => const <RadioStation>[]);
  return repo;
}
