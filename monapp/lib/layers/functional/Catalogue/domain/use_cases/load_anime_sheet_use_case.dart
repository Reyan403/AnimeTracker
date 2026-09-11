import '../entities/anime_sheet.dart';
import '../gateways/anime_sheet_gateway.dart';
import '../gateways/french_synopsis_gateway.dart';

class LoadAnimeSheetUseCase {
  const LoadAnimeSheetUseCase(this._sheets, this._frenchSynopsis);

  final AnimeSheetGateway _sheets;
  final FrenchSynopsisGateway _frenchSynopsis;

  Future<AnimeSheet> call(int id) async {
    final sheet = await _sheets.findById(id);
    final french = await _frenchSynopsisOf(sheet.title);

    return french == null ? sheet : sheet.withSynopsis(french);
  }

  Future<String?> _frenchSynopsisOf(String title) async {
    try {
      return await _frenchSynopsis.findFor(title);
    } catch (_) {
      return null;
    }
  }
}
