import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';

class AnimePoster extends StatelessWidget {
  const AnimePoster({required this.title, super.key});

  final String title;

  List<Color> get _gradient {
    var sum = 0;
    for (final unit in title.codeUnits) {
      sum = (sum + unit) % AppColors.posterGradients.length;
    }
    return AppColors.posterGradients[sum];
  }

  static bool _startsCapitalised(String word) {
    final first = word[0];
    return first != first.toLowerCase() && first == first.toUpperCase();
  }

  String get _initials {
    final words = title
        .split(RegExp(r'[\s:]+'))
        .where((word) => word.isNotEmpty)
        .toList();
    final capitalised = words.where(_startsCapitalised).take(2);
    final kept = capitalised.isEmpty ? words.take(2) : capitalised;

    return kept.map((word) => word[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.posterWidth,
      height: AppSpacing.posterHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.posterRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradient,
        ),
      ),
      child: Text(
        _initials,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
