import 'package:freezed_annotation/freezed_annotation.dart';

import 'download_status.dart';

part 'download.freezed.dart';

/// Estado de download de UM episódio — usado onde só isso importa (botão
/// de download no episódio, decidir se o player toca o arquivo local).
/// Pra listar todos os downloads com título/podcast, ver [DownloadedEpisode].
@freezed
abstract class Download with _$Download {
  const factory Download({
    required int podcastId,
    required String episodeGuid,
    String? taskId,
    String? localPath,
    @Default(DownloadStatus.queued) DownloadStatus status,
    @Default(0) int progress,
  }) = _Download;
}
