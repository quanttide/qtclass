class Teacher {
  final String id;
  final String name;
  final String title;

  const Teacher({
    required this.id,
    required this.name,
    required this.title,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
    );
  }
}

class Syllabus {
  final String id;
  final List<String> topics;
  final int totalHours;

  const Syllabus({
    required this.id,
    required this.topics,
    required this.totalHours,
  });

  factory Syllabus.fromJson(Map<String, dynamic> json) {
    return Syllabus(
      id: json['id'] as String,
      topics: List<String>.from(json['topics'] as List),
      totalHours: json['total_hours'] as int,
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final int durationMinutes;
  final String teacherId;

  const Lesson({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.teacherId,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      durationMinutes: json['duration_minutes'] as int,
      teacherId: json['teacher_id'] as String,
    );
  }
}

class Class {
  final String id;
  final String name;
  final String courseId;
  final String deliveryModeId;
  final List<Lesson> lessons;
  final DateTime startDate;
  final DateTime endDate;

  const Class({
    required this.id,
    required this.name,
    required this.courseId,
    required this.deliveryModeId,
    required this.lessons,
    required this.startDate,
    required this.endDate,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] as String,
      name: json['name'] as String,
      courseId: json['course_id'] as String,
      deliveryModeId: json['delivery_mode_id'] as String,
      lessons: (json['lessons'] as List)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final List<Class> classes;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.classes,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      classes: (json['classes'] as List)
          .map((e) => Class.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
