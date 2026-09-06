import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/discover/view/discover_screen.dart';
import '../../features/library/view/library_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../theme/motion.dart';
import 'app_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/discover',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              pageBuilder: (context, state) => _fadeSlidePage(state, const DiscoverScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              pageBuilder: (context, state) => _fadeSlidePage(state, const LibraryScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => _fadeSlidePage(state, const SettingsScreen()),
            ),
          ],
        ),
      ],
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
