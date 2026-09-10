import 'package:flutter/material.dart';

import '../../functional/Anime/presentation/watchlist_view.dart';
import '../../functional/Catalogue/presentation/catalogue_view.dart';
import 'app_destination.dart';
import 'app_navigation_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppDestination _selected = AppDestination.watchlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selected.index,
        children: const [WatchlistView(), CatalogueView()],
      ),
      bottomNavigationBar: AppNavigationBar(
        selected: _selected,
        onSelected: (destination) => setState(() => _selected = destination),
      ),
    );
  }
}
