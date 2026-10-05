import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/pop_title.dart';
import '../../../technical/Theme/widgets/sliver_content_padding.dart';
import 'cubit/evening_cubit.dart';
import 'cubit/recommendations_cubit.dart';
import 'widgets/evening_section.dart';
import 'widgets/recommendations_section.dart';

typedef DiscoverAnimeSelected = void Function(int animeId, String title);

class DiscoverView extends StatelessWidget {
  const DiscoverView({required this.onAnimeSelected, super.key});

  final DiscoverAnimeSelected onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<EveningCubit>()),
        BlocProvider(create: (_) => getIt<RecommendationsCubit>()..load()),
      ],
      child: DiscoverScaffold(onAnimeSelected: onAnimeSelected),
    );
  }
}

class DiscoverScaffold extends StatelessWidget {
  const DiscoverScaffold({required this.onAnimeSelected, super.key});

  final DiscoverAnimeSelected onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverContentPadding(
              top: AppSpacing.lg,
              bottom: AppSpacing.lg,
              sliver: SliverToBoxAdapter(
                child: PopTitle(AppLocalizations.of(context).discoverTitle),
              ),
            ),
            SliverContentPadding(
              bottom: AppSpacing.xl,
              sliver: SliverList.list(
                children: [
                  EveningSection(onAnimeSelected: onAnimeSelected),
                  const SizedBox(height: AppSpacing.xl),
                  RecommendationsSection(onAnimeSelected: onAnimeSelected),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
