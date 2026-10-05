import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/sliver_content_padding.dart';
import 'cubit/evening_cubit.dart';
import 'widgets/evening_section.dart';

typedef DiscoverAnimeSelected = void Function(int animeId, String title);

class DiscoverView extends StatelessWidget {
  const DiscoverView({required this.onAnimeSelected, super.key});

  final DiscoverAnimeSelected onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EveningCubit>(),
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverContentPadding(
              top: AppSpacing.lg,
              bottom: AppSpacing.lg,
              sliver: SliverToBoxAdapter(
                child: Text(
                  AppLocalizations.of(context).discoverTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
            SliverContentPadding(
              bottom: AppSpacing.xl,
              sliver: SliverToBoxAdapter(
                child: EveningSection(onAnimeSelected: onAnimeSelected),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
