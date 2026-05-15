import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/models/session.dart';
import 'package:qtclass_studio/screens/schedule_screen.dart';
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

Widget _wrap(AppState state) {
  return ChangeNotifierProvider.value(
    value: state,
    child: MaterialApp(
      home: const ScheduleScreen(),
    ),
  );
}

final _sampleSessions = [
  Session(
    id: 'sess_001',
    courseName: 'Python',
    className: '春班',
    lessonTitle: 'Python 基础',
    teacher: const Teacher(id: 't_001', name: '王老师'),
    startTime: DateTime(2026, 5, 8, 9, 0),
    durationMinutes: 90,
    location: '教室 A',
    status: SessionStatus.inProgress,
    students: [Student(id: 's_1', name: '张三')],
  ),
  Session(
    id: 'sess_002',
    courseName: '大数据',
    className: '训练营',
    lessonTitle: 'HDFS',
    teacher: const Teacher(id: 't_002', name: '李老师'),
    startTime: DateTime(2026, 5, 9, 14, 0),
    durationMinutes: 120,
    location: '机房',
    status: SessionStatus.upcoming,
    students: [Student(id: 's_2', name: '李四')],
  ),
  Session(
    id: 'sess_003',
    courseName: 'SQL',
    className: '秋班',
    lessonTitle: 'SELECT',
    teacher: const Teacher(id: 't_003', name: '赵老师'),
    startTime: DateTime(2026, 5, 7, 9, 0),
    durationMinutes: 60,
    location: '教室 B',
    status: SessionStatus.completed,
    students: [Student(id: 's_3', name: '王五')],
  ),
];

void main() {
  group('ScheduleScreen', () {
    testWidgets('shows content after loading', (tester) async {
      final state = _createState(_sampleSessions);
      await tester.pumpWidget(_wrap(state));
      await tester.pump();

      expect(find.text('Python 基础'), findsOneWidget);
    });

    testWidgets('shows all three sections', (tester) async {
      final state = _createState(_sampleSessions);
      await tester.pumpWidget(_wrap(state));
      await tester.pump();

      expect(find.text('正在上课'), findsOneWidget);
      expect(find.text('即将开始'), findsOneWidget);
      expect(find.text('历史课程'), findsOneWidget);
    });

    testWidgets('shows lesson titles', (tester) async {
      final state = _createState(_sampleSessions);
      await tester.pumpWidget(_wrap(state));
      await tester.pump();

      expect(find.text('Python 基础'), findsOneWidget);
      expect(find.text('HDFS'), findsOneWidget);
      expect(find.text('SELECT'), findsOneWidget);
    });

    testWidgets('inProgress card has 进入课堂 button', (tester) async {
      final state = _createState(_sampleSessions);
      await tester.pumpWidget(_wrap(state));
      await tester.pump();

      expect(find.text('进入课堂'), findsOneWidget);
    });

    testWidgets('tapping card navigates to classroom', (tester) async {
      final state = _createState(_sampleSessions);
      await tester.pumpWidget(_wrap(state));
      await tester.pump();

      await tester.tap(find.text('Python 基础'));
      await tester.pumpAndSettle();

      expect(find.text('课件展示区'), findsOneWidget);
    });

    testWidgets('tapping 进入课堂 navigates to classroom', (tester) async {
      final state = _createState(_sampleSessions);
      await tester.pumpWidget(_wrap(state));
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, '进入课堂'));
      await tester.pumpAndSettle();

      expect(find.text('课件展示区'), findsOneWidget);
    });
  });
}
