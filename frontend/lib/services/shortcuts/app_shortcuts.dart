import 'dart:async';

import 'package:quick_actions/quick_actions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_shortcuts.g.dart';

/// Atalhos de tela inicial (long-press no ícone do app). Único ponto que
/// fala com `quick_actions`. Não navega — só expõe o `type` do atalho tocado
/// num stream; o integrador escuta no AppShell e decide a rota.
class AppShortcuts {
  AppShortcuts([QuickActions? quickActions])
    : _quickActions = quickActions ?? const QuickActions();

  final QuickActions _quickActions;
  final _controller = StreamController<String>.broadcast();

  /// Atalho recebido antes de haver um ouvinte (cold start dispara durante
  /// `register()`, antes do AppShell montar). `broadcast()` não bufferiza —
  /// o `actions` reentrega isto na primeira inscrição.
  String? _pending;

  /// `type` do atalho tocado pelo usuário. Emite o pendente (se houver) antes
  /// do stream ao vivo.
  Stream<String> get actions async* {
    final pending = _pending;
    if (pending != null) {
      _pending = null;
      yield pending;
    }
    yield* _controller.stream;
  }

  /// Cold start entrega o mesmo atalho duas vezes (`getLaunchAction()` no
  /// `initialize` + `onNewIntent` no attach da Activity). Descarta a repetição
  /// imediata.
  ({String type, DateTime at})? _last;

  /// Registra o handler e os itens. Sem ícone: no Android exigiria um
  /// recurso drawable nativo, que não temos.
  void register() {
    _quickActions.initialize((type) {
      final now = DateTime.now();
      final last = _last;
      if (last != null && last.type == type && now.difference(last.at).inSeconds < 2) {
        return;
      }
      _last = (type: type, at: now);
      _pending = type;
      if (!_controller.isClosed) _controller.add(type);
    });
    _quickActions.setShortcutItems(const [
      ShortcutItem(type: 'continuar', localizedTitle: 'Continuar'),
      ShortcutItem(type: 'fila', localizedTitle: 'Fila'),
    ]);
  }

  void dispose() => _controller.close();
}

/// Sobrescrito com uma instância já `register()`-ada em `main.dart` — o
/// `quick_actions` precisa registrar o handler Pigeon **antes** do `runApp`,
/// senão o atalho de cold start (entregue no attach da Activity) se perde.
@Riverpod(keepAlive: true)
AppShortcuts appShortcuts(Ref ref) {
  throw UnimplementedError('appShortcutsProvider precisa de overrideWithValue em main.dart');
}

@Riverpod(keepAlive: true)
Stream<String> shortcutActionStream(Ref ref) =>
    ref.watch(appShortcutsProvider).actions;
