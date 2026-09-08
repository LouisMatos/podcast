import 'package:share_plus/share_plus.dart';

import '../../data/models/episode.dart';
import '../../data/models/podcast.dart';

/// Monta o texto compartilhado de um episódio. Puro e testável — sem
/// dependência de Flutter ou Riverpod.
String buildShareText({
  required String episodeTitle,
  required String podcastTitle,
  String? link,
  Duration? position,
}) {
  final buffer = StringBuffer('$episodeTitle — $podcastTitle');
  if (link != null) buffer.write('\n$link');
  if (position != null && position > Duration.zero) {
    buffer.write('\n(em ${_fmt(position)})');
  }
  return buffer.toString();
}

/// `H:MM:SS` a partir de 1h, senão `M:SS`.
String _fmt(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  final ss = s.toString().padLeft(2, '0');
  if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:$ss';
  return '$m:$ss';
}

/// Abre a folha de compartilhamento do sistema com o episódio. Pode ser
/// chamado direto do `onPressed` de uma View (mesmo padrão de `HapticFeedback`).
Future<void> shareEpisode({
  required Episode episode,
  required Podcast podcast,
  Duration? position,
}) async {
  final text = buildShareText(
    episodeTitle: episode.title,
    podcastTitle: podcast.title,
    link: episode.link ?? podcast.feedUrl,
    position: position,
  );
  await SharePlus.instance.share(ShareParams(text: text));
}
