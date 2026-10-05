import '../gateways/settings_gateway.dart';

class ChangeSpoilerGuardUseCase {
  const ChangeSpoilerGuardUseCase(this._settings);

  final SettingsGateway _settings;

  void call({required bool enabled}) =>
      _settings.changeSpoilerGuard(enabled: enabled);
}
