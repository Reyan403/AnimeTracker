import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/state_message.dart';

class CatalogueError extends StatelessWidget {
  const CatalogueError({required this.onRetry, this.title, super.key});

  final VoidCallback onRetry;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StateMessage(
      icon: Icons.cloud_off_outlined,
      title: title ?? l10n.catalogueErrorTitle,
      description: l10n.serviceUnavailable,
      actionLabel: l10n.retry,
      onAction: onRetry,
    );
  }
}
