import '../entities/video_entity.dart';
import '../repositories/video_repository.dart';

class GetSampleVideosUseCase {
  final VideoRepository repository;

  GetSampleVideosUseCase(this.repository);

  Future<List<VideoEntity>> call() => repository.getSampleVideos();
}
