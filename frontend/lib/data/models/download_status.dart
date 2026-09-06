/// Estado de download de um episódio. Espelha (mas não depende de)
/// `DownloadTaskStatus` do `flutter_downloader` — o resto do app nunca
/// importa esse pacote, só o `DownloadService`.
enum DownloadStatus { queued, running, complete, failed, canceled, paused }
