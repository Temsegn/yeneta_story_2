import 'package:dio/dio.dart';
import '../../../../core/data/sample_data.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/story_entity.dart';

/// Fetches stories/books from the backend and falls back to sample data
/// when the backend has no content or is unreachable.
abstract class StoryRemoteDataSource {
  Future<List<StoryEntity>> getStories();
  Future<List<StoryEntity>> getBooks();
  Future<StoryEntity> getStoryById(String id);
  Future<StoryEntity> getBookById(String id);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final Dio _dio;

  StoryRemoteDataSourceImpl(this._dio);

  @override
  Future<List<StoryEntity>> getStories() async {
    return _fetchList(ApiConfig.stories, 'stories', SampleData.stories());
  }

  @override
  Future<List<StoryEntity>> getBooks() async {
    return _fetchList(ApiConfig.books, 'books', SampleData.books());
  }

  @override
  Future<StoryEntity> getStoryById(String id) async {
    return _fetchDetail('${ApiConfig.stories}/$id');
  }

  @override
  Future<StoryEntity> getBookById(String id) async {
    return _fetchDetail('${ApiConfig.books}/$id');
  }

  Future<List<StoryEntity>> _fetchList(
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
          .whereType<Map>()
          .map((item) => _mapToEntity(Map<String, dynamic>.from(item)))
          .toList();

      // If the backend has no data yet, show sample content.
      return items.isEmpty ? fallback : items;
    } catch (_) {
      return fallback;
    }
  }

  Future<StoryEntity> _fetchDetail(String path) async {
    try {
      final response = await _dio.get(path);
      final data = response.data;
      if (data is! Map) {
        throw ApiException('Invalid content response');
      }
      return _mapToEntity(Map<String, dynamic>.from(data));
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  StoryEntity _mapToEntity(Map<String, dynamic> json) {
    final pagesRaw = (json['pages'] as List?) ?? const [];
    final cover = (json['coverImageUrl'] ?? json['coverImage'] ?? '') as String;
    final apiId = (json['_id'] ?? json['id'] ?? '').toString();

    final pages = <StoryPageEntity>[];
    for (var i = 0; i < pagesRaw.length; i++) {
      final p = pagesRaw[i];
      if (p is Map) {
        final page = Map<String, dynamic>.from(p);
        pages.add(
          StoryPageEntity(
            id: (page['pageNumber'] as num?)?.toInt() ?? (i + 1),
            text: (page['content'] ?? page['title'] ?? '') as String,
            image: (page['imageUrl'] ?? cover) as String,
          ),
        );
      }
    }

    return StoryEntity(
      id: apiId.hashCode,
      apiId: apiId,
      title: (json['title'] ?? '') as String,
      coverImage: cover,
      pages: pages,
      isPremium: json['isPremium'] as bool? ?? true,
    );
  }
}
