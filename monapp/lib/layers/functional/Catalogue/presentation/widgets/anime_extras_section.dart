import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Injection/injection.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/skeleton_box.dart';
import '../cubit/anime_extras_cubit.dart';
import 'related_anime_tile.dart';

class AnimeExtrasSection extends StatelessWidget {
  const AnimeExtrasSection({
    required this.animeId,
    required this.trailerId,
    required this.onRelatedSelected,
    super.key,
  });

  final int animeId;
  final String? trailerId;
  final void Function(int animeId, String title) onRelatedSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AnimeExtrasCubit>()..load(animeId),
      child: _ExtrasBody(
        trailerId: trailerId,
        onRelatedSelected: onRelatedSelected,
      ),
    );
  }
}

class _ExtrasBody extends StatelessWidget {
  const _ExtrasBody({
    required this.trailerId,
    required this.onRelatedSelected,
  });

  final String? trailerId;
  final void Function(int animeId, String title) onRelatedSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<AnimeExtrasCubit>();
    final trailer = trailerId;

    return BlocConsumer<AnimeExtrasCubit, AnimeExtrasState>(
      listenWhen: (before, after) => !before.linkFailed && after.linkFailed,
      listener: (context, state) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.extrasLinkFailed))),
      builder: (context, state) {
        final extras = state.extras;
        final showWatchOn = trailer != null ||
            state.status == AnimeExtrasStatus.loading ||
            extras.streamingLinks.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showWatchOn) ...[
            Text(l10n.extrasWatchOn, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                if (trailer != null)
                  FilledButton.icon(
                    onPressed: () => cubit.openTrailer(trailer),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.extrasTrailer),
                  ),
                if (state.status == AnimeExtrasStatus.loading)
                  const SkeletonBox(width: 120, height: 48, radius: 24),
                for (final link in extras.streamingLinks)
                  OutlinedButton.icon(
                    onPressed: () => cubit.openStreaming(link),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: Text(link.siteName),
                  ),
              ],
            ),
            ],
            if (extras.related.isNotEmpty) ...[
              SizedBox(height: showWatchOn ? AppSpacing.xl : 0),
              Text(l10n.extrasRelated, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: RelatedAnimeTile.posterHeight + 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: extras.related.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final related = extras.related[index];

                    return RelatedAnimeTile(
                      related: related,
                      onTap: () => onRelatedSelected(
                        related.anime.id,
                        related.anime.title,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
