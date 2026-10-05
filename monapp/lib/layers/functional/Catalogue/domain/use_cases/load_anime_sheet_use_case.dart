import '../entities/anime_sheet.dart';
import '../gateways/anime_catalogue_gateway.dart';
import '../gateways/anime_sheet_cache.dart';
import '../gateways/anime_sheet_gateway.dart';
import '../gateways/french_synopsis_gateway.dart';
import '../gateways/synopsis_translation_gateway.dart';

class LoadAnimeSheetUseCase {
  const LoadAnimeSheetUseCase(
    this._sheets,
    this._frenchSynopsis,
    this._translation,
    this._cache,
  );

  final AnimeSheetGateway _sheets;
  final FrenchSynopsisGateway _frenchSynopsis;
  final SynopsisTranslationGateway _translation;
  final AnimeSheetCache _cache;

  Future<AnimeSheet> call(int id) async {
    try {
      final complete = await _inFrench(await _sheets.findById(id));

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

  Future<AnimeSheet> _inFrench(AnimeSheet sheet) async {
    final french = await _frenchSynopsisOf(sheet.title);

    if (french != null) {
      return sheet.withSynopsis(french);
    }

    final english = sheet.synopsis;

    if (english == null) {
      return sheet;
    }

    final translated = await _translationOf(english);

    return translated == null
        ? sheet
        : sheet.withTranslatedSynopsis(translated);
  }

  Future<String?> _frenchSynopsisOf(String title) async {
    try {
      return await _frenchSynopsis.findFor(title);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _translationOf(String text) async {
    try {
      return await _translation.translateToFrench(text);
    } catch (_) {
      return null;
    }
  }
}
