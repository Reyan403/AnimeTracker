import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/state_message.dart';

class WatchlistError extends StatelessWidget {
  const WatchlistError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StateMessage(
      icon: Icons.cloud_off_outlined,
      title: l10n.watchlistErrorTitle,
      description: l10n.serviceUnavailable,
      actionLabel: l10n.retry,
      onAction: onRetry,
    );
  }
}
