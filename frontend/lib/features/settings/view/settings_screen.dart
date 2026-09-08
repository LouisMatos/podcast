import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../services/battery/battery_optimization.dart';
import '../../../services/opml/opml_import_service.dart';
import '../../../services/opml/opml_service.dart';
import '../../stats/widget/stats_card.dart';
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
          const SectionHeader(title: 'Sua escuta'),
          const StatsCard(),
          const SizedBox(height: 12),
          SoftCard(
            onTap: () => context.push('/settings/history'),
            child: Row(
              children: [
                Icon(Icons.history, color: Theme.of(context).extension<AppColors>()!.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Histórico de escuta', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        'Tudo que você já ouviu',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _BatteryOptimizationCard(),
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
          const SizedBox(height: 24),
          const SectionHeader(title: 'Backup'),
          const _BackupCard(),
        ],
      ),
    );
  }
}

/// Exportar / importar assinaturas em OPML (Fase 17). `ConsumerStatefulWidget`
/// pra ter `context`/estado durante o import com diálogo de progresso.
/// Nada de plugin é tocado no `build` — só nos callbacks.
class _BackupCard extends ConsumerStatefulWidget {
  const _BackupCard();

  @override
  ConsumerState<_BackupCard> createState() => _BackupCardState();
}

class _BackupCardState extends ConsumerState<_BackupCard> {
  bool _busy = false;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _export() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final subs =
          await ref.read(libraryRepositoryProvider).watchSubscriptions().first;
      if (!mounted) return;
      if (subs.isEmpty) {
        _snack('Nada pra exportar');
        return;
      }
      final dir = await getTemporaryDirectory();
      if (!mounted) return;
      final file = File('${dir.path}/podcasts.opml');
      await file.writeAsString(buildOpml(subs));
      if (!mounted) return;
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        text: 'Minhas assinaturas de podcast',
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['opml', 'xml'],
      );
      final path = picked?.files.single.path;
      if (path == null) return;
      final xml = await File(path).readAsString();
      if (!mounted) return;
      final entries = parseOpml(xml);
      if (entries.isEmpty) {
        _snack('Nenhum feed no arquivo');
        return;
      }

      final progress = ValueNotifier<(int, int)>((0, entries.length));
      _showProgressDialog(progress);

      final result = await ref.read(opmlImportServiceProvider).import(
            entries,
            onProgress: (done, total) => progress.value = (done, total),
          );
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      progress.dispose();
      if (!mounted) return;
      _snack(
        '${result.added} assinados, ${result.skipped} já tinha, ${result.failed} falharam',
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showProgressDialog(ValueNotifier<(int, int)> progress) {
    unawaited(showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Importando OPML'),
        content: ValueListenableBuilder<(int, int)>(
          valueListenable: progress,
          builder: (context, value, _) {
            final (done, total) = value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: total == 0 ? null : done / total),
                const SizedBox(height: 12),
                Text('$done de $total'),
              ],
            );
          },
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SoftCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.ios_share, color: colors.primary),
            title: const Text('Exportar assinaturas (OPML)'),
            subtitle: const Text('Compartilha um arquivo com seus feeds'),
            enabled: !_busy,
            onTap: _export,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.file_open_outlined, color: colors.primary),
            title: const Text('Importar OPML'),
            subtitle: const Text('Assina os feeds de um arquivo .opml'),
            enabled: !_busy,
            onTap: _import,
          ),
        ],
      ),
    );
  }
}

/// Prompt de isenção de otimização de bateria (Fase 18). Some quando o app
/// já está isento ou quando não é Android — só aparece quando o sistema
/// ainda pode matar o refresh/download em background.
class _BatteryOptimizationCard extends ConsumerWidget {
  const _BatteryOptimizationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ignored = ref.watch(batteryOptimizationIgnoredProvider);
    // Enquanto carrega (null) ou já isento (true), não mostra nada.
    if (ignored.value != false) return const SizedBox.shrink();

    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Reprodução em segundo plano'),
        SoftCard(
          onTap: () async {
            await ref.read(batteryOptimizationProvider).request();
            ref.invalidate(batteryOptimizationIgnoredProvider);
          },
          child: Row(
            children: [
              Icon(Icons.battery_alert_outlined, color: colors.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Otimização de bateria ativa',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'O Android pode pausar o download e o refresh em segundo '
                      'plano. Toque pra desativar.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
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
