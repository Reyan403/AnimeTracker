import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../Catalogue/presentation/anime_sheet_route.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../cubit/constellation_cubit.dart';
import '../cubit/constellation_state.dart';
import 'constellation_loading.dart';
import 'constellation_sky.dart';
import 'genre_legend.dart';
import 'sky_header.dart';
import 'sky_message.dart';
import 'star_preview_panel.dart';

class ConstellationBody extends StatelessWidget {
  const ConstellationBody({
    required this.state,
    required this.cubit,
    required this.onBack,
    super.key,
  });

  static EdgeInsets skyInset(double safeTop) => EdgeInsets.only(
    top:
        safeTop +
        SkyHeader.height +
        AppSpacing.minTouchTarget +
        AppSpacing.md,
  );

  final ConstellationState state;
  final ConstellationCubit cubit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final constellation = state.constellation;
    final safeTop = MediaQuery.paddingOf(context).top;
    final isSuccess = state.status == ConstellationStatus.success;
    final star = state.selectedStar;

    return Stack(
      fit: StackFit.expand,
      children: [
        switch (state.status) {
          ConstellationStatus.loading => const ConstellationLoading(),
          ConstellationStatus.empty => SkyMessage(
            icon: Icons.auto_awesome,
            title: l10n.constellationEmptyTitle,
            description: l10n.constellationEmptyHint,
          ),
          ConstellationStatus.failure => SkyMessage(
            icon: Icons.cloud_off_outlined,
            title: l10n.constellationErrorTitle,
            description: l10n.serviceUnavailable,
            actionLabel: l10n.retry,
            onAction: cubit.load,
          ),
          ConstellationStatus.success => ConstellationSky(
            constellation: constellation!,
            inset: skyInset(safeTop),
            selectedId: state.selectedStarId,
            genreSlug: state.genreSlug,
            onStarTapped: cubit.select,
          ),
        },
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkyHeader(onBack: onBack),
              if (isSuccess)
                GenreLegend(
                  genres: constellation!.genres,
                  selectedSlug: state.genreSlug,
                  onSelected: cubit.filterByGenre,
                ),
            ],
          ),
        ),
        if (isSuccess)
          StarPreviewPanel(
            star: star,
            genres: constellation!.genres,
            linkCount: star == null ? 0 : state.linkCountOf(star.animeId),
            onClose: () => cubit.select(null),
            onOpen: () => openAnimeSheet(
              context,
              animeId: star!.animeId,
              title: star.title,
              heroTag: AnimePoster.heroTagFor('constellation', star.animeId),
            ),
          ),
      ],
    );
  }
}
