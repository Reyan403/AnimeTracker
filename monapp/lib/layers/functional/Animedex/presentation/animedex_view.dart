import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/pop_title.dart';
import '../../../technical/Theme/widgets/sliver_content_padding.dart';
import 'cubit/dex_cubit.dart';
import 'cubit/dex_state.dart';
import 'widgets/booster_tab.dart';
import 'widgets/collection_tab.dart';
import 'widgets/dex_tabs.dart';

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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DexCubit>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<DexCubit, DexState>(
          builder: (context, state) => CustomScrollView(
            slivers: [
              SliverContentPadding(
                top: AppSpacing.lg,
                bottom: AppSpacing.lg,
                sliver: SliverToBoxAdapter(
                  child: PopTitle(AppLocalizations.of(context).dexTitle),
                ),
              ),
              SliverContentPadding(
                bottom: AppSpacing.xl,
                sliver: SliverToBoxAdapter(
                  child: DexTabs(
                    selected: state.tab,
                    collectionCount: state.cards.length,
                    onSelected: cubit.selectTab,
                  ),
                ),
              ),
              SliverContentPadding(
                bottom: AppSpacing.xl,
                sliver: switch (state.tab) {
                  DexTab.booster => BoosterTab(state: state, now: now),
                  DexTab.collection => CollectionTab(state: state),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
