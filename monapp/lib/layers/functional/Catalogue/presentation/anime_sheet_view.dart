import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import 'cubit/anime_sheet_cubit.dart';
import 'cubit/anime_sheet_state.dart';
import 'widgets/anime_sheet_body.dart';
import 'widgets/catalogue_error.dart';

class AnimeSheetView extends StatelessWidget {
  const AnimeSheetView({
    required this.animeId,
    required this.title,
    required this.heroTag,
    super.key,
  });

  final int animeId;
  final String title;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AnimeSheetCubit>()..load(animeId),
      child: AnimeSheetScaffold(
        animeId: animeId,
        title: title,
        heroTag: heroTag,
      ),
    );
  }
}

class AnimeSheetScaffold extends StatelessWidget {
  const AnimeSheetScaffold({
    required this.animeId,
    required this.title,
    required this.heroTag,
    super.key,
  });

  final int animeId;
  final String title;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnimeSheetCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<AnimeSheetCubit, AnimeSheetState>(
        builder: (context, state) => switch (state.status) {
          AnimeSheetStatus.loading => const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: PlaqueRowSkeleton(rowCount: 1),
            ),
          AnimeSheetStatus.failure => CatalogueError(
              title: AppLocalizations.of(context).sheetErrorTitle,
              onRetry: () => cubit.load(animeId),
            ),
          AnimeSheetStatus.success => AnimeSheetBody(
              sheet: state.sheet!,
              heroTag: heroTag,
            ),
        },
      ),
    );
  }
}
