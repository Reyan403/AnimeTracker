import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';

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
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      style: theme.textTheme.titleSmall,
      decoration: InputDecoration(
        hintText: 'Rechercher un animé',
        hintStyle: theme.textTheme.bodyMedium,
        filled: true,
        fillColor: AppColors.paper,
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
          color: AppColors.inkMuted,
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.inkMuted,
                ),
                onPressed: onCleared,
                tooltip: 'Effacer',
              ),
        border: _border(AppColors.rule),
        enabledBorder: _border(AppColors.rule),
        focusedBorder: _border(AppColors.accent),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }

  static OutlineInputBorder _border(Color colour) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.squareRadius),
        borderSide: BorderSide(color: colour, width: AppSpacing.hairline),
      );
}
