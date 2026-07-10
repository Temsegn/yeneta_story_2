import '../entities/video_entity.dart';

abstract class VideoRepository {
  Future<List<VideoEntity>> getHomeVideos();
  Future<List<VideoEntity>> getVideoListVideos();
  Future<List<VideoEntity>> getSampleVideos();
}
