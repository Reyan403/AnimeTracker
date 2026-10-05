import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../Discover/domain/entities/evening_mood.dart';
import '../../../Discover/presentation/evening_labels.dart';
import 'genre_legend_chip.dart';
import 'star_palette.dart';

class GenreLegend extends StatelessWidget {
  const GenreLegend({
    required this.genres,
    required this.onSelected,
    this.selectedSlug,
    super.key,
  });

  static const double maxHeightFraction = 1 / 3;

  final List<EveningMood> genres;
  final ValueChanged<String?> onSelected;
  final String? selectedSlug;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFraction;

    return Semantics(
      label: l10n.constellationFilterHint,
      container: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (var index = 0; index < genres.length; index++)
                GenreLegendChip(
                  label: genres[index].labelOf(l10n),
                  color: StarPalette.colorAt(palette, index),
                  isSelected: genres[index].name == selectedSlug,
                  onTap: () => onSelected(
                    genres[index].name == selectedSlug
                        ? null
                        : genres[index].name,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
