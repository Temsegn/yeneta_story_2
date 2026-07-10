import '../entities/video_entity.dart';
import '../repositories/video_repository.dart';

class GetVideoListUseCase {
  final VideoRepository repository;

  GetVideoListUseCase(this.repository);

  Future<List<VideoEntity>> call() => repository.getVideoListVideos();
}
