import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../domain/entities/card_rarity.dart';
import '../card/rarity_style.dart';
import 'burst_painter.dart';

class RarityBurst extends StatefulWidget {
  const RarityBurst({
    required this.rarity,
    this.center = const Alignment(0, -0.1),
    super.key,
  });

  static const Duration duration = Duration(milliseconds: 1600);
  static const double startDelay = 0.25;

  final CardRarity rarity;
  final Alignment center;

  @override
  State<RarityBurst> createState() => _RarityBurstState();
}

class _RarityBurstState extends State<RarityBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _burst = AnimationController(
    vsync: this,
    duration: RarityBurst.duration,
  );
  late final List<Spark> _sparks = Spark.generate(widget.rarity.sparkleCount);
  bool _hasStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasStarted && !MediaQuery.disableAnimationsOf(context)) {
      _hasStarted = true;
      _burst.forward();
    }
  }

  @override
  void dispose() {
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final tone = widget.rarity.color(palette);

    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _burst,
          builder: (context, _) {
            final started =
                (_burst.value - RarityBurst.startDelay) /
                (1 - RarityBurst.startDelay);

            if (started <= 0 || _burst.isDismissed) {
              return const SizedBox.expand();
            }

            return CustomPaint(
              size: Size.infinite,
              painter: BurstPainter(
                progress: started.clamp(0.0, 1.0),
                center: widget.center,
                tone: tone,
                glow: palette.starGlow,
                sparks: _sparks,
                hasFlash: widget.rarity.isLegendary,
              ),
            );
          },
        ),
      ),
    );
  }
}
