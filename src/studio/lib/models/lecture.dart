class Lecture {
  final String id;
  final String title;
  final String description;
  final List<String> targets;
  final List<String> objectives;
  // 单个课时的要点提纲，不是多课时大纲
  final List<String> points;
  final int duration;
  final String level;

  const Lecture({
    required this.id,
    required this.title,
    required this.description,
    required this.targets,
    required this.objectives,
    required this.points,
    required this.duration,
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
      duration: json['duration'] as int,
      level: json['level'] as String,
    );
  }
}
