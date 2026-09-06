import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/podcast.dart';
import '../../../data/repositories/podcast_repository.dart';

part 'category_view_model.g.dart';

/// Lista de podcasts mais ouvidos numa categoria (genreId da Apple).
@riverpod
class CategoryViewModel extends _$CategoryViewModel {
  @override
  Future<List<Podcast>> build(int genreId) {
    return ref.watch(podcastRepositoryProvider).podcastsByGenre(genreId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(podcastRepositoryProvider).podcastsByGenre(genreId),
    );
  }
}
