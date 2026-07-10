import '../../domain/entities/video_entity.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_remote_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remote;

  VideoRepositoryImpl(this.remote);

  @override
  Future<List<VideoEntity>> getHomeVideos() => remote.getHomeVideos();

  @override
  Future<List<VideoEntity>> getVideoListVideos() => remote.getVideoListVideos();

  @override
  Future<List<VideoEntity>> getSampleVideos() => remote.getVideoListVideos();
}
