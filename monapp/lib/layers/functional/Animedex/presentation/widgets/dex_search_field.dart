import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

class DexSearchField extends StatefulWidget {
  const DexSearchField({
    required this.query,
    required this.onChanged,
    super.key,
  });

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<DexSearchField> createState() => _DexSearchFieldState();
}

class _DexSearchFieldState extends State<DexSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.query,
  );

  @override
  void didUpdateWidget(DexSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: l10n.dexSearchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.query.isEmpty
            ? null
            : IconButton(
                tooltip: l10n.dexSearchClear,
                icon: const Icon(Icons.close),
                onPressed: () => widget.onChanged(''),
              ),
      ),
    );
  }
}
