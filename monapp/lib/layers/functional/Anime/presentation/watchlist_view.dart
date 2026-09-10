import 'package:flutter/material.dart';

import '../data/mock_anime_catalog.dart';
import 'widgets/anime_list_tile.dart';

class WatchlistView extends StatelessWidget {
  const WatchlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma liste')),
      body: ListView.separated(
        itemCount: MockAnimeCatalog.watchlist.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) =>
            AnimeListTile(anime: MockAnimeCatalog.watchlist[index]),
      ),
    );
  }
}
