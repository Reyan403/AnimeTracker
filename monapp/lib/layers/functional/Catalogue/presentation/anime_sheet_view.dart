import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/anime_poster.dart';
import '../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import '../domain/entities/anime_sheet.dart';
import 'cubit/anime_sheet_cubit.dart';
import 'cubit/anime_sheet_state.dart';
import 'widgets/anime_sheet_cover.dart';
import 'widgets/anime_sheet_facts.dart';
import 'widgets/catalogue_error.dart';

class AnimeSheetView extends StatelessWidget {
  const AnimeSheetView({required this.animeId, required this.title, super.key});

  final int animeId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AnimeSheetCubit>()..load(animeId),
      child: AnimeSheetScaffold(animeId: animeId, title: title),
    );
  }
}

class AnimeSheetScaffold extends StatelessWidget {
  const AnimeSheetScaffold({
    required this.animeId,
    required this.title,
    super.key,
  });

  final int animeId;
  final String title;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnimeSheetCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocBuilder<AnimeSheetCubit, AnimeSheetState>(
        builder: (context, state) => switch (state.status) {
          AnimeSheetStatus.loading => const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: PlaqueRowSkeleton(rowCount: 1),
            ),
          AnimeSheetStatus.failure => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: CatalogueError(
                title: 'Impossible de charger la fiche',
                onRetry: () => cubit.load(animeId),
              ),
            ),
          AnimeSheetStatus.success => AnimeSheetBody(sheet: state.sheet!),
        },
      ),
    );
  }
}

class AnimeSheetBody extends StatelessWidget {
  const AnimeSheetBody({required this.sheet, super.key});

  final AnimeSheet sheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final synopsis = sheet.synopsis;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: [
        AnimeSheetCover(imageUrl: sheet.coverUrl),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimePoster(title: sheet.title, imageUrl: sheet.posterUrl),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(sheet.title, style: theme.textTheme.titleLarge),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              if (synopsis != null) ...[
                Text('Synopsis', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(synopsis, style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
              ],
              Text('En bref', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              AnimeSheetFacts(sheet: sheet),
            ],
          ),
        ),
      ],
    );
  }
}
