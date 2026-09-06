import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// Cliente HTTP compartilhado por toda busca/feed do app. Timeout curto pra
/// uma rede ruim não travar a UI por muito tempo.
@riverpod
Dio dioClient(Ref ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
}
