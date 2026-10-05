import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/state_message.dart';

class CatalogueEmpty extends StatelessWidget {
  const CatalogueEmpty({required this.isSearching, super.key});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StateMessage(
      icon: isSearching ? Icons.search_off : Icons.movie_outlined,
      title: isSearching ? l10n.catalogueEmptySearch : l10n.catalogueEmpty,
      description: isSearching ? l10n.catalogueEmptySearchHint : null,
    );
  }
}
