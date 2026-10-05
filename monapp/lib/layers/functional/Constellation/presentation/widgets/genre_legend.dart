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

  static const int maxGenres = 8;

  final List<AnimeGenre> genres;
  final ValueChanged<String?> onSelected;
  final String? selectedSlug;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final shown = genres.take(maxGenres).toList();

    return Semantics(
      label: l10n.constellationFilterHint,
      container: true,
      child: SizedBox(
        height: AppSpacing.minTouchTarget,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: shown.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, index) {
            final genre = shown[index];
            final isSelected = genre.slug == selectedSlug;

            return GenreLegendChip(
              label: genreLabel(l10n, genre),
              color: StarPalette.colorAt(palette, index),
              isSelected: isSelected,
              onTap: () => onSelected(isSelected ? null : genre.slug),
            );
          },
        ),
      ),
    );
  }
}
