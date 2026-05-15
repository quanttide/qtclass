enum Level {
  introductory('初级'),
  intermediate('中级'),
  advanced('高级');

  final String label;
  const Level(this.label);
}

class Lecture {
  final String id;
  final String title;
  final String description;
  final List<String> targets;
  final List<String> objectives;
  final List<String> points;
  final Level level;

  const Lecture({
    required this.id,
    required this.title,
    required this.description,
    required this.targets,
    required this.objectives,
    required this.points,
    required this.level,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targets: (json['targets'] as List)
          .map((e) => e as String)
          .toList(),
      objectives: (json['objectives'] as List)
          .map((e) => e as String)
          .toList(),
      points: (json['points'] as List)
          .map((e) => e as String)
          .toList(),
      level: Level.values.firstWhere(
        (l) => l.label == json['level'] as String,
      ),
    );
  }
}
