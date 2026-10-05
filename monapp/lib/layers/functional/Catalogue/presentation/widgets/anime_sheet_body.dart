import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../../technical/Theme/widgets/content_width.dart';
import '../../domain/entities/anime_sheet.dart';
import 'anime_sheet_cover.dart';
import 'anime_sheet_facts.dart';

class AnimeSheetBody extends StatelessWidget {
  const AnimeSheetBody({required this.sheet, required this.heroTag, super.key});

  final AnimeSheet sheet;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final synopsis = sheet.synopsis;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: [
        AnimeSheetCover(imageUrl: sheet.coverUrl),
        ContentWidth(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimePoster(
                      title: sheet.title,
                      imageUrl: sheet.posterUrl,
                      heroTag: heroTag,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        sheet.title,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                if (synopsis != null) ...[
                  Text(l10n.synopsis, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    synopsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                Text(l10n.inBrief, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                AnimeSheetFacts(sheet: sheet),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
