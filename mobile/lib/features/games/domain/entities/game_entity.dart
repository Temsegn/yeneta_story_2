/// Game type matching React: memory-match, balloon-pop, drawing, math-quiz, word-match.
class GameEntity {
  final int id;
  final String name;
  final String category;
  final String emoji;
  final String color; // e.g. "bg-purple-500"
  final String? type;

  const GameEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.color,
    this.type,
  });
}
