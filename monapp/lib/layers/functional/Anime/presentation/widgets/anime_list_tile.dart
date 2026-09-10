import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';
import 'anime_poster.dart';
import 'watch_status_pill.dart';

class AnimeListTile extends StatelessWidget {
  const AnimeListTile({required this.anime, super.key});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      leading: AnimePoster(title: anime.title),
      title: Text(
        anime.title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: WatchStatusPill(status: anime.status),
    );
  }
}
