import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';

class CatalogueEmpty extends StatelessWidget {
  const CatalogueEmpty({required this.isSearching, super.key});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Text(
        isSearching
            ? 'Aucun animé ne correspond à cette recherche.'
            : 'Le catalogue est vide pour le moment.',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
