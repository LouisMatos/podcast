import 'dart:math';

import 'package:dio/dio.dart';

/// Reenvia requisições GET que falharam por rede instável ou por um erro
/// transitório do servidor. Feito na mão pra não puxar dependência nova.
///
/// - Reenvia em: timeout de conexão/recepção, erro de conexão, ou status
///   502/503/504.
/// - Máx. 3 tentativas extras. Backoff exponencial com jitter:
///   `200ms * 2^tentativa` + `0..200ms`, teto de 5s.
/// - A contagem vive em `RequestOptions.extra['retry_attempt']`.
/// - Só GET (todas as chamadas do app são GET; o resto propaga na hora).
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, {Random? random}) : _random = random ?? Random();

  final Dio _dio;
  final Random _random;

  static const _attemptKey = 'retry_attempt';
  static const _maxAttempts = 3;
  static const _baseDelayMs = 200;
  static const _maxDelayMs = 5000;
  static const _jitterMs = 200;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;

    final canRetry = options.method.toUpperCase() == 'GET' &&
        attempt < _maxAttempts &&
        _isTransient(err);
    if (!canRetry) {
      handler.next(err);
      return;
    }

    options.extra[_attemptKey] = attempt + 1;
    await Future<void>.delayed(_backoff(attempt));

    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  static const _retryableTypes = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionError,
  };

  bool _isTransient(DioException err) {
    if (_retryableTypes.contains(err.type)) return true;
    final status = err.response?.statusCode;
    return status == 502 || status == 503 || status == 504;
  }

  Duration _backoff(int attempt) {
    final exp = _baseDelayMs * (1 << attempt);
    final capped = exp > _maxDelayMs ? _maxDelayMs : exp;
    return Duration(milliseconds: capped + _random.nextInt(_jitterMs));
  }
}
