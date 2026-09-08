import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'pill_button.dart';

/// Estado vazio ou de erro, ilustrado — usado quando uma lista não tem
/// nada pra mostrar, ou quando algo falhou. Passe [onRetry] pra oferecer
/// "tentar de novo" (erros de rede/leitura quase sempre merecem).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel = 'Tentar de novo',
  });

  /// Variante padrão de "sem internet" — mesma ilustração em toda tela que
  /// depende de rede. Passe [onRetry] pra oferecer "tentar de novo".
  const EmptyState.offline({
    super.key,
    this.onRetry,
    this.retryLabel = 'Tentar de novo',
  })  : icon = Icons.wifi_off,
        title = 'Sem conexão',
        message = 'Verifique a internet e tente de novo.';

  final IconData icon;
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.textMuted),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            if (message case final msg?) ...[
              const SizedBox(height: 8),
              Text(msg, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            ],
            if (onRetry case final retry?) ...[
              const SizedBox(height: 20),
              PillButton(label: retryLabel, icon: Icons.refresh, variant: PillButtonVariant.secondary, onPressed: retry),
            ],
          ],
        ),
      ),
    );
  }
}
