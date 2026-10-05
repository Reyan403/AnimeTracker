import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/evening_duration.dart';
import '../../domain/entities/evening_mood.dart';
import '../evening_labels.dart';

class EveningFilters extends StatelessWidget {
  const EveningFilters({
    required this.mood,
    required this.duration,
    required this.onMoodSelected,
    required this.onDurationSelected,
    super.key,
  });

  final EveningMood mood;
  final EveningDuration duration;
  final ValueChanged<EveningMood> onMoodSelected;
  final ValueChanged<EveningDuration> onDurationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.eveningMoodLabel, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (final option in EveningMood.values)
              ChoiceChip(
                label: Text(option.labelOf(l10n)),
                selected: option == mood,
                onSelected: (_) => onMoodSelected(option),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.eveningTimeLabel, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (final option in EveningDuration.values)
              ChoiceChip(
                label: Text(option.labelOf(l10n)),
                selected: option == duration,
                onSelected: (_) => onDurationSelected(option),
              ),
          ],
        ),
      ],
    );
  }
}
