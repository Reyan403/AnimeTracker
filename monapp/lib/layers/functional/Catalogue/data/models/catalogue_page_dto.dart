import '../../domain/entities/catalogue_page.dart';
import 'catalogue_anime_dto.dart';

abstract final class CataloguePageDto {
  static CataloguePage fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? const [];
    final pagination = json['pagination'] as Map<String, dynamic>?;

    return CataloguePage(
      animes: [
        for (final node in data)
          CatalogueAnimeDto.fromJson(node as Map<String, dynamic>),
      ],
      hasMore: pagination?['has_next_page'] as bool? ?? false,
    );
  }
}
