import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/story_remote_datasource.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../domain/repositories/story_repository.dart';
import '../../../../core/providers/dio_provider.dart';

final storyRemoteDataSourceProvider = Provider<StoryRemoteDataSource>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  return StoryRemoteDataSourceImpl(dio);
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(ref.read(storyRemoteDataSourceProvider));
});
