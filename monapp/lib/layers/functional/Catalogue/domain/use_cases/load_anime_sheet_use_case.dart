import '../entities/anime_sheet.dart';
import '../gateways/anime_catalogue_gateway.dart';
import '../gateways/anime_sheet_cache.dart';
import '../gateways/anime_sheet_gateway.dart';
import '../gateways/french_synopsis_gateway.dart';

class LoadAnimeSheetUseCase {
  const LoadAnimeSheetUseCase(this._sheets, this._frenchSynopsis, this._cache);

  final AnimeSheetGateway _sheets;
  final FrenchSynopsisGateway _frenchSynopsis;
  final AnimeSheetCache _cache;

  Future<AnimeSheet> call(int id) async {
    try {
      final sheet = await _sheets.findById(id);
      final french = await _frenchSynopsisOf(sheet.title);
      final complete = french == null ? sheet : sheet.withSynopsis(french);

      _cache.save(complete);

      return complete;
    } on CatalogueUnavailableException {
      final cached = _cache.find(id);

      if (cached == null) {
        rethrow;
      }

      return cached;
    }
  }

  Future<String?> _frenchSynopsisOf(String title) async {
    try {
      return await _frenchSynopsis.findFor(title);
    } catch (_) {
      return null;
    }
  }
}
