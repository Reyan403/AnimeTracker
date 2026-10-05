import 'package:flutter/material.dart';

import 'anime_sheet_view.dart';

Future<void> openAnimeSheet(
  BuildContext context, {
  required int animeId,
  required String title,
  required String heroTag,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => AnimeSheetView(
        animeId: animeId,
        title: title,
        heroTag: heroTag,
      ),
    ),
  );
}
