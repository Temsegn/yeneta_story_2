import 'package:dio/dio.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/network/api_config.dart';
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

      final list = (response.data['education'] as List? ?? [])
          .map((json) {
            final map = json as Map<String, dynamic>;
            return EducationVideoEntity(
              id: (map['_id'] ?? map['id'] ?? '').hashCode,
              title: map['title'] as String? ?? '',
              thumbnail: map['thumbnail'] as String? ?? '',
              duration: map['duration'] as String? ?? '',
              description: map['description'] as String? ?? '',
              author: map['author'] as String? ?? 'Yeneta',
              isPremium: map['isPremium'] as bool? ?? false,
            );
          })
          .toList();

      return list.isEmpty ? SampleData.educationVideos() : list;
    } catch (_) {
      return SampleData.educationVideos();
    }
  }
}
