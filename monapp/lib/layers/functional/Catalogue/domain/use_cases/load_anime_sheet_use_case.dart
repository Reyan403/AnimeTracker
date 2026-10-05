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

  Stream<AnimeSheet> call(int id) async* {
    final AnimeSheet sheet;

    try {
      sheet = await _sheets.findById(id);
    } on CatalogueUnavailableException {
      final cached = _cache.find(id);

      if (cached == null) {
        rethrow;
      }

      yield cached;

      return;
    }

    final translated = _cache.find(id)?.synopsis;

    if (translated != null && _cache.find(id)!.isSynopsisTranslated) {
      final restored = sheet.withTranslatedSynopsis(translated);

      _cache.save(restored);
      yield restored;

      return;
    }

    yield sheet;

    final complete = await _inFrench(sheet);

    _cache.save(complete);

    if (complete != sheet) {
      yield complete;
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

    final translation = await _translationOf(english);

    return translation == null
        ? sheet
        : sheet.withTranslatedSynopsis(translation);
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
