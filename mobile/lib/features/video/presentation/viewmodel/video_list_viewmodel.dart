import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/features/video/domain/entities/video_entity.dart';
import 'package:kids_app/features/video/domain/usecases/get_video_list_usecase.dart';
import 'package:kids_app/features/video/presentation/providers/video_providers.dart';

class VideoListViewModel extends AsyncNotifier<List<VideoEntity>> {
  @override
  Future<List<VideoEntity>> build() async {
    final useCase = ref.read(getVideoListUseCaseProvider);
    return useCase();
  }
}

final videoListViewModelProvider = AsyncNotifierProvider<VideoListViewModel, List<VideoEntity>>(VideoListViewModel.new);
