import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battery_optimization.g.dart';

/// Estado da isenção de otimização de bateria do Android. Quando o app NÃO
/// está isento, o sistema pode matar o isolate de refresh em background e
/// pausar downloads. Só Android — no resto é sempre "isento" (no-op).
class BatteryOptimization {
  const BatteryOptimization();

  /// `true` se o app já está fora da otimização de bateria (ou não é Android).
  Future<bool> isIgnoring() async {
    if (!Platform.isAndroid) return true;
    return Permission.ignoreBatteryOptimizations.isGranted;
  }

  /// Abre o diálogo do sistema pedindo a isenção. No-op fora do Android.
  Future<void> request() async {
    if (!Platform.isAndroid) return;
    await Permission.ignoreBatteryOptimizations.request();
  }
}

@Riverpod(keepAlive: true)
BatteryOptimization batteryOptimization(Ref ref) => const BatteryOptimization();

@riverpod
Future<bool> batteryOptimizationIgnored(Ref ref) =>
    ref.watch(batteryOptimizationProvider).isIgnoring();
