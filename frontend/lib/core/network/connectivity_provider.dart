import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Acesso compartilhado ao `connectivity_plus`. `keepAlive` — é um singleton
/// de plataforma.
@Riverpod(keepAlive: true)
Connectivity connectivity(Ref ref) => Connectivity();

/// `true` quando o device não tem nenhuma rede ativa.
bool isOfflineResult(List<ConnectivityResult> results) =>
    results.isEmpty || results.every((r) => r == ConnectivityResult.none);
