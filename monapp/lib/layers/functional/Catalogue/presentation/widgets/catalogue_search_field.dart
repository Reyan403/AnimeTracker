import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

class CatalogueSearchField extends StatelessWidget {
  const CatalogueSearchField({
    required this.controller,
    required this.onChanged,
    required this.onCleared,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SearchBar(
      controller: controller,
      onChanged: onChanged,
      hintText: l10n.searchHint,
      elevation: const WidgetStatePropertyAll(0),
      leading: const Icon(Icons.search),
      trailing: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) => controller.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onCleared,
                  tooltip: l10n.clearTooltip,
                ),
        ),
      ],
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
