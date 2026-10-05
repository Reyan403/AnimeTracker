import 'package:equatable/equatable.dart';

import '../../domain/entities/anime_sheet.dart';

enum AnimeSheetStatus { loading, success, failure }

class AnimeSheetState extends Equatable {
  const AnimeSheetState({
    this.status = AnimeSheetStatus.loading,
    this.sheet,
    this.isSynopsisHidden = false,
  });

  final AnimeSheetStatus status;
  final AnimeSheet? sheet;
  final bool isSynopsisHidden;

  @override
  List<Object?> get props => [status, sheet, isSynopsisHidden];
}
