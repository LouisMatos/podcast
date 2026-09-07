import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../data/repositories/library_repository.dart';
import '../view_model/subscription_settings_provider.dart';

const _speedOptions = [0.8, 1.0, 1.2, 1.5, 1.75, 2.0];
const _deleteDayOptions = [0, 7, 14, 30];

void showSubscriptionSettings(BuildContext context, int podcastId) {
  final colors = Theme.of(context).extension<AppColors>()!;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.surface)),
    ),
    builder: (_) => _SubscriptionSettingsSheet(podcastId: podcastId),
  );
}

class _SubscriptionSettingsSheet extends ConsumerWidget {
  const _SubscriptionSettingsSheet({required this.podcastId});

  final int podcastId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(subscriptionSettingsProvider(podcastId)).value ??
        defaultSubscriptionSettings;
    final repo = ref.read(libraryRepositoryProvider);
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ajustes do podcast', style: text.titleMedium),
            const SizedBox(height: 16),

            Text('Baixar automaticamente', style: text.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<AutoDownloadMode>(
              segments: const [
                ButtonSegment(value: AutoDownloadMode.never, label: Text('Nunca')),
                ButtonSegment(value: AutoDownloadMode.wifi, label: Text('Wi-Fi')),
                ButtonSegment(value: AutoDownloadMode.always, label: Text('Sempre')),
              ],
              selected: {settings.autoDownload},
              onSelectionChanged: (s) =>
                  repo.updateAutoManagement(podcastId, autoDownload: s.first),
            ),

            if (settings.autoDownload != AutoDownloadMode.never) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Text('Manter baixados', style: text.bodyLarge)),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: settings.autoDownloadLimit > 1
                        ? () => repo.updateAutoManagement(podcastId,
                            autoDownloadLimit: settings.autoDownloadLimit - 1)
                        : null,
                  ),
                  Text('${settings.autoDownloadLimit}', style: text.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: settings.autoDownloadLimit < 10
                        ? () => repo.updateAutoManagement(podcastId,
                            autoDownloadLimit: settings.autoDownloadLimit + 1)
                        : null,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),
            Text('Apagar depois de ouvir', style: text.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final days in _deleteDayOptions)
                  ChoiceChip(
                    label: Text(days == 0 ? 'Nunca' : '$days dias'),
                    selected: settings.autoDeletePlayedDays == days,
                    onSelected: (_) =>
                        repo.updateAutoManagement(podcastId, autoDeletePlayedDays: days),
                  ),
              ],
            ),

            const SizedBox(height: 16),
            Text('Velocidade fixa', style: text.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Global'),
                  selected: settings.playbackSpeedOverride == null,
                  onSelected: (_) => repo.setPlaybackSpeedOverride(podcastId, null),
                ),
                for (final speed in _speedOptions)
                  ChoiceChip(
                    label: Text('${speed}x'),
                    selected: settings.playbackSpeedOverride == speed,
                    onSelected: (_) => repo.setPlaybackSpeedOverride(podcastId, speed),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              'Vale só pra este podcast. A limpeza e o download automático '
              'rodam quando o app atualiza os feeds.',
              style: text.bodySmall?.copyWith(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
