import '../../../../core/data/sample_data.dart';
import '../../domain/entities/education_video_entity.dart';

abstract class EducationRemoteDataSource {
  Future<List<EducationVideoEntity>> getVideosByAge(String ageGroup);
}

class EducationRemoteDataSourceImpl implements EducationRemoteDataSource {
  @override
  Future<List<EducationVideoEntity>> getVideosByAge(String ageGroup) async {
    // No dedicated backend endpoint yet; show sample education content.
    return SampleData.educationVideos();
  }
}
