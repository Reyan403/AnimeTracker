import '../../../../l10n/app_localizations.dart';
import '../domain/entities/scheduled_release.dart';

String releaseCountdown(
  AppLocalizations l10n,
  ScheduledRelease release,
  DateTime now,
) {
  final days = release.daysUntil(now);

  return switch (days) {
    0 => l10n.releaseToday,
    1 => l10n.releaseTomorrow,
    -1 => l10n.releaseYesterday,
    > 1 => l10n.releaseInDays(days),
    _ => l10n.releaseDaysAgo(-days),
  };
}
