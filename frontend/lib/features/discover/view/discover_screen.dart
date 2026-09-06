import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../../../core/widgets/pastel_chip.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/soft_card.dart';

class _MockPodcast {
  const _MockPodcast(this.title, this.author, this.category, this.colorOf);

  final String title;
  final String author;
  final String category;
  final Color Function(AppColors colors) colorOf;
}

const _mockPodcasts = <_MockPodcast>[
  _MockPodcast('Café com Código', 'Estúdio Lavanda', 'Tecnologia', _primary),
  _MockPodcast('Histórias da Cidade', 'Rádio Menta', 'Cultura', _secondary),
  _MockPodcast('Mente Tranquila', 'Bem-Estar Pod', 'Saúde', _accent),
  _MockPodcast('Ciência Sem Filtro', 'Laboratório Aberto', 'Ciência', _primary),
  _MockPodcast('Negócios de Verdade', 'Grupo Pastel', 'Negócios', _secondary),
];

Color _primary(AppColors c) => c.primary;
Color _secondary(AppColors c) => c.secondary;
Color _accent(AppColors c) => c.accent;

/// Tela de descoberta.
///
/// A lista e a busca aqui são mockadas em memória, filtrando localmente —
/// não é o ViewModel real. A busca de verdade (iTunes Search API) entra na
/// Fase 2 com um `DiscoverViewModel` próprio; ver docs/ROADMAP.md.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _query = '';

  List<_MockPodcast> get _filtered {
    if (_query.isEmpty) return _mockPodcasts;
    final query = _query.toLowerCase();
    return _mockPodcasts
        .where((p) => p.title.toLowerCase().contains(query) || p.category.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text('Descobrir', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Encontre seu próximo podcast favorito', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          _SearchField(onChanged: (value) => setState(() => _query = value)),
          const SizedBox(height: 24),
          SectionHeader(title: _query.isEmpty ? 'Em alta' : 'Resultados'),
          AnimatedSwitcher(
            duration: AppMotion.base,
            switchInCurve: AppMotion.enter,
            switchOutCurve: AppMotion.standard,
            child: results.isEmpty
                ? Padding(
                    key: const ValueKey('empty'),
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'Nenhum resultado pra "$_query"',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    key: ValueKey('$_query-${results.length}'),
                    children: [
                      for (final podcast in results) ...[
                        _PodcastTile(podcast: podcast),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Buscar podcast ou categoria',
          hintStyle: TextStyle(color: colors.textMuted),
          prefixIcon: Icon(Icons.search, color: colors.textMuted),
          border: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class _PodcastTile extends StatelessWidget {
  const _PodcastTile({required this.podcast});

  final _MockPodcast podcast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final tint = podcast.colorOf(colors);

    return SoftCard(
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: tint.withValues(alpha: 0.5), borderRadius: AppRadii.smAll),
            child: Icon(Icons.graphic_eq, color: colors.textPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(podcast.title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(podcast.author, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          PastelChip(label: podcast.category, color: tint),
        ],
      ),
    );
  }
}
