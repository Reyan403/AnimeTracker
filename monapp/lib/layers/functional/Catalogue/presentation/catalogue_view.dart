import 'package:flutter/material.dart';

import '../../../technical/Theme/app_spacing.dart';
import 'widgets/catalogue_search_field.dart';

class CatalogueView extends StatefulWidget {
  const CatalogueView({super.key});

  @override
  State<CatalogueView> createState() => _CatalogueViewState();
}

class _CatalogueViewState extends State<CatalogueView> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Catalogue', style: theme.textTheme.displaySmall),
              const SizedBox(height: AppSpacing.lg),
              CatalogueSearchField(
                controller: _controller,
                onChanged: (value) => setState(() => _query = value),
                onCleared: _clear,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _query.isEmpty
                    ? 'Cherche un animé à ajouter à ta liste.'
                    : 'La recherche n\'est pas encore branchée à l\'API.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
