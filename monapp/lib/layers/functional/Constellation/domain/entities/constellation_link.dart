import 'package:equatable/equatable.dart';

class ConstellationLink extends Equatable {
  const ConstellationLink({
    required this.fromId,
    required this.toId,
    required this.sharedGenres,
  });

  final int fromId;
  final int toId;
  final int sharedGenres;

  @override
  List<Object?> get props => [fromId, toId, sharedGenres];
}
