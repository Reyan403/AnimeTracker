import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/pop_card.dart';
import '../../domain/entities/booster_availability.dart';
import 'countdown_text.dart';

class BoosterBanner extends StatelessWidget {
  const BoosterBanner({
    required this.availability,
    required this.onOpen,
    required this.onElapsed,
    this.now = DateTime.now,
    super.key,
  });

  final BoosterAvailability availability;
  final VoidCallback onOpen;
  final VoidCallback onElapsed;
  final DateTime Function() now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final isAvailable = availability.isAvailable;

    return PopCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isAvailable ? palette.sun : palette.skeletonBase,
                    shape: BoxShape.circle,
                    border: Border.all(color: palette.ink, width: 2.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Icon(
                      isAvailable
                          ? Icons.auto_awesome
                          : Icons.hourglass_bottom_rounded,
                      color: palette.posterFallbackInk,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAvailable
                            ? l10n.dexBoosterReadyTitle
                            : l10n.dexBoosterWaitTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      if (isAvailable)
                        Text(
                          l10n.dexBoosterReadyHint,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        CountdownText(
                          target: availability.nextAt,
                          onElapsed: onElapsed,
                          now: now,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: palette.accentText,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (isAvailable) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.auto_awesome),
                label: Text(l10n.dexBoosterOpen),
              ),
            ] else ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.dexBoosterWaitHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
