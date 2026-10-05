import 'package:equatable/equatable.dart';

class BoosterAvailability extends Equatable {
  const BoosterAvailability({required this.isAvailable, required this.nextAt});

  final bool isAvailable;
  final DateTime nextAt;

  @override
  List<Object?> get props => [isAvailable, nextAt];
}
