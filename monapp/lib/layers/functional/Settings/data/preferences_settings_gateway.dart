import 'dart:async';

import '../../../technical/Preferences/app_preferences.dart';
import '../../../technical/Preferences/preferences_key.dart';
import '../domain/gateways/settings_gateway.dart';

class PreferencesSettingsGateway implements SettingsGateway {
  const PreferencesSettingsGateway(this._preferences);

  static const bool spoilerGuardByDefault = true;

  final AppPreferences _preferences;

  @override
  bool get isSpoilerGuardEnabled => _preferences.readBool(
        PreferencesKey.spoilerGuard,
        fallback: spoilerGuardByDefault,
      );

  @override
  void changeSpoilerGuard({required bool enabled}) => unawaited(
        _preferences.writeBool(PreferencesKey.spoilerGuard, value: enabled),
      );
}
