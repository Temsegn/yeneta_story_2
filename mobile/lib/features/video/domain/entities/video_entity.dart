/// Domain entity - no Flutter imports.
class VideoEntity {
  final String id; // Changed from int to String (MongoDB _id)
  final String title;
  final String thumbnail;
  final String duration;
  final String? description;
  final String? author;
  final String? videoUrl;
  final bool? isPremium;

  const VideoEntity({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.duration,
    this.description,
    this.author,
    this.videoUrl,
    this.isPremium,
  });
}
