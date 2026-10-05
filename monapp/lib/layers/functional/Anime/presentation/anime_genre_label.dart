import '../../../../l10n/app_localizations.dart';
import '../domain/entities/anime_genre.dart';

String genreLabel(AppLocalizations l10n, AnimeGenre genre) =>
    switch (genre.slug) {
      'action' => l10n.genreAction,
      'adventure' => l10n.genreAdventure,
      'comedy' => l10n.genreComedy,
      'drama' => l10n.genreDrama,
      'fantasy' => l10n.genreFantasy,
      'horror' => l10n.genreHorror,
      'mystery' => l10n.genreMystery,
      'romance' => l10n.genreRomance,
      'science-fiction' => l10n.genreScienceFiction,
      'slice-of-life' => l10n.genreSliceOfLife,
      'sports' => l10n.genreSports,
      'supernatural' => l10n.genreSupernatural,
      'thriller' => l10n.genreThriller,
      'psychological' => l10n.genrePsychological,
      'mecha' => l10n.genreMecha,
      _ => genre.title,
    };
