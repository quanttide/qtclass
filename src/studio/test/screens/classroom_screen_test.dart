import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/models/models.dart';
import 'package:qtclass_studio/screens/classroom_screen.dart';
import 'package:qtclass_studio/services/app_state.dart';
import 'package:qtclass_studio/services/data_service.dart';

class FakeDataService extends DataService {
  final List<Session> _sessions;
  FakeDataService(this._sessions);

  @override
  Future<List<Session>> loadSessions() async => _sessions;
}

AppState _createState(List<Session> sessions) {
  final state = AppState(dataService: FakeDataService(sessions));
  state.loadAll();
  return state;
}

Widget _wrap(AppState state, String sessionId) {
  return ChangeNotifierProvider.value(
    value: state,
    child: MaterialApp(
      home: ClassroomScreen(sessionId: sessionId),
    ),
  );
}

final _inProgressSession = Session(
  id: 'sess_001',
  courseName: 'Python 数据分析',
  className: '2026春实训班',
  lessonTitle: 'Python 基础',
  teacher: const Teacher(id: 't_001', name: '王老师'),
  startTime: DateTime.now().subtract(const Duration(minutes: 30)),
  durationMinutes: 90,
  location: '线上教室 A',
  status: SessionStatus.inProgress,
  students: [
    Student(id: 'stu_001', name: '张三'),
    Student(id: 'stu_002', name: '李四'),
    Student(id: 'stu_003', name: '王五'),
  ],
);

final _completedSession = Session(
  id: 'sess_002',
  courseName: '大数据技术实战',
  className: '训练营',
  lessonTitle: 'HDFS 原理与实践',
  teacher: const Teacher(id: 't_002', name: '李老师'),
  startTime: DateTime(2026, 5, 7, 9, 0),
  durationMinutes: 120,
  location: '机房',
  status: SessionStatus.completed,
  students: [
    Student(id: 'stu_003', name: '王五'),
    Student(id: 'stu_004', name: '赵六'),
  ],
);

void main() {
  group('ClassroomScreen - in progress', () {
    testWidgets('shows content area', (tester) async {
      final state = _createState([_inProgressSession]);
      await tester.pumpWidget(_wrap(state, 'sess_001'));
      await tester.pump();

      expect(find.text('课件展示区'), findsOneWidget);
      expect(find.text('Python 基础'), findsNWidgets(2));
    });

    testWidgets('shows student sidebar', (tester) async {
      final state = _createState([_inProgressSession]);
      await tester.pumpWidget(_wrap(state, 'sess_001'));
      await tester.pump();

      expect(find.text('学员 (3)'), findsOneWidget);
      expect(find.text('张三'), findsOneWidget);
      expect(find.text('李四'), findsOneWidget);
      expect(find.text('王五'), findsOneWidget);
    });

    testWidgets('shows toolbar with attendance button', (tester) async {
      final state = _createState([_inProgressSession]);
      await tester.pumpWidget(_wrap(state, 'sess_001'));
      await tester.pump();

      expect(find.text('出勤'), findsOneWidget);
      expect(find.text('提问'), findsOneWidget);
      expect(find.text('投票'), findsOneWidget);
      expect(find.text('备注'), findsOneWidget);
      expect(find.text('下课'), findsOneWidget);
    });

    testWidgets('tapping attendance opens bottom sheet', (tester) async {
      final state = _createState([_inProgressSession]);
      await tester.pumpWidget(_wrap(state, 'sess_001'));
      await tester.pump();

      await tester.tap(find.text('出勤'));
      await tester.pumpAndSettle();

      expect(find.text('全部正常'), findsOneWidget);
      expect(find.text('全部迟到'), findsOneWidget);
      expect(find.text('全部缺勤'), findsOneWidget);
    });

    testWidgets('marking all present updates students', (tester) async {
      final state = _createState([_inProgressSession]);
      await tester.pumpWidget(_wrap(state, 'sess_001'));
      await tester.pump();

      await tester.tap(find.text('出勤'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('全部正常'));
      await tester.pumpAndSettle();

      final session = state.sessions.firstWhere((s) => s.id == 'sess_001');
      for (final s in session.students) {
        expect(s.attendance, AttendanceStatus.present);
      }
    });

    testWidgets('tapping 下课 shows confirmation dialog', (tester) async {
      final state = _createState([_inProgressSession]);
      await tester.pumpWidget(_wrap(state, 'sess_001'));
      await tester.pump();

      await tester.tap(find.text('下课'));
      await tester.pumpAndSettle();

      expect(find.text('结束课程'), findsOneWidget);
      expect(find.text('确认结束本节课吗？'), findsOneWidget);
    });

    testWidgets('tapping 提问 shows snackbar', (tester) async {
      final state = _createState([_inProgressSession]);
      await tester.pumpWidget(_wrap(state, 'sess_001'));
      await tester.pump();

      await tester.tap(find.text('提问'));
      await tester.pumpAndSettle();

      expect(find.text('提问功能开发中'), findsOneWidget);
    });
  });

  group('ClassroomScreen - completed (review)', () {
    testWidgets('shows session info card', (tester) async {
      final state = _createState([_completedSession]);
      await tester.pumpWidget(_wrap(state, 'sess_002'));
      await tester.pump();

      expect(find.text('HDFS 原理与实践'), findsNWidgets(2));
      expect(find.text('授课教师: 李老师'), findsOneWidget);
    });

    testWidgets('shows attendance statistics', (tester) async {
      final state = _createState([_completedSession]);
      await tester.pumpWidget(_wrap(state, 'sess_002'));
      await tester.pump();

      expect(find.text('出勤统计'), findsOneWidget);
      expect(find.text('应到'), findsOneWidget);
      expect(find.text('未记'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows student list with chips', (tester) async {
      final state = _createState([_completedSession]);
      await tester.pumpWidget(_wrap(state, 'sess_002'));
      await tester.pump();

      expect(find.text('王五'), findsOneWidget);
      expect(find.text('赵六'), findsOneWidget);
    });

    testWidgets('does not show toolbar', (tester) async {
      final state = _createState([_completedSession]);
      await tester.pumpWidget(_wrap(state, 'sess_002'));
      await tester.pump();

      expect(find.text('出勤'), findsNothing);
      expect(find.text('下课'), findsNothing);
    });
  });
}
