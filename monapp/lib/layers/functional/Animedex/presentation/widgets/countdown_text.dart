import 'dart:async';

import 'package:flutter/material.dart';

class CountdownText extends StatefulWidget {
  const CountdownText({
    required this.target,
    required this.onElapsed,
    this.now = DateTime.now,
    this.style,
    super.key,
  });

  final DateTime target;
  final VoidCallback onElapsed;
  final DateTime Function() now;
  final TextStyle? style;

  static String format(Duration remaining) {
    String two(int value) => value.toString().padLeft(2, '0');

    return '${two(remaining.inHours)}:'
        '${two(remaining.inMinutes.remainder(60))}:'
        '${two(remaining.inSeconds.remainder(60))}';
  }

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  Timer? _timer;
  late Duration _remaining = _computeRemaining();

  Duration _computeRemaining() {
    final left = widget.target.difference(widget.now());

    return left.isNegative ? Duration.zero : left;
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(CountdownText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.target != widget.target) {
      _remaining = _computeRemaining();
      _start();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();

    if (_remaining == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onElapsed();
        }
      });

      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final remaining = _computeRemaining();

    if (remaining == Duration.zero) {
      _timer?.cancel();
      widget.onElapsed();
    }

    if (mounted) {
      setState(() => _remaining = remaining);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(CountdownText.format(_remaining), style: widget.style);
  }
}
