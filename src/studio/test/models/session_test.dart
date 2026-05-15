import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/session.dart';

void main() {
  group('SessionStatus', () {
    test('values have correct names', () {
      expect(SessionStatus.upcoming.name, 'upcoming');
      expect(SessionStatus.inProgress.name, 'inProgress');
      expect(SessionStatus.completed.name, 'completed');
    });
  });

  group('AttendanceStatus', () {
    test('values have correct names', () {
      expect(AttendanceStatus.unknown.name, 'unknown');
      expect(AttendanceStatus.present.name, 'present');
      expect(AttendanceStatus.late.name, 'late');
      expect(AttendanceStatus.absent.name, 'absent');
    });
  });

  group('Teacher', () {
    test('fromJson parses correctly', () {
      final json = {'id': 't_001', 'name': '王老师'};
      final teacher = Teacher.fromJson(json);

      expect(teacher.id, 't_001');
      expect(teacher.name, '王老师');
    });
  });

  group('Student', () {
    test('fromJson parses correctly', () {
      final json = {'id': 'stu_001', 'name': '张三'};
      final student = Student.fromJson(json);

      expect(student.id, 'stu_001');
      expect(student.name, '张三');
      expect(student.attendance, AttendanceStatus.unknown);
    });

    test('attendance defaults to unknown', () {
      final student = Student(id: 'stu_001', name: '张三');
      expect(student.attendance, AttendanceStatus.unknown);
    });

    test('attendance can be changed', () {
      final student = Student(id: 'stu_001', name: '张三');
      student.attendance = AttendanceStatus.present;
      expect(student.attendance, AttendanceStatus.present);
    });
  });

  group('Session', () {
    final validJson = {
      'id': 'sess_001',
      'course_name': 'Python 数据分析',
      'class_name': '2026春实训班',
      'lesson_title': 'Python 基础',
      'teacher': {'id': 't_001', 'name': '王老师'},
      'start_time': '2026-05-08T09:00:00',
      'duration_minutes': 90,
      'location': '线上教室 A',
      'status': 'inProgress',
      'students': [
        {'id': 'stu_001', 'name': '张三'},
        {'id': 'stu_002', 'name': '李四'},
      ],
    };

    test('fromJson parses all fields', () {
      final session = Session.fromJson(validJson);

      expect(session.id, 'sess_001');
      expect(session.courseName, 'Python 数据分析');
      expect(session.className, '2026春实训班');
      expect(session.lessonTitle, 'Python 基础');
      expect(session.teacher.id, 't_001');
      expect(session.teacher.name, '王老师');
      expect(session.startTime, DateTime(2026, 5, 8, 9, 0, 0));
      expect(session.durationMinutes, 90);
      expect(session.location, '线上教室 A');
      expect(session.status, SessionStatus.inProgress);
      expect(session.students.length, 2);
    });

    test('fromJson parses upcoming status', () {
      final json = {...validJson, 'status': 'upcoming'};
      final session = Session.fromJson(json);
      expect(session.status, SessionStatus.upcoming);
    });

    test('fromJson parses completed status', () {
      final json = {...validJson, 'status': 'completed'};
      final session = Session.fromJson(json);
      expect(session.status, SessionStatus.completed);
    });

    test('endTime calculates correctly', () {
      final session = Session.fromJson(validJson);
      expect(session.endTime, DateTime(2026, 5, 8, 10, 30, 0));
    });

    test('students list is parsed correctly', () {
      final session = Session.fromJson(validJson);
      expect(session.students[0].name, '张三');
      expect(session.students[1].name, '李四');
    });

    test('throws when status is invalid', () {
      final json = {...validJson, 'status': 'invalid_status'};
      expect(
        () => Session.fromJson(json),
        throwsA(isA<StateError>()),
      );
    });
  });
}
