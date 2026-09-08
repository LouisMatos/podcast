/// Formata uma [Duration] de escuta pro jeito curto da tela: "12h 30min",
/// "45min", "3min" (segundos são descartados). Fase 17.
String formatListenDuration(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes % 60;
  if (hours > 0) return '${hours}h ${minutes}min';
  return '${minutes}min';
}
