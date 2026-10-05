import 'package:flutter/painting.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../../Discover/domain/entities/evening_mood.dart';

abstract final class StarPalette {
  static List<Color> cycleOf(AppPalette palette) => [
    palette.candy,
    palette.sky,
    palette.sun,
    palette.rarityEpic,
    palette.rarityRare,
    palette.completed,
    palette.watching,
    palette.toWatch,
  ];

  static Color colorAt(AppPalette palette, int index) {
    final cycle = cycleOf(palette);

    return cycle[index % cycle.length];
  }

  static Map<String, Color> colorsOf(
    AppPalette palette,
    List<EveningMood> genres,
  ) => {
    for (var index = 0; index < genres.length; index++)
      genres[index].name: colorAt(palette, index),
  };
}
