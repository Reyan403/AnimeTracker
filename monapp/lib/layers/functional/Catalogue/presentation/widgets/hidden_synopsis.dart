import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';

class HiddenSynopsis extends StatelessWidget {
  const HiddenSynopsis({
    required this.synopsis,
    required this.onReveal,
    super.key,
  });

  static const double blur = 7;

  final String synopsis;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: ClipRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Text(
                synopsis,
                maxLines: 5,
                overflow: TextOverflow.clip,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Icon(
              Icons.visibility_off_outlined,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                l10n.spoilerHiddenHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(onPressed: onReveal, child: Text(l10n.spoilerReveal)),
          ],
        ),
      ],
    );
  }
}
