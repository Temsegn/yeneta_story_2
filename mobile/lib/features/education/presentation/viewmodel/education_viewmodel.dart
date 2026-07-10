import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/features/education/domain/entities/education_video_entity.dart';
import 'package:kids_app/features/education/data/datasources/education_remote_datasource.dart';

final educationRemoteDataSourceProvider = Provider<EducationRemoteDataSource>((ref) {
  return EducationRemoteDataSourceImpl();
});

final educationViewModelProvider = FutureProvider.family<List<EducationVideoEntity>, String>((ref, ageGroup) async {
  final ds = ref.read(educationRemoteDataSourceProvider);
  return ds.getVideosByAge(ageGroup);
});
