import 'dart:async';

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

/// [Dio.connectTimeout]/[Dio.receiveTimeout] medem o intervalo *entre
/// pacotes*, não o tempo total da requisição — um servidor (ou rota móvel
/// ruim) que entrega dados aos poucos nunca estoura nenhum dos dois, e a
/// requisição trava pra sempre sem lançar erro (nem retry, nem estado de
/// erro pra UI mostrar). Confirmado em device físico: aba Rádio travou 70s+
/// com 0% CPU (bloqueada em I/O) numa rede WiFi saudável.
extension DioDeadline on Dio {
  Future<Response<T>> getWithDeadline<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Duration deadline = const Duration(seconds: 20),
  }) async {
    final cancelToken = CancelToken();
    final timer = Timer(
      deadline,
      () => cancelToken.cancel('prazo total de $deadline excedido'),
    );
    try {
      return await get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } finally {
      timer.cancel();
    }
  }
}
