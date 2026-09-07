/// Política de download automático de um podcast assinado (Fase 13).
enum AutoDownloadMode {
  never,
  wifi,
  always;

  static AutoDownloadMode fromName(String name) => AutoDownloadMode.values.firstWhere(
        (m) => m.name == name,
        orElse: () => AutoDownloadMode.never,
      );
}

/// Configuração de gestão automática de um podcast. Defaults = nada
/// automático (comportamento pré-Fase 13).
typedef SubscriptionSettings = ({
  AutoDownloadMode autoDownload,
  int autoDownloadLimit,
  int autoDeletePlayedDays,
  double? playbackSpeedOverride,
});

const defaultSubscriptionSettings = (
  autoDownload: AutoDownloadMode.never,
  autoDownloadLimit: 3,
  autoDeletePlayedDays: 0,
  playbackSpeedOverride: null,
);
