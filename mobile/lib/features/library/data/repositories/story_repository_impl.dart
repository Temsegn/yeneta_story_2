import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_remote_datasource.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remote;

  StoryRepositoryImpl(this.remote);

  @override
  Future<List<StoryEntity>> getStories() => remote.getStories();

  @override
  Future<List<StoryEntity>> getBooks() => remote.getBooks();
}
