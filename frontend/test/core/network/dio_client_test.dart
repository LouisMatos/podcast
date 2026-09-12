import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/network/dio_client.dart';

/// Adapter que nunca completa a resposta (simula servidor gotejando dados
/// devagar — nem `connectTimeout` nem `receiveTimeout` disparam nesse caso,
/// já que ambos medem intervalo entre pacotes, não o tempo total). Observa
/// se o `cancelFuture` foi acionado, confirmando que `getWithDeadline`
/// cancelou a requisição ao bater o prazo.
class _HangingAdapter implements HttpClientAdapter {
  bool cancelled = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    unawaited(cancelFuture?.then((_) => cancelled = true));
    // Nunca resolve por conta própria — só sai via cancelamento externo.
    return Completer<ResponseBody>().future;
  }

  @override
  void close({bool force = false}) {}
}

class _InstantAdapter implements HttpClientAdapter {
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    return ResponseBody.fromString(
      'ok',
      200,
      headers: {
        Headers.contentTypeHeader: ['text/plain'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('cancela e lança DioException quando o prazo total estoura', () async {
    final adapter = _HangingAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'))..httpClientAdapter = adapter;

    await expectLater(
      dio.getWithDeadline<String>('/stations', deadline: const Duration(milliseconds: 50)),
      throwsA(isA<DioException>().having((e) => e.type, 'type', DioExceptionType.cancel)),
    );
    expect(adapter.cancelled, isTrue);
  });

  test('resposta rápida não espera o prazo nem é cancelada', () async {
    final adapter = _InstantAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com'))..httpClientAdapter = adapter;

    final response = await dio.getWithDeadline<String>(
      '/stations',
      deadline: const Duration(seconds: 20),
    );

    expect(response.data, 'ok');
    expect(adapter.calls, 1);
  });
}
