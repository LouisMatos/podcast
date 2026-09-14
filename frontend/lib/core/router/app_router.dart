import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/episode.dart';
import '../../data/models/podcast.dart';
import '../../data/models/radio_station.dart';
import '../../features/category/view/category_screen.dart';
import '../../features/deeplink/view/deep_link_resolver_screen.dart';
import '../../features/discover/view/discover_screen.dart';
import '../../features/downloads/view/downloads_screen.dart';
import '../../features/episode_detail/view/episode_detail_screen.dart';
import '../../features/history/view/history_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/library/view/library_screen.dart';
import '../../features/library/view/library_search_screen.dart';
import '../../features/player/view/player_screen.dart';
import '../../features/podcast_detail/view/podcast_detail_screen.dart';
import '../../features/radio/view/radio_detail_screen.dart';
import '../../features/radio/view/radio_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../../features/subscribe_feed/view/subscribe_feed_screen.dart';
import '../../services/deeplinks/deep_link_service.dart';
import '../theme/motion.dart';
import 'app_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Última aba ativa da casca (`AppShell`). Rotas de topo (`/podcast`,
/// `/episode`, `/player`, `/resolve/*`) não têm acesso ao
/// `StatefulNavigationShell` — cobrem a casca numa subárvore diferente —
/// então usam isso pra saber qual aba destacar na própria barra de abas e
/// pra onde voltar ao trocar de aba.
final ValueNotifier<int> currentShellTabIndex = ValueNotifier<int>(0);

const _shellTabPaths = ['/home', '/discover', '/library', '/radio', '/settings'];

void goToShellTab(BuildContext context, int index) {
  currentShellTabIndex.value = index;
  context.go(_shellTabPaths[index]);
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  // Deep links (Fase 16): a plataforma entrega o intent VIEW direto ao
  // go_router como localização crua (`podcastapp://…`, `https://…feed.xml`).
  // Traduz aqui pra rota `/resolve/*`. Localização interna não tem esquema.
  redirect: (context, state) {
    if (state.uri.scheme.isEmpty) return null;
    return locationForDeepLink(parseDeepLink(state.uri));
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => _fadeSlidePage(state, const HomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              pageBuilder: (context, state) => _fadeSlidePage(state, const DiscoverScreen()),
              routes: [
                GoRoute(
                  path: 'category',
                  pageBuilder: (context, state) {
                    final args = state.extra! as ({int id, String label});
                    return _fadeSlidePage(
                      state,
                      CategoryScreen(genreId: args.id, label: args.label),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              pageBuilder: (context, state) => _fadeSlidePage(state, const LibraryScreen()),
              routes: [
                GoRoute(
                  path: 'search',
                  pageBuilder: (context, state) =>
                      _fadeSlidePage(state, const LibrarySearchScreen()),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/radio',
              pageBuilder: (context, state) => _fadeSlidePage(state, const RadioScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => _fadeSlidePage(state, const SettingsScreen()),
              routes: [
                GoRoute(
                  path: 'downloads',
                  pageBuilder: (context, state) => _fadeSlidePage(state, const DownloadsScreen()),
                ),
                GoRoute(
                  path: 'history',
                  pageBuilder: (context, state) => _fadeSlidePage(state, const HistoryScreen()),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Detalhe do podcast — rota de topo (montada em qualquer aba). Cobre a
    // casca e mostra o próprio mini-player, igual `/episode`.
    GoRoute(
      path: '/podcast',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, PodcastDetailScreen(podcast: state.extra! as Podcast)),
    ),
    // Detalhe da rádio — mesmo padrão de `/podcast`.
    GoRoute(
      path: '/radio-detail',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) =>
          _fadeSlidePage(state, RadioDetailScreen(station: state.extra! as RadioStation)),
    ),
    // Player cheio — cobre a tela inteira, aberto do mini-player em qualquer aba.
    GoRoute(
      path: '/player',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _fadeSlidePage(state, const PlayerScreen()),
    ),
    // Descrição do episódio. Cobre a casca (mostra o próprio mini-player),
    // aberta ao selecionar um episódio — sem tocar nada (Fase 8.3).
    GoRoute(
      path: '/episode',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final args = state.extra! as ({Podcast podcast, Episode episode, List<Episode> queue});
        return _fadeSlidePage(
          state,
          EpisodeDetailScreen(podcast: args.podcast, episode: args.episode, queue: args.queue),
        );
      },
    ),
    // Deep links (Fase 16). Cada rota resolve o alvo e faz `pushReplacement`
    // pra tela real. O guid do episódio e a URL do feed vêm na query — guid
    // costuma conter `/` e não casaria como parâmetro de path no go_router.
    GoRoute(
      path: '/resolve/podcast/:id',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? -1;
        return _fadeSlidePage(state, DeepLinkResolverScreen(target: DeepLinkPodcast(id)));
      },
    ),
    GoRoute(
      path: '/resolve/episode/:podcastId',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final podcastId = int.tryParse(state.pathParameters['podcastId'] ?? '') ?? -1;
        final guid = state.uri.queryParameters['guid'] ?? '';
        return _fadeSlidePage(
          state,
          DeepLinkResolverScreen(target: DeepLinkEpisode(podcastId, guid)),
        );
      },
    ),
    GoRoute(
      path: '/resolve/feed',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        return _fadeSlidePage(state, SubscribeFeedScreen(feedUrl: url));
      },
    ),
    // Link mal formado / esquema desconhecido: avisa e volta em vez de cair
    // mudo na Home.
    GoRoute(
      path: '/resolve/invalid',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _fadeSlidePage(
        state,
        const DeepLinkResolverScreen(target: DeepLinkUnknown()),
      ),
    ),
  ],
);

/// Transição padrão de rota do app: fade + slide vertical sutil, lenta.
/// Ver docs/DESIGN_SYSTEM.md.
CustomTransitionPage<void> _fadeSlidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppMotion.page,
    reverseTransitionDuration: AppMotion.page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: AppMotion.enter);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}
