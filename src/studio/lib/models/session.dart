enum SessionStatus { upcoming, inProgress, completed }

enum AttendanceStatus { unknown, present, late, absent }

class Teacher {
  final String id;
  final String name;

  const Teacher({required this.id, required this.name});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class Student {
  final String id;
  final String name;
  AttendanceStatus attendance;

  Student({required this.id, required this.name, this.attendance = AttendanceStatus.unknown});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class Session {
  final String id;
  final String courseName;
  final String className;
  final String lessonTitle;
  final Teacher teacher;
  final DateTime startTime;
  final int durationMinutes;
  final String location;
  final SessionStatus status;
  final List<Student> students;

  Session({
    required this.id,
    required this.courseName,
    required this.className,
    required this.lessonTitle,
    required this.teacher,
    required this.startTime,
    required this.durationMinutes,
    required this.location,
    required this.status,
    required this.students,
  });

  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));

  factory Session.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String;
    return Session(
      id: json['id'] as String,
      courseName: json['course_name'] as String,
      className: json['class_name'] as String,
      lessonTitle: json['lesson_title'] as String,
      teacher: Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['start_time'] as String),
      durationMinutes: json['duration_minutes'] as int,
      location: json['location'] as String,
      status: SessionStatus.values.firstWhere((s) => s.name == statusStr),
      students: (json['students'] as List)
          .map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
