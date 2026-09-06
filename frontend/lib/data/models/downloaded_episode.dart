import 'package:freezed_annotation/freezed_annotation.dart';

import 'download_status.dart';

part 'downloaded_episode.freezed.dart';

/// Uma linha da tela de Downloads — já vem com título do episódio e do
/// podcast (o `DownloadRepository` faz o join, ninguém mais precisa saber
/// que isso envolve duas tabelas).
@freezed
abstract class DownloadedEpisode with _$DownloadedEpisode {
  const factory DownloadedEpisode({
    required int podcastId,
    required String episodeGuid,
    required String episodeTitle,
    required String podcastTitle,
    String? artworkUrl,
    String? localPath,
    required DownloadStatus status,
    required int progress,
  }) = _DownloadedEpisode;
}
