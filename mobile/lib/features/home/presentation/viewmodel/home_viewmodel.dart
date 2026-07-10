import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/features/video/domain/entities/video_entity.dart';
import 'package:kids_app/features/video/domain/usecases/get_home_videos_usecase.dart';
import 'package:kids_app/features/video/presentation/providers/video_providers.dart';

class HomeViewModel extends AsyncNotifier<List<VideoEntity>> {
  @override
  Future<List<VideoEntity>> build() async {
    final useCase = ref.read(getHomeVideosUseCaseProvider);
    return useCase();
  }
}

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, List<VideoEntity>>(HomeViewModel.new);
