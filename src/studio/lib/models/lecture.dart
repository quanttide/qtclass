class Lecture {
  final String id;
  // 关联的课次 ID（Session），一个课时对应一次课
  final String sessionId;
  final String title;
  final String description;
  final String target;
  final List<String> objectives;
  // 单个课时的提纲，不是多课时大纲，故用单数
  final List<String> outline;
  final int duration;
  // difficulty 改为 level 以统一量潮课堂难度等级体系
  final String level;
  // 交付形式：如 "视频 + 可运行示例"、"图文 + 练习"
  final String format;

  const Lecture({
    required this.id,
    required this.sessionId,
    required this.title,
    required this.description,
    required this.target,
    required this.objectives,
    required this.outline,
    required this.duration,
    required this.level,
    required this.format,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      target: json['target'] as String,
      objectives: (json['objectives'] as List)
          .map((e) => e as String)
          .toList(),
      outline: (json['outline'] as List)
          .map((e) => e as String)
          .toList(),
      duration: json['duration'] as int,
      level: json['level'] as String,
      format: json['format'] as String,
    );
  }
}
