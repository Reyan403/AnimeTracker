import 'dart:convert';

import '../../../../technical/Preferences/app_preferences.dart';
import '../../../../technical/Preferences/preferences_key.dart';
import '../../domain/entities/dex_card.dart';
import '../../domain/gateways/dex_collection_gateway.dart';
import '../models/dex_card_dto.dart';

class PreferencesDexCollectionGateway implements DexCollectionGateway {
  PreferencesDexCollectionGateway(this._preferences);

  final AppPreferences _preferences;
  List<DexCard>? _loaded;

  @override
  List<DexCard> get cards => List.unmodifiable(_loaded ??= _read());

  @override
  Future<void> addAll(List<DexCard> cards) async {
    final stored = _loaded ??= _read();
    final known = {for (final card in stored) card.characterId};

    stored.addAll([
      for (final card in cards)
        if (known.add(card.characterId)) card,
    ]);

    await _preferences.writeString(
      PreferencesKey.dex,
      jsonEncode([for (final card in stored) DexCardDto.toJson(card)]),
    );
  }

  List<DexCard> _read() {
    final source = _preferences.readString(PreferencesKey.dex);

    if (source == null) {
      return [];
    }

    try {
      final decoded = jsonDecode(source);

      return [
        if (decoded is List)
          for (final item in decoded) ?DexCardDto.fromJson(item),
      ];
    } on FormatException {
      return [];
    }
  }
}
