import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/soft_card.dart';

class _MockSubscription {
  const _MockSubscription(this.title, this.newEpisodes);

  final String title;
  final int newEpisodes;
}

const _mockSubscriptions = <_MockSubscription>[
  _MockSubscription('Café com Código', 2),
  _MockSubscription('Mente Tranquila', 0),
  _MockSubscription('Ciência Sem Filtro', 1),
];

/// Biblioteca do usuário — mockada até a Fase 3, quando as assinaturas
/// passam a vir do SQLite local (drift) via `LibraryRepository`.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (_mockSubscriptions.isEmpty) {
      return const EmptyState(
        icon: Icons.library_music_outlined,
        title: 'Nenhuma assinatura ainda',
        message: 'Podcasts que você assinar aparecem aqui.',
      );
    }

    final colors = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text('Biblioteca', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Seus podcasts assinados', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Assinaturas'),
          for (final sub in _mockSubscriptions) ...[
            SoftCard(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.secondary.withValues(alpha: 0.5),
                      borderRadius: AppRadii.smAll,
                    ),
                    child: Icon(Icons.podcasts, color: colors.textPrimary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(sub.title, style: Theme.of(context).textTheme.titleMedium)),
                  if (sub.newEpisodes > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text(
                        sub.newEpisodes == 1 ? '1 novo' : '${sub.newEpisodes} novos',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.textPrimary),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
