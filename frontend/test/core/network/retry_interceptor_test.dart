import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podcast_app/core/network/retry_interceptor.dart';

/// Adapter na mão (sem `http_mock_adapter`, que não é dep dev): falha as
/// primeiras [failuresBeforeSuccess] chamadas com erro de conexão e depois
/// responde [statusCode]. Conta quantas vezes foi chamado.
class _FlakyAdapter implements HttpClientAdapter {
  _FlakyAdapter({this.failuresBeforeSuccess = 0, this.statusCode = 200});

  final int failuresBeforeSuccess;
  final int statusCode;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    if (calls <= failuresBeforeSuccess) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    }
    return ResponseBody.fromString(
      'ok',
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['text/plain'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWith(_FlakyAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
  dio.httpClientAdapter = adapter;
  // `Random` semeado só pra manter o backoff curto e determinístico no teste.
  dio.interceptors.add(RetryInterceptor(dio, random: Random(1)));
  return dio;
}

void main() {
  test('reenvia após falhas de conexão e conclui com sucesso', () async {
    final adapter = _FlakyAdapter(failuresBeforeSuccess: 2);
    final dio = _dioWith(adapter);

    final response = await dio.get<String>('/search');

    expect(response.statusCode, 200);
    expect(response.data, 'ok');
    expect(adapter.calls, 3); // 1 original + 2 retentativas
  });

  test('desiste após o teto de 3 retentativas e propaga o erro', () async {
    final adapter = _FlakyAdapter(failuresBeforeSuccess: 99);
    final dio = _dioWith(adapter);

    await expectLater(
      dio.get<String>('/search'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.calls, 4); // 1 original + 3 retentativas
  });

  test('erro 400 não é retentado', () async {
    final adapter = _FlakyAdapter(statusCode: 400);
    final dio = _dioWith(adapter);

    await expectLater(
      dio.get<String>('/search'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.calls, 1);
  });

  test('status 503 é retentado', () async {
    final adapter = _FlakyAdapter(statusCode: 503);
    final dio = _dioWith(adapter);

    await expectLater(
      dio.get<String>('/search'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.calls, 4);
  });

  test('conta as tentativas em RequestOptions.extra', () async {
    final adapter = _FlakyAdapter(failuresBeforeSuccess: 1);
    final dio = _dioWith(adapter);

    final response = await dio.get<String>('/search');

    expect(response.requestOptions.extra['retry_attempt'], 1);
  });
}
