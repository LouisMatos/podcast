import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'retry_interceptor.dart';

part 'dio_client.g.dart';

/// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
/// uma rede ruim não travar a UI por muito tempo.
///
/// `keepAlive`: singleton de app — repositórios `keepAlive` dependem dele
/// (`riverpod_lint: only_use_keep_alive_inside_keep_alive`).
///
/// [RetryInterceptor] reenvia GETs que caíram por rede instável ou erro
/// transitório do servidor (502/503/504).
@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(RetryInterceptor(dio));
  return dio;
}
