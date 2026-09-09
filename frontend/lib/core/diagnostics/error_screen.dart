import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Substitui a tela cinza do Flutter quando um `build` estoura (Fase 19 v3).
/// Autossuficiente de propósito — não depende de `Theme`/`AppColors`, que
/// podem estar indisponíveis no meio de um erro.
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.details});

  final FlutterErrorDetails? details;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: const Color(0xFFFBF7F2),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sentiment_dissatisfied, size: 48, color: Color(0xFF6B6B6B)),
            const SizedBox(height: 16),
            const Text(
              'Algo deu errado nesta tela',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2B2B2B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Volte e tente de novo. Se continuar, reabra o app.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
            ),
            if (kDebugMode && details != null) ...[
              const SizedBox(height: 16),
              Text(
                details!.exceptionAsString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFFB00020)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
