import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/change_spoiler_guard_use_case.dart';
import '../../domain/use_cases/read_spoiler_guard_use_case.dart';

class SettingsState extends Equatable {
  const SettingsState({required this.isSpoilerGuardEnabled});

  final bool isSpoilerGuardEnabled;

  @override
  List<Object?> get props => [isSpoilerGuardEnabled];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._readSpoilerGuard, this._changeSpoilerGuard)
      : super(SettingsState(isSpoilerGuardEnabled: _readSpoilerGuard()));

  final ReadSpoilerGuardUseCase _readSpoilerGuard;
  final ChangeSpoilerGuardUseCase _changeSpoilerGuard;

  void changeSpoilerGuard({required bool enabled}) {
    _changeSpoilerGuard(enabled: enabled);
    emit(SettingsState(isSpoilerGuardEnabled: _readSpoilerGuard()));
  }
}
