import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/download_status.dart';
import '../../../data/models/episode.dart';
import '../../../data/models/podcast.dart';
import '../../../services/download/download_service.dart';
import '../view_model/download_status_provider.dart';

/// Botão de download do episódio: baixar, progresso, cancelar ou remover,
/// conforme o estado atual em [downloadStatusProvider]. Usado na lista de
/// episódios do detalhe e na tela de descrição do episódio.
class DownloadButton extends ConsumerWidget {
  const DownloadButton({super.key, required this.podcast, required this.episode});

  final Podcast podcast;
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final download = ref.watch(downloadStatusProvider(podcast.id, episode.guid)).value;
    final service = ref.read(downloadServiceProvider);

    return switch (download?.status) {
      null || DownloadStatus.failed || DownloadStatus.canceled || DownloadStatus.paused => IconButton(
          icon: Icon(Icons.download_outlined, color: colors.textMuted),
          tooltip: 'Baixar',
          onPressed: () => service.download(podcastId: podcast.id, episode: episode),
        ),
      DownloadStatus.queued || DownloadStatus.running => SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: download!.status == DownloadStatus.queued ? null : download.progress / 100,
                strokeWidth: 2.5,
                color: colors.primary,
              ),
              IconButton(
                icon: Icon(Icons.close, size: 16, color: colors.textMuted),
                tooltip: 'Cancelar',
                onPressed: () => service.cancel(podcastId: podcast.id, episodeGuid: episode.guid),
              ),
            ],
          ),
        ),
      DownloadStatus.complete => IconButton(
          icon: Icon(Icons.offline_pin, color: colors.secondary),
          tooltip: 'Baixado — toque pra remover',
          onPressed: () => service.remove(podcastId: podcast.id, episodeGuid: episode.guid),
        ),
    };
  }
}
