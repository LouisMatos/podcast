import 'dart:async';

import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/prefs/preferences_store.dart';
import '../../../data/models/radio_station.dart';
import '../../../data/repositories/radio_repository.dart';
import '../../../services/audio/podcast_audio_handler.dart';
import 'radio_state.dart';

part 'radio_view_model.g.dart';

/// ViewModel da aba Rádio. Sem import de Flutter — testável sem widget.
/// Toca direto no `PodcastAudioHandler` compartilhado, fora do fluxo de
/// fila/progresso/capítulos do `PlayerViewModel` — o `MediaItem` da rádio
/// carrega `extras: {'isRadio': true}`, que o `PlayerViewModel` ignora.
@riverpod
class RadioViewModel extends _$RadioViewModel {
  StreamSubscription<audio_service.MediaItem?>? _mediaItemSub;
  StreamSubscription<audio_service.PlaybackState>? _playbackStateSub;

  PodcastAudioHandler get _handler => ref.read(audioHandlerProvider);
  PreferencesStore get _prefs => ref.read(preferencesStoreProvider);

  @override
  RadioState build() {
    _mediaItemSub = _handler.mediaItem.listen(_onMediaItemChanged);
    _playbackStateSub = _handler.playbackState.listen(_onPlaybackStateChanged);
    ref.onDispose(() {
      _mediaItemSub?.cancel();
      _playbackStateSub?.cancel();
    });

    // Adiado pro fim do build(): _load() escreve em `state`, e o setter
    // rejeita escrita antes do build() atual retornar.
    Future.microtask(_load);
    return RadioState(isLoading: true, favoriteIds: _prefs.favoriteRadioIds.toSet());
  }

  void retry() => _load();

  void setQuery(String query) => state = state.copyWith(query: query);

  Future<void> toggleFavorite(String stationId) async {
    final ids = Set<String>.from(state.favoriteIds);
    if (!ids.remove(stationId)) ids.add(stationId);
    state = state.copyWith(favoriteIds: ids);
    await _prefs.setFavoriteRadioIds(ids.toList());
  }

  /// Toca [station]; se já for a que está tocando, alterna play/pause.
  Future<void> play(RadioStation station) async {
    if (state.nowPlayingId == station.id) {
      await togglePlayPause();
      return;
    }

    state = state.copyWith(nowPlayingId: station.id, isPlaying: false, isBuffering: true);
    await _handler.setQueue([_toMediaItem(station)], playFirst: true);
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _handler.pause();
    } else {
      await _handler.play();
    }
  }

  void _onMediaItemChanged(audio_service.MediaItem? item) {
    if (item?.extras?['isRadio'] != true) {
      // O handler compartilhado passou a tocar outra coisa (um episódio,
      // por exemplo) — sem isso o tile da rádio ficava travado em "tocando".
      if (state.nowPlayingId != null) {
        state = state.copyWith(nowPlayingId: null, isPlaying: false, isBuffering: false);
      }
      return;
    }
    state = state.copyWith(nowPlayingId: item!.extras?['stationId'] as String?);
  }

  void _onPlaybackStateChanged(audio_service.PlaybackState playbackState) {
    if (_handler.mediaItem.value?.extras?['isRadio'] != true) return;
    state = state.copyWith(
      isPlaying: playbackState.playing,
      isBuffering: playbackState.processingState == audio_service.AudioProcessingState.buffering ||
          playbackState.processingState == audio_service.AudioProcessingState.loading,
    );
  }

  audio_service.MediaItem _toMediaItem(RadioStation station) {
    return audio_service.MediaItem(
      id: station.streamUrl,
      title: station.name,
      artist: 'Rádio ao vivo',
      artUri: station.logoUrl != null ? Uri.tryParse(station.logoUrl!) : null,
      extras: {'isRadio': true, 'stationId': station.id},
    );
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null, offline: false);
    try {
      final repository = ref.read(radioRepositoryProvider);
      final stations = await repository.brStations();
      if (!ref.mounted) return;
      state = state.copyWith(stations: stations, isLoading: false);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Não foi possível carregar as rádios agora.',
        offline: _isConnectionError(e),
      );
    }
  }

  bool _isConnectionError(Object error) {
    if (error is! DioException) return false;
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }
}

/// Filtra [stations] por nome/gênero/estado contendo [query] (case-insensitive).
List<RadioStation> filterStations(List<RadioStation> stations, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return stations;
  return stations.where((s) {
    return s.name.toLowerCase().contains(q) ||
        (s.genre?.toLowerCase().contains(q) ?? false) ||
        (s.state?.toLowerCase().contains(q) ?? false);
  }).toList();
}
