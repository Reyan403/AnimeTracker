import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';

class CatalogueError extends StatelessWidget {
  const CatalogueError({
    required this.onRetry,
    this.title = 'Impossible de charger le catalogue',
    super.key,
  });

  final VoidCallback onRetry;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Le service MyAnimeList ne répond pas pour le moment.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(onPressed: onRetry, child: const Text('Réessayer')),
      ],
    );
  }
}
