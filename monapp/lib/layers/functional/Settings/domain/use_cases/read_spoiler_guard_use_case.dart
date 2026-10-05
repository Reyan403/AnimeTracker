import '../gateways/settings_gateway.dart';

class ReadSpoilerGuardUseCase {
  const ReadSpoilerGuardUseCase(this._settings);

  final SettingsGateway _settings;

  bool call() => _settings.isSpoilerGuardEnabled;
}
