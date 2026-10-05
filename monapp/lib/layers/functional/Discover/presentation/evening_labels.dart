import '../../../../l10n/app_localizations.dart';
import '../domain/entities/evening_mood.dart';

extension EveningMoodLabel on EveningMood {
  String labelOf(AppLocalizations l10n) => switch (this) {
        EveningMood.any => l10n.moodAny,
        EveningMood.relaxed => l10n.moodRelaxed,
        EveningMood.action => l10n.moodAction,
        EveningMood.emotional => l10n.moodEmotional,
        EveningMood.mystery => l10n.moodMystery,
      };
}
