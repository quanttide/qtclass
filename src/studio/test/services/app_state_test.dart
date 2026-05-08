import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/models.dart';
import 'package:qtclass_studio/services/app_state.dart';
import 'package:qtclass_studio/services/data_service.dart';

class FakeDataService extends DataService {
  final List<Session> _sessions;

  FakeDataService(this._sessions);

  @override
  Future<List<Session>> loadSessions() async => _sessions;
}

List<Session> _createTestSessions() {
  return [
    Session(
      id: 'sess_001',
      courseName: 'Python 数据分析',
      className: '2026春实训班',
      lessonTitle: 'Python 基础',
      teacher: const Teacher(id: 't_001', name: '王老师'),
      startTime: DateTime(2026, 5, 8, 9, 0),
      durationMinutes: 90,
      location: '线上教室 A',
      status: SessionStatus.inProgress,
      students: [
        Student(id: 'stu_001', name: '张三'),
        Student(id: 'stu_002', name: '李四'),
      ],
    ),
    Session(
      id: 'sess_002',
      courseName: 'Python 数据分析',
      className: '2026春实训班',
      lessonTitle: 'NumPy 入门',
      teacher: const Teacher(id: 't_001', name: '王老师'),
      startTime: DateTime(2026, 5, 8, 14, 0),
      durationMinutes: 90,
      location: '线上教室 A',
      status: SessionStatus.upcoming,
      students: [
        Student(id: 'stu_001', name: '张三'),
      ],
    ),
    Session(
      id: 'sess_003',
      courseName: '大数据技术实战',
      className: '大数据训练营第3期',
      lessonTitle: 'HDFS 原理与实践',
      teacher: const Teacher(id: 't_002', name: '李老师'),
      startTime: DateTime(2026, 5, 7, 9, 0),
      durationMinutes: 120,
      location: '实训基地 3楼机房',
      status: SessionStatus.completed,
      students: [
        Student(id: 'stu_003', name: '王五'),
      ],
    ),
  ];
}

void main() {
  group('AppState', () {
    late AppState state;
    late List<Session> sessions;

    setUp(() {
      sessions = _createTestSessions();
      state = AppState(dataService: FakeDataService(sessions));
    });

    test('initial state is empty', () {
      final emptyState = AppState();
      expect(emptyState.sessions, isEmpty);
      expect(emptyState.isLoading, false);
      expect(emptyState.error, isNull);
    });

    test('loadAll populates sessions', () async {
      await state.loadAll();

      expect(state.sessions.length, 3);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('loadAll sets loading state', () async {
      final loadingStates = <bool>[];
      state.addListener(() => loadingStates.add(state.isLoading));

      await state.loadAll();

      expect(loadingStates, contains(true));
    });

    test('filters inProgress sessions', () async {
      await state.loadAll();

      expect(state.inProgressSessions.length, 1);
      expect(state.inProgressSessions[0].id, 'sess_001');
    });

    test('filters upcoming sessions', () async {
      await state.loadAll();

      expect(state.upcomingSessions.length, 1);
      expect(state.upcomingSessions[0].id, 'sess_002');
    });

    test('filters completed sessions', () async {
      await state.loadAll();

      expect(state.completedSessions.length, 1);
      expect(state.completedSessions[0].id, 'sess_003');
    });

    test('markAttendance updates student attendance', () async {
      await state.loadAll();

      state.markAttendance('sess_001', 'stu_001', AttendanceStatus.present);

      final student = state.sessions
          .firstWhere((s) => s.id == 'sess_001')
          .students
          .firstWhere((s) => s.id == 'stu_001');
      expect(student.attendance, AttendanceStatus.present);
    });

    test('markAllAttendance updates all students in session', () async {
      await state.loadAll();

      state.markAllAttendance('sess_001', AttendanceStatus.present);

      final session = state.sessions.firstWhere((s) => s.id == 'sess_001');
      for (final student in session.students) {
        expect(student.attendance, AttendanceStatus.present);
      }
    });

    test('loadAll handles errors', () async {
      final errorState = AppState(
        dataService: FakeDataService([]) as DataService,
      );

      await errorState.loadAll();

      expect(errorState.error, isNull);
    });
  });
}
