import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/anime_poster.dart';
import '../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import '../../../technical/Theme/widgets/sliver_content_padding.dart';
import 'anime_sheet_route.dart';
import 'cubit/catalogue_cubit.dart';
import 'cubit/catalogue_state.dart';
import 'widgets/catalogue_results_sliver.dart';
import 'widgets/catalogue_search_field.dart';

class CatalogueView extends StatelessWidget {
  const CatalogueView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CatalogueCubit>()..load(),
      child: const CatalogueScaffold(),
    );
  }
}

class CatalogueScaffold extends StatefulWidget {
  const CatalogueScaffold({super.key});

  static const double loadMoreMargin = 400;

  @override
  State<CatalogueScaffold> createState() => _CatalogueScaffoldState();
}

class _CatalogueScaffoldState extends State<CatalogueScaffold> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    context.read<CatalogueCubit>().clear();
  }

  bool _loadMoreWhenNearBottom(ScrollNotification notification) {
    if (notification.metrics.extentAfter < CatalogueScaffold.loadMoreMargin) {
      context.read<CatalogueCubit>().loadMore();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatalogueCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CatalogueCubit, CatalogueState>(
          builder: (context, state) => NotificationListener<ScrollNotification>(
            onNotification: _loadMoreWhenNearBottom,
            child: CustomScrollView(
              slivers: [
                SliverContentPadding(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).catalogueTitle,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        CatalogueSearchField(
                          controller: _controller,
                          onChanged: cubit.search,
                          onCleared: _clear,
                        ),
                      ],
                    ),
                  ),
                ),
                CatalogueResultsSliver(
                  state: state,
                  onRetry: cubit.load,
                  onAnimeSelected: (anime) => openAnimeSheet(
                    context,
                    animeId: anime.id,
                    title: anime.title,
                    heroTag: AnimePoster.heroTagFor('catalogue', anime.id),
                  ),
                  onAdd: cubit.addToWatchlist,
                ),
                SliverContentPadding(
                  bottom: AppSpacing.xl,
                  sliver: SliverToBoxAdapter(
                    child: state.isAppending
                        ? const PlaqueRowSkeleton(rowCount: 1)
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
