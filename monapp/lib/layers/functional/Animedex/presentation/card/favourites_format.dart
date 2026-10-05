import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';

abstract final class FavouritesFormat {
  static const int thousand = 1000;

  static String of(AppLocalizations l10n, int count) {
    if (count < thousand) {
      return '$count';
    }

    final thousands = (count ~/ 100) / 10;

    return l10n.dexFavouritesThousands(
      NumberFormat('0.#', l10n.localeName).format(thousands),
    );
  }
}
