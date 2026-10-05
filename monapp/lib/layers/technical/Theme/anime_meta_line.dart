import '../../../l10n/app_localizations.dart';

String animeMetaLine(
  AppLocalizations l10n, {
  required String format,
  required int year,
  required int episodeCount,
}) =>
    [
      format,
      if (year > 0) '$year',
      if (episodeCount > 0) l10n.episodesCount(episodeCount),
    ].join(' · ');
