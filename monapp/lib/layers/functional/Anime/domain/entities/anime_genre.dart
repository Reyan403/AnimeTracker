import 'package:equatable/equatable.dart';

class AnimeGenre extends Equatable {
  const AnimeGenre({required this.slug, required this.title});

  final String slug;
  final String title;

  @override
  List<Object?> get props => [slug, title];
}
