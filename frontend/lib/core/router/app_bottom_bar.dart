import 'package:flutter/material.dart';

import '../../features/player/view/mini_player.dart';

/// Barra de abas (Início/Descobrir/Biblioteca/Rádio/Ajustes), reutilizada tanto
/// pelo [AppShell] quanto pelas rotas de topo (`/podcast`, `/episode`,
/// `/player`, `/resolve/*`) que cobrem a casca — sem isso essas telas
/// ficavam sem navegação nenhuma.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.showMiniPlayer = true,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool showMiniPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMiniPlayer) const MiniPlayer(),
        NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Descobrir',
            ),
            NavigationDestination(
              icon: Icon(Icons.library_music_outlined),
              selectedIcon: Icon(Icons.library_music),
              label: 'Biblioteca',
            ),
            NavigationDestination(
              icon: Icon(Icons.radio_outlined),
              selectedIcon: Icon(Icons.radio),
              label: 'Rádio',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Ajustes',
            ),
          ],
        ),
      ],
    );
  }
}
