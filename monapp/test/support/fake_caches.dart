import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/gateways/anime_details_cache.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_sheet_cache.dart';

class FakeDetailsCache implements AnimeDetailsCache {
  FakeDetailsCache([Map<int, AnimeDetails>? stored]) : stored = {...?stored};

  final Map<int, AnimeDetails> stored;
  int saves = 0;

  @override
  Map<int, AnimeDetails> findAll(List<int> ids) => {
        for (final id in ids)
          if (stored.containsKey(id)) id: stored[id]!.asCached(),
      };

  @override
  void saveAll(Map<int, AnimeDetails> details) {
    saves++;
    stored.addAll(details);
  }
}

class FakeSheetCache implements AnimeSheetCache {
  FakeSheetCache([Map<int, AnimeSheet>? stored]) : stored = {...?stored};

  final Map<int, AnimeSheet> stored;

  @override
  AnimeSheet? find(int id) => stored[id]?.asCached();

  @override
  void save(AnimeSheet sheet) => stored[sheet.id] = sheet;
}
