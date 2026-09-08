import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/motion.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../data/models/episode.dart';
import '../../../services/share/episode_share.dart';
import '../view_model/player_state.dart';
import '../view_model/player_view_model.dart';

const _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0];
const _sleepOptions = [
  Duration(minutes: 5),
  Duration(minutes: 15),
  Duration(minutes: 30),
  Duration(minutes: 60),
];

/// Valor do item "fim do episódio" no menu do temporizador (o resto são
/// `Duration`; `null` = cancelar).
const _sleepEndOfEpisode = 'end';

String _formatClock(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

/// Duração falada por extenso, pra leitor de tela ("12 minutos e 30 segundos").
/// O `mm:ss` visual é ambíguo pro TalkBack.
String _spokenDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  final parts = <String>[
    if (h > 0) '$h ${h == 1 ? 'hora' : 'horas'}',
    if (m > 0) '$m ${m == 1 ? 'minuto' : 'minutos'}',
    if (h == 0 && s > 0) '$s ${s == 1 ? 'segundo' : 'segundos'}',
  ];
  return parts.isEmpty ? 'zero' : parts.join(' e ');
}

/// Player em tela cheia. Aberto a partir do mini-player, em qualquer aba —
/// por isso mora numa rota de topo (`/player`), usada em deep link / Android
/// Auto. No uso normal o player abre como sheet arrastável (`showPlayerSheet`).
class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: SafeArea(child: PlayerView()));
  }
}

/// Corpo do player, sem `Scaffold`. Renderizado tanto pela rota `/player`
/// (`PlayerScreen`) quanto pelo sheet arrastável (`showPlayerSheet`).
class PlayerView extends ConsumerWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerViewModelProvider);
    final notifier = ref.read(playerViewModelProvider.notifier);
    final colors = Theme.of(context).extension<AppColors>()!;

    if (player.isIdle) {
      // Não deveria acontecer (só se navegar direto pra rota sem nada
      // tocando), mas evita crash se acontecer.
      return const Center(child: Text('Nada tocando'));
    }

    final episode = player.episode!;
    final podcast = player.podcast;
    final artUrl = episode.imageUrl ?? podcast?.artworkUrl;

    return Column(
      children: [
        _PlayerTopBar(state: player, notifier: notifier),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        Hero(
                          tag: 'podcast-artwork-${podcast?.id}',
                          // Capa decorativa: o título do episódio é lido logo
                          // abaixo — não repetir no leitor de tela.
                          child: ExcludeSemantics(
                            child: ClipRRect(
                              borderRadius: AppRadii.surfaceAll,
                              child: artUrl == null
                                  ? Container(
                                      width: 260,
                                      height: 260,
                                      color: colors.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                      child: Icon(
                                        Icons.graphic_eq,
                                        size: 64,
                                        color: colors.textPrimary,
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: artUrl,
                                      width: 260,
                                      height: 260,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          episode.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          podcast?.title ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 24),
                        _SeekBar(player: player, onSeek: notifier.seek),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10),
                              iconSize: 28,
                              tooltip: 'Voltar 15 segundos',
                              onPressed: () => notifier.skipBackward(
                                const Duration(seconds: 15),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                player.isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                              ),
                              iconSize: 72,
                              color: colors.primary,
                              tooltip: player.isPlaying ? 'Pausar' : 'Tocar',
                              onPressed: player.isBuffering
                                  ? null
                                  : notifier.togglePlayPause,
                            ),
                            IconButton(
                              icon: const Icon(Icons.forward_30),
                              iconSize: 28,
                              tooltip: 'Avançar 30 segundos',
                              onPressed: () => notifier.skipForward(
                                const Duration(seconds: 30),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.volume_down,
                              color: colors.textMuted,
                              size: 20,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context)
                                    .copyWith(trackHeight: 3),
                                child: Slider(
                                  value: player.volume.clamp(0.0, 1.0),
                                  label: 'Volume',
                                  semanticFormatterCallback: (v) =>
                                      'Volume: ${(v * 100).round()}%',
                                  onChanged: notifier.setVolume,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.volume_up,
                              color: colors.textMuted,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SpeedButton(
                              speed: player.speed,
                              onChanged: notifier.setSpeed,
                            ),
                            if (player.hasNextInQueue) ...[
                              const SizedBox(width: 12),
                              PillButton(
                                label: 'Próximo',
                                icon: Icons.skip_next,
                                variant: PillButtonVariant.ghost,
                                onPressed: notifier.playNextInQueue,
                              ),
                            ],
                          ],
                        ),
                        if (player.chapters.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _ChapterStrip(state: player, notifier: notifier),
                        ],
                        if (player.hasSleepTimer) ...[
                          const SizedBox(height: 8),
                          Text(
                            player.sleepTimerMode == SleepTimerMode.endOfEpisode
                                ? 'Dormir no fim do episódio · agite para +5 min'
                                : 'Dormir em ${_formatClock(player.sleepTimerRemaining ?? Duration.zero)} · agite para +5 min',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colors.textMuted),
                          ),
                        ],
                        if (player.queue.length > 1) ...[
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => _showQueueSheet(context),
                            child: Text(
                              'A seguir: ${player.queue[1].title}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: colors.textMuted),
                            ),
                          ),
                        ],
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Barra de topo do player (não é `AppBar` — o player vive num sheet).
class _PlayerTopBar extends StatelessWidget {
  const _PlayerTopBar({required this.state, required this.notifier});

  final PlayerState state;
  final PlayerViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            tooltip: 'Fechar',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Text(
              state.podcast?.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: state.queue.length > 1,
              label: Text('${state.queue.length - 1}'),
              child: const Icon(Icons.queue_music),
            ),
            tooltip: 'Fila',
            onPressed: () => _showQueueSheet(context),
          ),
          if (state.episode case final episode? when state.podcast != null)
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: 'Compartilhar',
              onPressed: () => shareEpisode(
                episode: episode,
                podcast: state.podcast!,
                position: state.position,
              ),
            ),
          if (state.chapters.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.list_alt),
              tooltip: 'Capítulos',
              onPressed: () => _showChaptersSheet(context),
            ),
          if (defaultTargetPlatform == TargetPlatform.android)
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: 'Áudio',
              onPressed: () => _showEqualizerSheet(context),
            ),
          _SleepTimerButton(state: state, notifier: notifier),
        ],
      ),
    );
  }
}

class _SeekBar extends StatelessWidget {
  const _SeekBar({required this.player, required this.onSeek});

  final PlayerState player;
  final ValueChanged<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    final duration = player.duration ?? Duration.zero;
    final maxMs = duration.inMilliseconds.toDouble();
    final valueMs = player.position.inMilliseconds.toDouble().clamp(
      0.0,
      maxMs <= 0 ? 1.0 : maxMs,
    );

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(trackHeight: 3),
          child: Slider(
            min: 0,
            max: maxMs <= 0 ? 1.0 : maxMs,
            value: valueMs,
            label: 'Posição',
            semanticFormatterCallback: (v) =>
                'Posição: ${_spokenDuration(Duration(milliseconds: v.round()))} '
                'de ${_spokenDuration(duration)}',
            onChanged: maxMs <= 0
                ? null
                : (v) => onSeek(Duration(milliseconds: v.round())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedSwitcher(
                duration: AppMotion.effective(context, AppMotion.fast),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: Text(
                  _format(player.position),
                  key: ValueKey(_format(player.position)),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                _format(duration),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}

class _SpeedButton extends StatelessWidget {
  const _SpeedButton({required this.speed, required this.onChanged});

  final double speed;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      initialValue: speed,
      tooltip: 'Velocidade de reprodução',
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final s in _speeds) PopupMenuItem(value: s, child: Text('${s}x')),
      ],
      child: PillButton(
        label: '${speed}x',
        icon: Icons.speed,
        variant: PillButtonVariant.ghost,
        onPressed: null,
      ),
    );
  }
}

void _showQueueSheet(BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadii.surface),
      ),
    ),
    builder: (_) => const _QueueSheet(),
  );
}

/// Fila do player: item atual fixo no topo, "a seguir" reordenável e
/// removível (Fase 12).
class _QueueSheet extends ConsumerWidget {
  const _QueueSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerViewModelProvider);
    final notifier = ref.read(playerViewModelProvider.notifier);
    final colors = Theme.of(context).extension<AppColors>()!;
    final queue = player.queue;
    final upcoming = queue.length > 1 ? queue.sublist(1) : const <Episode>[];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fila', style: Theme.of(context).textTheme.titleMedium),
                if (upcoming.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      notifier.clearQueue();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Limpar'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (queue.isNotEmpty)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.play_arrow, color: colors.primary),
                title: Text(
                  queue.first.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Text(
                  'Tocando agora',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            if (upcoming.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Nada na fila. Use "Adicionar à fila" num episódio.',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: colors.textMuted),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Flexible(
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  buildDefaultDragHandles: true,
                  itemCount: upcoming.length,
                  // +1: índice 0 da fila é o item atual, fora desta lista.
                  // `onReorderItem` já entrega o newIndex ajustado.
                  onReorderItem: (oldIndex, newIndex) =>
                      notifier.reorderQueue(oldIndex + 1, newIndex + 1),
                  itemBuilder: (context, i) {
                    final episode = upcoming[i];
                    return ListTile(
                      key: ValueKey('queue-${episode.guid}'),
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        episode.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: colors.textMuted,
                        ),
                        tooltip: 'Tirar da fila',
                        onPressed: () => notifier.removeFromQueueAt(i + 1),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void _showEqualizerSheet(BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadii.surface),
      ),
    ),
    builder: (_) => const _EqualizerSheet(),
  );
}

class _EqualizerSheet extends ConsumerWidget {
  const _EqualizerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerViewModelProvider);
    final notifier = ref.read(playerViewModelProvider.notifier);
    final colors = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Áudio', style: Theme.of(context).textTheme.titleMedium),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Pular silêncio'),
              subtitle: Text(
                'Corta pausas longas na fala',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.textMuted),
              ),
              value: player.skipSilenceEnabled,
              onChanged: notifier.setSkipSilence,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reforço de volume'),
              subtitle: Text(
                'Equilibra episódios gravados baixo',
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.textMuted),
              ),
              value: player.volumeBoostEnabled,
              onChanged: notifier.setVolumeBoostEnabled,
            ),
            if (player.volumeBoostEnabled)
              Row(
                children: [
                  Icon(Icons.volume_up, color: colors.textMuted, size: 20),
                  Expanded(
                    child: Slider(
                      value: player.volumeBoostGainDb.clamp(0.0, 15.0),
                      max: 15,
                      divisions: 15,
                      label: '${player.volumeBoostGainDb.round()} dB',
                      onChanged: notifier.setVolumeBoostGain,
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    child: Text(
                      '${player.volumeBoostGainDb.round()} dB',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.textMuted),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Equalizador',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: player.equalizerEnabled,
                  onChanged: (v) => notifier.toggleEqualizer(v),
                ),
              ],
            ),
            if (!player.equalizerAvailable && player.equalizerBands.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Toque um episódio pra ajustar o equalizador.',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: colors.textMuted),
                ),
              )
            else ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final preset in EqualizerPreset.values)
                    ActionChip(
                      label: Text(_presetLabel(preset)),
                      onPressed: player.equalizerEnabled
                          ? () => notifier.applyEqualizerPreset(preset)
                          : null,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              for (final band in player.equalizerBands)
                Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: Text(
                        _hzLabel(band.centerHz),
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.textMuted),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: band.gain.clamp(
                          player.equalizerMinDb,
                          player.equalizerMaxDb,
                        ),
                        min: player.equalizerMinDb,
                        max: player.equalizerMaxDb,
                        onChanged: player.equalizerEnabled
                            ? (v) => notifier.setEqualizerBand(band.index, v)
                            : null,
                      ),
                    ),
                    SizedBox(
                      width: 44,
                      child: Text(
                        '${band.gain.round()} dB',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.textMuted),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _presetLabel(EqualizerPreset p) => switch (p) {
    EqualizerPreset.flat => 'Flat',
    EqualizerPreset.voz => 'Voz',
    EqualizerPreset.grave => 'Grave',
    EqualizerPreset.agudo => 'Agudo',
  };

  String _hzLabel(double hz) => hz >= 1000
      ? '${(hz / 1000).toStringAsFixed(hz % 1000 == 0 ? 0 : 1)}k'
      : '${hz.round()}';
}

class _SleepTimerButton extends StatelessWidget {
  const _SleepTimerButton({required this.state, required this.notifier});

  final PlayerState state;
  final PlayerViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Object?>(
      icon: Icon(state.hasSleepTimer ? Icons.bedtime : Icons.bedtime_outlined),
      tooltip: 'Temporizador para dormir',
      onSelected: (choice) {
        if (choice == null) {
          notifier.cancelSleepTimer();
        } else if (choice == _sleepEndOfEpisode) {
          notifier.startSleepTimerAtEndOfEpisode();
        } else if (choice is Duration) {
          notifier.startSleepTimer(choice);
        }
      },
      itemBuilder: (context) => [
        for (final option in _sleepOptions)
          PopupMenuItem(value: option, child: Text('${option.inMinutes} min')),
        const PopupMenuItem(
          value: _sleepEndOfEpisode,
          child: Text('Fim do episódio'),
        ),
        if (state.hasSleepTimer)
          const PopupMenuItem(value: null, child: Text('Cancelar')),
      ],
    );
  }
}

/// Faixa compacta de navegação de capítulos, abaixo dos controles.
class _ChapterStrip extends StatelessWidget {
  const _ChapterStrip({required this.state, required this.notifier});

  final PlayerState state;
  final PlayerViewModel notifier;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final current = state.currentChapter;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 22,
          tooltip: 'Capítulo anterior',
          onPressed: notifier.skipToPreviousChapter,
        ),
        Flexible(
          child: TextButton(
            onPressed: () => _showChaptersSheet(context),
            child: AnimatedSwitcher(
              duration: AppMotion.effective(context, AppMotion.base),
              switchInCurve: AppMotion.enter,
              child: Text(
                current?.title ?? 'Capítulos',
                key: ValueKey(current?.title ?? ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: colors.textMuted),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 22,
          tooltip: 'Próximo capítulo',
          onPressed: notifier.skipToNextChapter,
        ),
      ],
    );
  }
}

void _showChaptersSheet(BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadii.surface),
      ),
    ),
    builder: (_) => const _ChaptersSheet(),
  );
}

class _ChaptersSheet extends ConsumerWidget {
  const _ChaptersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerViewModelProvider);
    final notifier = ref.read(playerViewModelProvider.notifier);
    final colors = Theme.of(context).extension<AppColors>()!;
    final chapters = player.chapters;
    final currentIndex = player.currentChapterIndex;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Capítulos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: chapters.length,
                itemBuilder: (context, i) {
                  final chapter = chapters[i];
                  final isCurrent = i == currentIndex;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      _formatClock(chapter.start),
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.textMuted),
                    ),
                    title: Text(
                      chapter.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isCurrent ? colors.primary : null,
                        fontWeight: isCurrent ? FontWeight.w700 : null,
                      ),
                    ),
                    onTap: () {
                      notifier.skipToChapter(i);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
