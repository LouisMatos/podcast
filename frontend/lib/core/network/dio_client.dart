import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
/// uma rede ruim não travar a UI por muito tempo.
///
/// `keepAlive`: singleton de app — repositórios `keepAlive` dependem dele
/// (`riverpod_lint: only_use_keep_alive_inside_keep_alive`).
@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
}
