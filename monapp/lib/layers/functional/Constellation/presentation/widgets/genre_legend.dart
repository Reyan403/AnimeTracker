import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Anime/presentation/anime_genre_label.dart';
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

  final List<AnimeGenre> genres;
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
                  label: genreLabel(l10n, genres[index]),
                  color: StarPalette.colorAt(palette, index),
                  isSelected: genres[index].slug == selectedSlug,
                  onTap: () => onSelected(
                    genres[index].slug == selectedSlug
                        ? null
                        : genres[index].slug,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
