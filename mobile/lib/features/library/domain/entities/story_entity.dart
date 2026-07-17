/// Domain entity for story/book - no Flutter imports.
class StoryPageEntity {
  final int id;
  final String text;
  final String image;

  const StoryPageEntity({
    required this.id,
    required this.text,
    required this.image,
  });
}

class StoryEntity {
  final int id;
  /// Stable backend Mongo ObjectId used for detail fetches.
  final String apiId;
  final String title;
  final String coverImage;
  final List<StoryPageEntity> pages;
  final bool isPremium;

  const StoryEntity({
    required this.id,
    this.apiId = '',
    required this.title,
    required this.coverImage,
    required this.pages,
    this.isPremium = false,
  });

  StoryEntity copyWith({
    int? id,
    String? apiId,
    String? title,
    String? coverImage,
    List<StoryPageEntity>? pages,
    bool? isPremium,
  }) {
    return StoryEntity(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      pages: pages ?? this.pages,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
