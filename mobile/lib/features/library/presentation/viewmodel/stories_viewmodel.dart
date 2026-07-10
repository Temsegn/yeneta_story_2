import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/features/library/domain/entities/story_entity.dart';
import 'package:kids_app/features/library/domain/repositories/story_repository.dart';
import 'package:kids_app/features/library/presentation/providers/library_providers.dart';

final storiesViewModelProvider = FutureProvider.family<List<StoryEntity>, bool>((ref, isStories) async {
  final repo = ref.read(storyRepositoryProvider);
  return isStories ? repo.getStories() : repo.getBooks();
});
