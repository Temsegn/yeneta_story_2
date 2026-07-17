import '../../domain/entities/video_entity.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required super.id,
    required super.title,
    required super.thumbnail,
    required super.duration,
    super.description,
    super.author,
    super.videoUrl,
    super.isPremium,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '') as String,
      thumbnail: (json['thumbnail'] ?? '') as String? ?? '',
      duration: '', // Backend doesn't have duration field, calculate from video if needed
      description: json['description'] as String?,
      author: json['createdBy']?.toString(),
      videoUrl: json['videoUrl'] as String?,
      isPremium: json['isPremium'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'thumbnail': thumbnail,
      'description': description,
      'createdBy': author,
      'videoUrl': videoUrl,
      'isPremium': isPremium,
    };
  }
}
