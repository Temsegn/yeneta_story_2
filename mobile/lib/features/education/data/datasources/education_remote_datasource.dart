import 'package:dio/dio.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/education_video_entity.dart';

abstract class EducationRemoteDataSource {
  Future<List<EducationVideoEntity>> getVideosByAge(String ageGroup);
}

class EducationRemoteDataSourceImpl implements EducationRemoteDataSource {
  final Dio _dio;

  EducationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<EducationVideoEntity>> getVideosByAge(String ageGroup) async {
    try {
      final response = await _dio.get(
        ApiConfig.education,
        queryParameters: {
          'page': 1,
          'limit': 50,
          'ageGroup': ageGroup,
        },
      );

      return (response.data['education'] as List? ?? []).map((json) {
        final map = json as Map<String, dynamic>;
        final apiId = (map['_id'] ?? map['id'] ?? '').toString();
        return EducationVideoEntity(
          id: apiId.hashCode,
          apiId: apiId,
          title: map['title'] as String? ?? '',
          thumbnail: map['thumbnail'] as String? ?? '',
          duration: map['duration'] as String? ?? '',
          description: map['description'] as String? ?? '',
          author: map['author'] as String? ?? 'Yeneta',
          videoUrl: map['videoUrl'] as String? ?? '',
          isPremium: map['isPremium'] as bool? ?? false,
        );
      }).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
