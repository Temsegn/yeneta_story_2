import 'package:dio/dio.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../models/video_model.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getHomeVideos();
  Future<List<VideoModel>> getVideoListVideos();
  Future<VideoModel> getVideoById(String id);
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final Dio _dio;

  VideoRemoteDataSourceImpl(this._dio);

  @override
  Future<List<VideoModel>> getHomeVideos() async {
    try {
      final response = await _dio.get(
        ApiConfig.videos,
        queryParameters: {'page': 1, 'limit': 20},
      );

      final videos = (response.data['videos'] as List)
          .map((json) => VideoModel.fromJson(json))
          .toList();
      return videos;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<List<VideoModel>> getVideoListVideos() async {
    try {
      final response = await _dio.get(
        ApiConfig.videos,
        queryParameters: {'page': 1, 'limit': 50},
      );

      final videos = (response.data['videos'] as List)
          .map((json) => VideoModel.fromJson(json))
          .toList();
      return videos;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<VideoModel> getVideoById(String id) async {
    try {
      final response = await _dio.get('${ApiConfig.videos}/$id');
      return VideoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
