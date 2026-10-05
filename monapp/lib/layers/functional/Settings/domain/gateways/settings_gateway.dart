abstract interface class SettingsGateway {
  bool get isSpoilerGuardEnabled;

  void changeSpoilerGuard({required bool enabled});
}
