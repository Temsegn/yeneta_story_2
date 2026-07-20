import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/features/education/presentation/viewmodel/education_viewmodel.dart';
import 'package:kids_app/features/home/presentation/viewmodel/home_viewmodel.dart';
import 'package:kids_app/features/library/presentation/viewmodel/stories_viewmodel.dart';
import 'package:kids_app/features/shell/presentation/viewmodel/shell_viewmodel.dart';
import 'package:kids_app/features/video/presentation/viewmodel/video_list_viewmodel.dart';

/// Force-refresh mobile lists whenever a bottom tab is opened.
/// Riverpod caches the first successful fetch; without this, admin create/update/delete
/// never appears until the app is restarted.
void refreshContentForTab(WidgetRef ref, TabType tab) {
  switch (tab) {
    case TabType.home:
      ref.invalidate(homeViewModelProvider);
      break;
    case TabType.video:
      ref.invalidate(videoListViewModelProvider);
      break;
    case TabType.library:
      // Default library view is Stories — always refetch both so Books is fresh too.
      ref.invalidate(storiesViewModelProvider);
      break;
    case TabType.education:
      ref.invalidate(educationViewModelProvider);
      break;
    case TabType.games:
      break;
  }
}
