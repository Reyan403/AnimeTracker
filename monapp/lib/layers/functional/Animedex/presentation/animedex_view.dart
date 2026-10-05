import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/anime_poster.dart';
import '../../../technical/Theme/widgets/pop_title.dart';
import '../../../technical/Theme/widgets/sliver_content_padding.dart';
import '../../Catalogue/presentation/anime_sheet_route.dart';
import 'booster/booster_page.dart';
import 'cubit/dex_cubit.dart';
import 'cubit/dex_state.dart';
import 'widgets/booster_banner.dart';
import 'widgets/collection_summary.dart';
import 'widgets/dex_body.dart';

class AnimedexView extends StatelessWidget {
  const AnimedexView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DexCubit>()..load(),
      child: const AnimedexScaffold(),
    );
  }
}

class AnimedexScaffold extends StatelessWidget {
  const AnimedexScaffold({this.now = DateTime.now, super.key});

  final DateTime Function() now;

  Future<void> _openBooster(BuildContext context) async {
    final cubit = context.read<DexCubit>();

    await BoosterPage.open(context);
    cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DexCubit>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<DexCubit, DexState>(
          builder: (context, state) {
            final availability = state.availability;

            return CustomScrollView(
              slivers: [
                SliverContentPadding(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  sliver: SliverToBoxAdapter(
                    child: PopTitle(AppLocalizations.of(context).dexTitle),
                  ),
                ),
                if (availability != null)
                  SliverContentPadding(
                    bottom: AppSpacing.lg,
                    sliver: SliverToBoxAdapter(
                      child: BoosterBanner(
                        availability: availability,
                        now: now,
                        onOpen: () => _openBooster(context),
                        onElapsed: cubit.load,
                      ),
                    ),
                  ),
                if (state.status == DexStatus.success)
                  SliverContentPadding(
                    bottom: AppSpacing.lg,
                    sliver: SliverToBoxAdapter(
                      child: CollectionSummary(state: state),
                    ),
                  ),
                SliverContentPadding(
                  bottom: AppSpacing.xl,
                  sliver: DexBody(
                    state: state,
                    onCardTap: (card) => openAnimeSheet(
                      context,
                      animeId: card.animeId,
                      title: card.title,
                      heroTag: AnimePoster.heroTagFor('dex', card.animeId),
                    ),
                    onRetry: cubit.load,
                    onOpenBooster: () => _openBooster(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
