import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../../technical/Theme/widgets/content_width.dart';
import '../../../../technical/Theme/widgets/genre_tag.dart';
import '../../../../technical/Theme/widgets/offline_notice.dart';
import '../../domain/entities/anime_sheet.dart';
import 'anime_sheet_cover.dart';
import 'anime_sheet_facts.dart';
import 'hidden_synopsis.dart';

class AnimeSheetBody extends StatelessWidget {
  const AnimeSheetBody({
    required this.sheet,
    required this.heroTag,
    this.isSynopsisHidden = false,
    this.onRevealSynopsis,
    this.extras,
    super.key,
  });

  final AnimeSheet sheet;
  final String heroTag;
  final bool isSynopsisHidden;
  final VoidCallback? onRevealSynopsis;
  final Widget? extras;

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
                if (sheet.isCached) ...[
                  const OfflineNotice(),
                  const SizedBox(height: AppSpacing.lg),
                ],
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
                  if (isSynopsisHidden)
                    HiddenSynopsis(
                      synopsis: synopsis,
                      onReveal: onRevealSynopsis ?? () {},
                    )
                  else
                    Text(
                      synopsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  if (sheet.isSynopsisTranslated && !isSynopsisHidden) ...[
                    const SizedBox(height: AppSpacing.sm),
                    GenreTag(
                      label: l10n.synopsisTranslatedNotice,
                      icon: Icons.translate,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                ],
                Text(l10n.inBrief, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                AnimeSheetFacts(sheet: sheet),
                if (extras != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  extras!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
