import 'package:monapp/layers/functional/Catalogue/domain/gateways/french_synopsis_gateway.dart';

class FakeFrenchSynopsisGateway implements FrenchSynopsisGateway {
  FakeFrenchSynopsisGateway({this.synopsesByTitle = const {}, this.isDown = false});

  final Map<String, String> synopsesByTitle;
  final bool isDown;
  final List<String> receivedTitles = [];

  @override
  Future<String?> findFor(String title) async {
    receivedTitles.add(title);

    if (isDown) {
      throw StateError('the translation service is unreachable');
    }

    return synopsesByTitle[title];
  }
}
