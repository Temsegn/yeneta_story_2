import '../entities/story_entity.dart';

abstract class StoryRepository {
  Future<List<StoryEntity>> getStories();
  Future<List<StoryEntity>> getBooks();
}
