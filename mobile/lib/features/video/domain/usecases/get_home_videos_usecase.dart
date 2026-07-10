import '../entities/video_entity.dart';
import '../repositories/video_repository.dart';

class GetHomeVideosUseCase {
  final VideoRepository repository;

  GetHomeVideosUseCase(this.repository);

  Future<List<VideoEntity>> call() => repository.getHomeVideos();
}
