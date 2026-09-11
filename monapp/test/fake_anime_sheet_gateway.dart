import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_sheet_gateway.dart';

class FakeAnimeSheetGateway implements AnimeSheetGateway {
  FakeAnimeSheetGateway({this.sheetsById = const {}, this.crashes = false});

  final Map<int, AnimeSheet> sheetsById;
  final bool crashes;
  final List<int> receivedIds = [];

  @override
  Future<AnimeSheet> findById(int id) async {
    receivedIds.add(id);

    if (crashes) {
      throw StateError('the service answered something unexpected');
    }

    final sheet = sheetsById[id];

    if (sheet == null) {
      throw const CatalogueUnavailableException();
    }

    return sheet;
  }
}
