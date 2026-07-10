import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/video_remote_datasource.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../../domain/repositories/video_repository.dart';
import '../../domain/usecases/get_home_videos_usecase.dart';
import '../../domain/usecases/get_sample_videos_usecase.dart';
import '../../domain/usecases/get_video_list_usecase.dart';
import '../../../../core/providers/dio_provider.dart';

final videoRemoteDataSourceProvider = Provider<VideoRemoteDataSource>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  return VideoRemoteDataSourceImpl(dio);
});

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return VideoRepositoryImpl(ref.read(videoRemoteDataSourceProvider));
});

final getHomeVideosUseCaseProvider = Provider<GetHomeVideosUseCase>((ref) {
  return GetHomeVideosUseCase(ref.read(videoRepositoryProvider));
});

final getVideoListUseCaseProvider = Provider<GetVideoListUseCase>((ref) {
  return GetVideoListUseCase(ref.read(videoRepositoryProvider));
});

final getSampleVideosUseCaseProvider = Provider<GetSampleVideosUseCase>((ref) {
  return GetSampleVideosUseCase(ref.read(videoRepositoryProvider));
});
