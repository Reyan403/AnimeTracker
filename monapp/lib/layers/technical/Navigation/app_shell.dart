import 'package:flutter/material.dart';

import '../../functional/Agenda/presentation/agenda_view.dart';
import '../../functional/Anime/presentation/watchlist_view.dart';
import '../../functional/Catalogue/presentation/anime_sheet_route.dart';
import '../../functional/Catalogue/presentation/catalogue_view.dart';
import '../Theme/app_spacing.dart';
import '../Theme/widgets/anime_poster.dart';
import '../Theme/widgets/fade_on_change.dart';
import 'app_destination.dart';
import 'app_navigation_bar.dart';
import 'app_navigation_rail.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppDestination _selected = AppDestination.watchlist;

  void _select(AppDestination destination) =>
      setState(() => _selected = destination);

  void _openSheet(String origin, int animeId, String title) => openAnimeSheet(
        context,
        animeId: animeId,
        title: title,
        heroTag: AnimePoster.heroTagFor(origin, animeId),
      );

  @override
  Widget build(BuildContext context) {
    final isExpanded =
        MediaQuery.sizeOf(context).width >= AppSpacing.expandedBreakpoint;
    final body = FadeOnChange(
      trigger: _selected,
      child: IndexedStack(
        index: _selected.index,
        children: [
          WatchlistView(
            onAnimeSelected: (animeId, title) =>
                _openSheet('list', animeId, title),
          ),
          const CatalogueView(),
          AgendaView(
            onAnimeSelected: (animeId, title) =>
                _openSheet('agenda', animeId, title),
          ),
        ],
      ),
    );

    return Scaffold(
      body: isExpanded
          ? Row(
              children: [
                AppNavigationRail(selected: _selected, onSelected: _select),
                Expanded(child: body),
              ],
            )
          : body,
      bottomNavigationBar: isExpanded
          ? null
          : AppNavigationBar(selected: _selected, onSelected: _select),
    );
  }
}
