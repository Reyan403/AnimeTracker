import '../entities/anime_details.dart';

abstract interface class AnimeDetailsCache {
  Map<int, AnimeDetails> findAll(List<int> ids);

  void saveAll(Map<int, AnimeDetails> details);
}
