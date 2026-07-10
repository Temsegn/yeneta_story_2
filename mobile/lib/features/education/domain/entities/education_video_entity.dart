class EducationVideoEntity {
  final int id;
  final String title;
  final String thumbnail;
  final String duration;
  final String description;
  final String author;
  final bool isPremium;

  const EducationVideoEntity({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.duration,
    required this.description,
    required this.author,
    this.isPremium = false,
  });
}
