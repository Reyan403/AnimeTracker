import '../entities/anime_sheet.dart';

abstract interface class AnimeSheetCache {
  AnimeSheet? find(int id);

  void save(AnimeSheet sheet);
}
