import '../../../../technical/Preferences/app_preferences.dart';
import '../../../../technical/Preferences/preferences_key.dart';
import '../../domain/gateways/booster_schedule_gateway.dart';

class PreferencesBoosterScheduleGateway implements BoosterScheduleGateway {
  const PreferencesBoosterScheduleGateway(this._preferences);

  final AppPreferences _preferences;

  @override
  String? get lastOpenedDay =>
      _preferences.readString(PreferencesKey.lastBoosterDay);

  @override
  Future<void> markOpened(String day) =>
      _preferences.writeString(PreferencesKey.lastBoosterDay, day);
}
