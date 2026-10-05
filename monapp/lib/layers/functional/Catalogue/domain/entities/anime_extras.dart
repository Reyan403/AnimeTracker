import 'package:equatable/equatable.dart';

import 'catalogue_anime.dart';

enum RelationRole { prequel, sequel }

class StreamingLink extends Equatable {
  const StreamingLink({required this.siteName, required this.url});

  final String siteName;
  final String url;

  @override
  List<Object?> get props => [siteName, url];
}

class RelatedAnime extends Equatable {
  const RelatedAnime({required this.anime, required this.role});

  final CatalogueAnime anime;
  final RelationRole role;

  @override
  List<Object?> get props => [anime, role];
}

class AnimeExtras extends Equatable {
  const AnimeExtras({this.streamingLinks = const [], this.related = const []});

  static const AnimeExtras none = AnimeExtras();

  final List<StreamingLink> streamingLinks;
  final List<RelatedAnime> related;

  bool get isEmpty => streamingLinks.isEmpty && related.isEmpty;

  @override
  List<Object?> get props => [streamingLinks, related];
}
