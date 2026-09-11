import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/library_repository.dart';
import '../../features/library/view_model/startup_feed_refresh_provider.dart';
import '../../features/player/view_model/player_view_model.dart';
import '../../services/shortcuts/app_shortcuts.dart';
import 'app_bottom_bar.dart';
import 'app_router.dart';

/// Casca da navegação: corpo trocado por `StatefulShellRoute.indexedStack`
/// (cada aba mantém seu próprio estado) + mini-player + barra de navegação.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Feeds vivos (Fase 9): ao abrir o app, rebusca os feeds assinados que
    // estão velhos. `listen` só pra instanciar o provider — a UI não depende
    // do resultado.
    ref.listen(startupFeedRefreshProvider, (_, _) {});

    // Fase 16 — deep links (`podcastapp://…` e "abrir feed RSS externo") são
    // resolvidos pelo `redirect` do `appRouter`, não aqui.

    // Fase 16 — app shortcuts (long-press no ícone): "Fila" abre o player
    // (onde fica a fila); "Continuar" retoma o último episódio (mini-player
    // na Início — não força a tela cheia).
    ref.listen(shortcutActionStreamProvider, (_, next) async {
      switch (next.value) {
        case 'fila':
          unawaited(appRouter.push('/player'));
        case 'continuar':
          final items = await ref
              .read(libraryRepositoryProvider)
              .watchContinueListening(limit: 1)
              .first;
          if (items.isEmpty) return;
          final item = items.first;
          await ref
              .read(playerViewModelProvider.notifier)
              .playEpisode(item.podcast, item.episode, autoPlay: true);
      }
    });

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          currentShellTabIndex.value = index;
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
