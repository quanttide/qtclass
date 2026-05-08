import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/main.dart' as app;
import 'package:qtclass_studio/services/app_state.dart';
import 'package:qtclass_studio/services/data_service.dart';
import 'package:qtclass_studio/models/models.dart';

class SnapshotDataService extends DataService {
  @override
  Future<List<Session>> loadSessions() async {
    return [
      Session(
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
          Student(id: 'stu_004', name: '赵六'),
        ],
      ),
      Session(
        id: 'sess_002',
        courseName: '大数据技术实战',
        className: '训练营第3期',
        lessonTitle: 'HDFS 原理与实践',
        teacher: const Teacher(id: 't_002', name: '李老师'),
        startTime: DateTime.now().add(const Duration(hours: 3)),
        durationMinutes: 120,
        location: '实训基地 3楼机房',
        status: SessionStatus.upcoming,
        students: [Student(id: 'stu_005', name: '陈七')],
      ),
      Session(
        id: 'sess_003',
        courseName: 'SQL 基础',
        className: '秋班',
        lessonTitle: 'SELECT 语句',
        teacher: const Teacher(id: 't_003', name: '赵老师'),
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        durationMinutes: 60,
        location: '教室 B',
        status: SessionStatus.completed,
        students: [Student(id: 'stu_006', name: '刘八')],
      ),
    ];
  }
}

Widget buildTestApp(AppState state) {
  return ChangeNotifierProvider.value(
    value: state,
    child: const app.QtClassApp(),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('上课流程', () {
    late AppState state;

    setUp(() async {
      state = AppState(dataService: SnapshotDataService());
      await state.loadAll();
    });

    testWidgets('课表页面显示三个分区', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pumpAndSettle();

      expect(find.text('正在上课'), findsOneWidget);
      expect(find.text('即将开始'), findsOneWidget);
      expect(find.text('历史课程'), findsOneWidget);
      expect(find.text('Python 基础'), findsOneWidget);
      expect(find.text('进入课堂'), findsOneWidget);
    });

    testWidgets('点击进入课堂跳转到教室页', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pumpAndSettle();

      await tester.tap(find.text('进入课堂'));
      await tester.pumpAndSettle();

      expect(find.text('课件展示区'), findsOneWidget);
      expect(find.text('学员 (4)'), findsOneWidget);
      expect(find.text('出勤'), findsOneWidget);
      expect(find.text('下课'), findsOneWidget);
    });

    testWidgets('出勤标记后学员状态更新', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pumpAndSettle();

      await tester.tap(find.text('进入课堂'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('出勤'));
      await tester.pumpAndSettle();

      expect(find.text('全部正常'), findsOneWidget);

      await tester.tap(find.text('全部正常'));
      await tester.pumpAndSettle();

      final session = state.sessions.firstWhere((s) => s.id == 'sess_001');
      for (final student in session.students) {
        expect(student.attendance, AttendanceStatus.present);
      }
    });

    testWidgets('下课弹窗确认后返回课表', (tester) async {
      await tester.pumpWidget(buildTestApp(state));
      await tester.pumpAndSettle();

      await tester.tap(find.text('进入课堂'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('下课'));
      await tester.pumpAndSettle();

      expect(find.text('结束课程'), findsOneWidget);
      expect(find.text('确认结束本节课吗？'), findsOneWidget);

      await tester.tap(find.text('下课'));
      await tester.pumpAndSettle();

      expect(find.text('历史课程'), findsOneWidget);
    });
  });
}
