import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';

class WatchlistEmpty extends StatelessWidget {
  const WatchlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Text(
        'Aucun animé dans cet onglet.',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
