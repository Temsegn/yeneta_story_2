class EducationVideoEntity {
  final int id;
  final String apiId;
  final String title;
  final String thumbnail;
  final String duration;
  final String description;
  final String author;
  final String videoUrl;
  final bool isPremium;

  const EducationVideoEntity({
    required this.id,
    this.apiId = '',
    required this.title,
    required this.thumbnail,
    required this.duration,
    required this.description,
    required this.author,
    this.videoUrl = '',
    this.isPremium = false,
  });
}
