import '../entities/anime_sheet.dart';

abstract interface class AnimeSheetGateway {
  Future<AnimeSheet> findById(int id);
}
