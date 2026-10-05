import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).watchlistTitle,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}
