import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qtclass_studio/screens/course_detail_screen.dart';
import 'package:qtclass_studio/services/course_service.dart';
import 'package:qtclass_studio/widgets/course/course_hero.dart';
import 'package:qtclass_studio/widgets/course/module_panel.dart';
import 'package:qtclass_studio/widgets/course/step_bar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await CourseService.load();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpDetail(WidgetTester tester, String courseId) async {
    await tester.pumpWidget(
      MaterialApp(home: CourseDetailScreen(courseId: courseId)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('通用课程初始显示 Hero（无进度）', (tester) async {
    await pumpDetail(tester, 'knowledge-work');
    expect(find.byType(CourseHero), findsOneWidget);
    expect(find.text('📁 入门'), findsOneWidget);
    expect(find.text('知识工作'), findsWidgets);
    expect(find.text('继续学习'), findsOneWidget);
  });

  testWidgets('点击继续学习进入第一模块并显示 StepBar', (tester) async {
    await pumpDetail(tester, 'knowledge-work');
    await tester.tap(find.text('继续学习'));
    await tester.pumpAndSettle();
    expect(find.byType(StepBar), findsOneWidget);
    expect(find.byType(ModulePanel), findsOneWidget);
    expect(find.text('📖 文档即资产'), findsOneWidget);
    expect(find.text('1.1 为什么文档是资产'), findsOneWidget);
  });

  testWidgets('StepBar 步骤节点切换模块', (tester) async {
    await pumpDetail(tester, 'knowledge-work');
    await tester.tap(find.text('继续学习'));
    await tester.pumpAndSettle();
    // 点击步骤 3（s3）
    await tester.tap(find.text('知识输出'));
    await tester.pumpAndSettle();
    expect(find.text('📖 知识输出'), findsOneWidget);
  });

  testWidgets('生产实习显示组队广场按钮', (tester) async {
    await pumpDetail(tester, 'prod');
    expect(find.byType(CourseHero), findsOneWidget);
    expect(find.text('组队广场'), findsOneWidget);
    expect(find.text('📚 5 个模块 · ⏱ 2 周 · 38 人在学'), findsOneWidget);
  });

  testWidgets('进度持久化：再次打开恢复上次模块', (tester) async {
    await pumpDetail(tester, 'knowledge-work');
    await tester.tap(find.text('继续学习'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('下一模块'));
    await tester.pumpAndSettle();
    expect(find.text('📖 信息收集与整理'), findsOneWidget);

    // 重新打开页面，应恢复 s2
    await pumpDetail(tester, 'knowledge-work');
    expect(find.byType(ModulePanel), findsOneWidget);
    expect(find.text('📖 信息收集与整理'), findsOneWidget);
  });

  testWidgets('max 只增不减：回到课程首页后进度仍保留', (tester) async {
    await pumpDetail(tester, 'knowledge-work');
    await tester.tap(find.text('继续学习'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('下一模块'));
    await tester.pumpAndSettle();
    // 返回课程首页
    await tester.tap(find.text('← 返回课程首页').first);
    await tester.pumpAndSettle();
    expect(find.byType(CourseHero), findsOneWidget);
    // StepBar 应显示已完成 2 个模块（进度条 50%）
    expect(find.text('50%'), findsOneWidget);
  });

  testWidgets('未知课程 ID 显示未找到', (tester) async {
    await pumpDetail(tester, 'nonexistent');
    expect(find.text('未找到该课程'), findsOneWidget);
  });
}