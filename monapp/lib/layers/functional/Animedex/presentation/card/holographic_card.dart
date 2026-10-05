import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/dex_card.dart';
import 'card_face.dart';
import 'card_metrics.dart';
import 'holo_shine.dart';
import 'rarity_style.dart';
import 'tilt_surface.dart';

class HolographicCard extends StatefulWidget {
  const HolographicCard({
    required this.card,
    this.isLive = false,
    this.compact = false,
    this.heroTag,
    super.key,
  });

  final DexCard card;
  final bool isLive;
  final bool compact;
  final String? heroTag;

  @override
  State<HolographicCard> createState() => _HolographicCardState();
}

class _HolographicCardState extends State<HolographicCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shine = AnimationController(
    vsync: this,
    duration: CardMetrics.shineLoop,
    value: CardMetrics.restingShine,
  );
  final ValueNotifier<Offset> _tilt = ValueNotifier(Offset.zero);
  bool _isHovered = false;

  bool get _isMotionAllowed =>
      widget.card.rarity.isHolographic &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLoop();
  }

  @override
  void didUpdateWidget(HolographicCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncLoop();
  }

  @override
  void dispose() {
    _shine.dispose();
    _tilt.dispose();
    super.dispose();
  }

  void _syncLoop() {
    final shouldLoop = _isMotionAllowed && (widget.isLive || _isHovered);

    if (shouldLoop && !_shine.isAnimating) {
      _shine.repeat();
    } else if (!shouldLoop && _shine.isAnimating) {
      _shine.stop();
    }
  }

  void _setHovered(bool value) {
    _isHovered = value;
    _syncLoop();
  }

  void _setTilt(Offset value) {
    if (!MediaQuery.disableAnimationsOf(context)) {
      _tilt.value = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final l10n = AppLocalizations.of(context);
    final face = CardFace(
      card: card,
      heroTag: widget.heroTag,
      compact: widget.compact,
    );
    final surface = Stack(
      fit: StackFit.expand,
      children: [
        face,
        if (card.rarity.isHolographic)
          HoloShine(rarity: card.rarity, phase: _shine, tilt: _tilt),
      ],
    );

    return Semantics(
      excludeSemantics: true,
      label: l10n.dexCardLabel(card.title, card.rarity.label(l10n)),
      child: RepaintBoundary(
        child: AspectRatio(
          aspectRatio: CardMetrics.aspectRatio,
          child: TiltSurface(
            enableTouch: widget.isLive,
            onHoverChanged: _setHovered,
            onTilt: _setTilt,
            child: ValueListenableBuilder<Offset>(
              valueListenable: _tilt,
              child: surface,
              builder: (context, tilt, child) => Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, CardMetrics.tiltDepth)
                  ..rotateX(-tilt.dy * CardMetrics.maxTilt)
                  ..rotateY(tilt.dx * CardMetrics.maxTilt),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
