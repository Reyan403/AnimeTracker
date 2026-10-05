import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../app_spacing.dart';

class OfflineNotice extends StatelessWidget {
  const OfflineNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.cloud_off_outlined, color: scheme.onSecondaryContainer),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                AppLocalizations.of(context).offlineNotice,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
