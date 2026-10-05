import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/state_message.dart';

class WatchlistEmpty extends StatelessWidget {
  const WatchlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StateMessage(
      icon: Icons.bookmark_add_outlined,
      title: l10n.watchlistEmpty,
      description: l10n.watchlistEmptyHint,
    );
  }
}
