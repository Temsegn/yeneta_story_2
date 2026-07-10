/// Domain entity for story/book - no Flutter imports.
class StoryPageEntity {
  final int id;
  final String text;
  final String image;

  const StoryPageEntity({required this.id, required this.text, required this.image});
}

class StoryEntity {
  final int id;
  final String title;
  final String coverImage;
  final List<StoryPageEntity> pages;
  final bool isPremium;

  const StoryEntity({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.pages,
    this.isPremium = false,
  });
}
