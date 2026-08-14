/// 课程 — 课程列表/详情页的展示模型
///
/// 映射自 `doc/screens/course-list.md` / `course-detail.md` 的数据模型：
/// `Course { id, name, icon, badge, badgeClass, desc, meta, stages }`
class Course {
  final String id;
  final String name;
  final String icon; // 课程图标 emoji（如 🏭）
  final String badge; // 胶囊标签文案（如 "生产实习 · 微型创业"）
  final String badgeClass; // 难度变体：beginner / intermediate / advanced / capstone
  final String desc;
  final CourseMeta meta;
  final List<CourseStage> stages;

  const Course({
    required this.id,
    required this.name,
    required this.icon,
    required this.badge,
    required this.badgeClass,
    required this.desc,
    required this.meta,
    required this.stages,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] as String,
    name: json['name'] as String,
    icon: json['icon'] as String? ?? '',
    badge: json['badge'] as String? ?? '',
    badgeClass: json['badgeClass'] as String? ?? 'beginner',
    desc: json['desc'] as String? ?? '',
    meta: CourseMeta.fromJson(
      json['meta'] is Map ? Map<String, dynamic>.from(json['meta'] as Map) : const <String, dynamic>{},
    ),
    stages: (json['stages'] as List<dynamic>? ?? [])
        .map((e) => CourseStage.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  /// 是否为生产实习课（专用形态 view-front）
  bool get isProd => id == 'prod';
}

/// 课程元信息 — Hero 区展示的模块数 / 时长 / 人数
class CourseMeta {
  final int modules; // 模块数
  final String duration; // 时长文案（如 "2 周"）
  final int students; // 在学人数

  const CourseMeta({
    required this.modules,
    required this.duration,
    required this.students,
  });

  factory CourseMeta.fromJson(Map<String, dynamic> json) => CourseMeta(
    modules: json['modules'] as int? ?? 0,
    duration: json['duration'] as String? ?? '',
    students: json['students'] as int? ?? 0,
  );
}

/// 课程阶段（模块）— 对应生产实习 5 模块 / 通用课程按阶段渲染
class CourseStage {
  final String id; // 模块标识（如 m1、s1）
  final String name;
  final List<CourseLesson> lessons;

  const CourseStage({required this.id, required this.name, required this.lessons});

  factory CourseStage.fromJson(Map<String, dynamic> json) => CourseStage(
    id: json['id'] as String,
    name: json['name'] as String,
    lessons: (json['lessons'] as List<dynamic>? ?? [])
        .map((e) => CourseLesson.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// 课时 — 详情页课时条目（点击进入播放器）
class CourseLesson {
  final String id;
  final String title;
  final String duration; // 时长文案（如 "10 min"）
  final String type; // 类型：阅读 / 视频 / 练习

  const CourseLesson({
    required this.id,
    required this.title,
    required this.duration,
    this.type = '',
  });

  factory CourseLesson.fromJson(Map<String, dynamic> json) => CourseLesson(
    id: json['id'] as String,
    title: json['title'] as String,
    duration: json['duration'] as String? ?? '',
    type: json['type'] as String? ?? '',
  );
}