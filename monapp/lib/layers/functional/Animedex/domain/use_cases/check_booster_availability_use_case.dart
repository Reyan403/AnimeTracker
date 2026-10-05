import '../entities/booster_availability.dart';
import '../gateways/booster_schedule_gateway.dart';
import 'booster_day.dart';

class CheckBoosterAvailabilityUseCase {
  const CheckBoosterAvailabilityUseCase(
    this._schedule, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final BoosterScheduleGateway _schedule;
  final DateTime Function() _now;

  BoosterAvailability call() {
    final moment = _now();

    return BoosterAvailability(
      isAvailable: _schedule.lastOpenedDay != BoosterDay.keyOf(moment),
      nextAt: BoosterDay.midnightAfter(moment),
    );
  }
}
