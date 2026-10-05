abstract interface class BoosterScheduleGateway {
  String? get lastOpenedDay;

  Future<void> markOpened(String day);
}
