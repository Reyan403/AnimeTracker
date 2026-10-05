import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

class ComebackHint extends StatefulWidget {
  const ComebackHint({
    required this.target,
    this.now = DateTime.now,
    this.style,
    super.key,
  });

  final DateTime target;
  final DateTime Function() now;
  final TextStyle? style;

  static String label(AppLocalizations l10n, Duration remaining) {
    final seconds = remaining.isNegative ? 0 : remaining.inSeconds;
    final minutes = ((seconds + 59) ~/ 60).clamp(1, 1 << 30);

    if (seconds <= 3600) {
      return l10n.dexComeBackInMinutes(minutes);
    }

    return l10n.dexComeBackInHours((seconds + 3599) ~/ 3600);
  }

  @override
  State<ComebackHint> createState() => _ComebackHintState();
}

class _ComebackHintState extends State<ComebackHint> {
  Timer? _timer;
  late Duration _remaining = _computeRemaining();

  Duration _computeRemaining() => widget.target.difference(widget.now());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _remaining = _computeRemaining());
      }
    });
  }

  @override
  void didUpdateWidget(ComebackHint oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.target != widget.target) {
      _remaining = _computeRemaining();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      ComebackHint.label(AppLocalizations.of(context), _remaining),
      style: widget.style,
    );
  }
}
