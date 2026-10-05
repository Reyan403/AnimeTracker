import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

class AgendaFilter extends StatelessWidget {
  const AgendaFilter({
    required this.onlyWatchlist,
    required this.onChanged,
    super.key,
  });

  final bool onlyWatchlist;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SegmentedButton<bool>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(value: false, label: Text(l10n.agendaFilterAll)),
        ButtonSegment(value: true, label: Text(l10n.agendaFilterMine)),
      ],
      selected: {onlyWatchlist},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
