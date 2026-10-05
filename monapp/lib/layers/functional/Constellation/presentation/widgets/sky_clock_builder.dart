import 'package:flutter/widgets.dart';

typedef SkyClockWidgetBuilder = Widget Function(
  BuildContext context,
  AnimationController clock,
  bool isAnimated,
);

class SkyClockBuilder extends StatefulWidget {
  const SkyClockBuilder({required this.builder, super.key});

  static const double loopSeconds = 3600;

  final SkyClockWidgetBuilder builder;

  @override
  State<SkyClockBuilder> createState() => _SkyClockBuilderState();
}

class _SkyClockBuilderState extends State<SkyClockBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock = AnimationController.unbounded(
    vsync: this,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MediaQuery.disableAnimationsOf(context)) {
      _clock.stop();
    } else if (!_clock.isAnimating) {
      _clock.repeat(
        min: 0,
        max: SkyClockBuilder.loopSeconds,
        period: const Duration(seconds: 3600),
      );
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _clock, !MediaQuery.disableAnimationsOf(context));
}
