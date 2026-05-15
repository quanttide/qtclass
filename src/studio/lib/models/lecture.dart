class Lecture {
  final String id;
  final String sessionId;
  final String title;
  final String description;
  final String targetAudience;
  final List<String> learningObjectives;
  final List<String> outline;
  final int durationMinutes;
  final String difficulty;
  final String format;

  const Lecture({
    required this.id,
    required this.sessionId,
    required this.title,
    required this.description,
    required this.targetAudience,
    required this.learningObjectives,
    required this.outline,
    required this.durationMinutes,
    required this.difficulty,
    required this.format,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetAudience: json['target_audience'] as String,
      learningObjectives: (json['learning_objectives'] as List)
          .map((e) => e as String)
          .toList(),
      outline: (json['outline'] as List)
          .map((e) => e as String)
          .toList(),
      durationMinutes: json['duration_minutes'] as int,
      difficulty: json['difficulty'] as String,
      format: json['format'] as String,
    );
  }
}
