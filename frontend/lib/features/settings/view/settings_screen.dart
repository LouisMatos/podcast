import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/soft_card.dart';
import '../view_model/feed_refresh_settings_provider.dart';
import '../view_model/theme_mode_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text('Ajustes', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Aparência'),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tema', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<AppThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: AppThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('Claro'),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('Escuro'),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.system,
                      icon: Icon(Icons.brightness_auto_outlined),
                      label: Text('Sistema'),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (selection) =>
                      ref.read(themeModeProvider.notifier).set(selection.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Atualização'),
          const _FeedRefreshCard(),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Armazenamento'),
          SoftCard(
            onTap: () => context.push('/settings/downloads'),
            child: Row(
              children: [
                Icon(Icons.download_outlined, color: Theme.of(context).extension<AppColors>()!.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Downloads', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        'Episódios baixados pra ouvir offline',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Toggles de refresh em background + notificação de episódio novo (Fase 10).
class _FeedRefreshCard extends ConsumerWidget {
  const _FeedRefreshCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(feedRefreshSettingsProvider);
    final notifier = ref.read(feedRefreshSettingsProvider.notifier);

    return SoftCard(
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Atualizar em segundo plano'),
            subtitle: const Text('Rebusca os feeds assinados a cada ~6h'),
            value: settings.backgroundRefresh,
            onChanged: notifier.setBackgroundRefresh,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Só no Wi-Fi'),
            subtitle: const Text('Não usar dados móveis pra atualizar'),
            value: settings.wifiOnly,
            onChanged: settings.backgroundRefresh ? notifier.setWifiOnly : null,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Avisar de episódio novo'),
            subtitle: const Text('Notificação quando um podcast assinado publica'),
            value: settings.notifications,
            onChanged: settings.backgroundRefresh ? notifier.setNotifications : null,
          ),
        ],
      ),
    );
  }
}
