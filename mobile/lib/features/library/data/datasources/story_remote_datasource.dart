import 'package:dio/dio.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/network/api_config.dart';
import '../../domain/entities/story_entity.dart';

/// Fetches stories/books from the backend and falls back to sample data
/// when the backend has no content or is unreachable.
abstract class StoryRemoteDataSource {
  Future<List<StoryEntity>> getStories();
  Future<List<StoryEntity>> getBooks();
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final Dio _dio;

  StoryRemoteDataSourceImpl(this._dio);

  @override
  Future<List<StoryEntity>> getStories() async {
    return _fetch(ApiConfig.stories, 'stories', SampleData.stories());
  }

  @override
  Future<List<StoryEntity>> getBooks() async {
    return _fetch(ApiConfig.books, 'books', SampleData.books());
  }

  Future<List<StoryEntity>> _fetch(
    String path,
    String key,
    List<StoryEntity> fallback,
  ) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: {'page': 1, 'limit': 20},
      );
      final data = response.data;
      final rawList = (data is Map && data[key] is List)
          ? data[key] as List
          : (data is List ? data : const []);

      final items = rawList
          .whereType<Map<String, dynamic>>()
          .map(_mapToEntity)
          .toList();

      // If the backend has no data yet, show sample content.
      return items.isEmpty ? fallback : items;
    } catch (_) {
      return fallback;
    }
  }

  StoryEntity _mapToEntity(Map<String, dynamic> json) {
    final pagesRaw = (json['pages'] as List?) ?? const [];
    final cover = (json['coverImageUrl'] ?? json['coverImage'] ?? '') as String;

    final pages = <StoryPageEntity>[];
    for (var i = 0; i < pagesRaw.length; i++) {
      final p = pagesRaw[i];
      if (p is Map<String, dynamic>) {
        pages.add(StoryPageEntity(
          id: (p['pageNumber'] as num?)?.toInt() ?? (i + 1),
          text: (p['content'] ?? p['title'] ?? '') as String,
          image: (p['imageUrl'] ?? cover) as String,
        ));
      }
    }

    return StoryEntity(
      id: (json['_id'] ?? json['id'] ?? json.hashCode).hashCode,
      title: (json['title'] ?? '') as String,
      coverImage: cover,
      pages: pages,
      isPremium: json['isPremium'] as bool? ?? true,
    );
  }
}
