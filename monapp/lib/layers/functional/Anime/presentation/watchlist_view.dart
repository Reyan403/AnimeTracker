import 'package:flutter/material.dart';

import '../../../technical/Theme/app_spacing.dart';
import '../data/mock_anime_catalog.dart';
import '../domain/entities/anime.dart';
import '../domain/entities/watch_status.dart';
import 'widgets/anime_row.dart';
import 'widgets/watch_status_tabs.dart';
import 'widgets/watchlist_header.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  WatchStatus _selected = WatchStatus.watching;

  List<Anime> get _visibleAnimes => MockAnimeCatalog.watchlist
      .where((anime) => anime.status == _selected)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            WatchlistHeader(
              animes: MockAnimeCatalog.watchlist,
            ),
            const SizedBox(height: AppSpacing.lg),
            WatchStatusTabs(
              animes: MockAnimeCatalog.watchlist,
              selected: _selected,
              onSelected: (status) => setState(() => _selected = status),
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final anime in _visibleAnimes) AnimeRow(anime: anime),
          ],
        ),
      ),
    );
  }
}
