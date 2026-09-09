import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Log local de erros não tratados (Fase 19 v3). **Local-only** — nada sai do
/// device. Um arquivo único, truncado quando passa de [_maxBytes], pra dar uma
/// pista quando o app se comporta mal sem precisar de cabo/logcat.
class ErrorLog {
  ErrorLog._();

  static final ErrorLog instance = ErrorLog._();

  static const _fileName = 'error_log.txt';
  static const _maxBytes = 128 * 1024;

  File? _file;
  bool _initTried = false;

  Future<File?> _resolve() async {
    if (_file != null || _initTried) return _file;
    _initTried = true;
    try {
      final dir = await getApplicationSupportDirectory();
      _file = File('${dir.path}/$_fileName');
    } catch (_) {
      // sem storage: o log vira no-op, o app segue.
    }
    return _file;
  }

  /// Registra um erro. Nunca lança.
  Future<void> record(Object error, StackTrace? stack, {String? context}) async {
    if (kDebugMode) {
      debugPrint('ErrorLog${context != null ? ' [$context]' : ''}: $error');
    }
    try {
      final file = await _resolve();
      if (file == null) return;
      final head = context != null ? '$context: ' : '';
      final entry = '${DateTime.now().toIso8601String()} $head$error\n$stack\n\n';
      await file.writeAsString(entry, mode: FileMode.append, flush: true);
      await _truncateIfNeeded(file);
    } catch (_) {
      // logar erro não pode quebrar o app.
    }
  }

  Future<void> _truncateIfNeeded(File file) async {
    try {
      if (await file.length() <= _maxBytes) return;
      final text = await file.readAsString();
      await file.writeAsString(text.substring(text.length - _maxBytes ~/ 2));
    } catch (_) {}
  }

  /// Conteúdo atual do log (vazio se não houver). Pra uma futura tela de
  /// diagnóstico nos Ajustes.
  Future<String> read() async {
    try {
      final file = await _resolve();
      if (file == null || !await file.exists()) return '';
      return await file.readAsString();
    } catch (_) {
      return '';
    }
  }
}
