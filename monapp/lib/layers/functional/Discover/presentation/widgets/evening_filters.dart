import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/evening_mood.dart';
import '../evening_labels.dart';

class EveningFilters extends StatelessWidget {
  const EveningFilters({
    required this.mood,
    required this.onMoodSelected,
    super.key,
  });

  final EveningMood mood;
  final ValueChanged<EveningMood> onMoodSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eveningMoodLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.md,
          children: [
            for (final option in EveningMood.values)
              ChoiceChip(
                label: Text(option.labelOf(l10n)),
                selected: option == mood,
                onSelected: (_) => onMoodSelected(option),
              ),
          ],
        ),
      ],
    );
  }
}
