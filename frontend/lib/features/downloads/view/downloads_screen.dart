import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../data/models/download_status.dart';
import '../../../data/models/downloaded_episode.dart';
import '../view_model/downloads_view_model.dart';

/// Downloads do usuário: progresso de quem ainda está baixando, uso de
/// espaço e remoção de quem já terminou.
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: SafeArea(
        top: false,
        child: downloads.when(
          loading: () => ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            children: const [
              _DownloadTileSkeleton(),
              SizedBox(height: AppSpacing.sm),
              _DownloadTileSkeleton(),
            ],
          ),
          error: (error, _) => EmptyState(
            icon: Icons.error_outline,
            title: 'Não foi possível carregar seus downloads',
            onRetry: () => ref.invalidate(downloadsViewModelProvider),
          ),
          data: (items) => items.isEmpty
              ? const EmptyState(
                  icon: Icons.download_outlined,
                  title: 'Nenhum download ainda',
                  message: 'Baixe um episódio pra ouvir sem internet.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _DownloadTile(item: items[index]),
                  ),
                ),
        ),
      ),
    );
  }
}

class _DownloadTile extends ConsumerWidget {
  const _DownloadTile({required this.item});

  final DownloadedEpisode item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SoftCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadii.smAll,
            child: item.artworkUrl == null
                ? Container(
                    width: 48,
                    height: 48,
                    color: colors.primary.withValues(alpha: 0.5),
                    child: Icon(Icons.graphic_eq, color: colors.textPrimary),
                  )
                : CachedNetworkImage(
                    imageUrl: item.artworkUrl!,
                    width: 48,
                    height: 48,
                    memCacheWidth: (48 * MediaQuery.devicePixelRatioOf(context)).round(),
                    memCacheHeight: (48 * MediaQuery.devicePixelRatioOf(context)).round(),
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.episodeTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  item.podcastTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                _StatusLine(item: item),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colors.textMuted),
            tooltip: 'Remover',
            onPressed: () => ref.read(downloadsViewModelProvider.notifier).remove(item.podcastId, item.episodeGuid),
          ),
        ],
      ),
    );
  }
}

class _DownloadTileSkeleton extends StatelessWidget {
  const _DownloadTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          const ShimmerBox(width: 48, height: 48, borderRadius: AppRadii.smAll),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(height: 16),
                SizedBox(height: 8),
                ShimmerBox(width: 100, height: 12),
                SizedBox(height: 8),
                ShimmerBox(width: 60, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.item});

  final DownloadedEpisode item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.textMuted);

    return switch (item.status) {
      DownloadStatus.running || DownloadStatus.queued => Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: LinearProgressIndicator(
                  value: item.status == DownloadStatus.queued ? null : item.progress / 100,
                  minHeight: 4,
                  backgroundColor: colors.background,
                  valueColor: AlwaysStoppedAnimation(colors.primary),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('${item.progress}%', style: style),
          ],
        ),
      DownloadStatus.complete => _CompleteLabel(path: item.localPath, style: style),
      DownloadStatus.failed => Text('Falhou', style: style?.copyWith(color: Colors.redAccent)),
      DownloadStatus.canceled => Text('Cancelado', style: style),
      DownloadStatus.paused => Text('Pausado', style: style),
    };
  }
}

class _CompleteLabel extends StatelessWidget {
  const _CompleteLabel({required this.path, required this.style});

  final String? path;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final size = _fileSizeOf(path);
    return Text(size == null ? 'Baixado' : 'Baixado • $size', style: style);
  }

  String? _fileSizeOf(String? path) {
    if (path == null) return null;
    final file = File(path);
    if (!file.existsSync()) return null;
    final bytes = file.lengthSync();
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
