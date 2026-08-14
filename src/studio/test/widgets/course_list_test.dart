import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qtclass_studio/models/course.dart';
import 'package:qtclass_studio/screens/course_list_screen.dart';
import 'package:qtclass_studio/services/course_service.dart';
import 'package:qtclass_studio/widgets/course/course_card.dart';
import 'package:qtclass_studio/widgets/course/course_hero.dart';
import 'package:qtclass_studio/widgets/course/difficulty_badge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CourseService.load();
  });

  testWidgets('CourseService 加载 5 门课', (tester) async {
    expect(CourseService.all, hasLength(5));
    final names = [for (final c in CourseService.all) c.name];
    expect(names, ['知识工作', '氛围编程', '大数据导论', '数据工程', '生产实习']);
  });

  testWidgets('难度标签渲染 4 种变体', (tester) async {
    for (final (badgeClass, label) in [
      ('beginner', '入门'),
      ('intermediate', '进阶'),
      ('advanced', '高阶'),
      ('capstone', '生产实习 · 微型创业'),
    ]) {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DifficultyBadge(label: label, badgeClass: badgeClass))),
      );
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('课程卡片显示编号/名称/描述/难度', (tester) async {
    final course = CourseService.byId('knowledge-work')!;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CourseCard(course: course, number: 1, onTap: () {}),
        ),
      ),
    );
    expect(find.text('1'), findsOneWidget);
    expect(find.text('📁 知识工作'), findsOneWidget);
    expect(find.textContaining('从整理文档开始'), findsOneWidget);
    expect(find.text('入门'), findsOneWidget);
  });

  testWidgets('列表页渲染 5 张卡片，生产实习 active 高亮', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CourseListScreen()));
    await tester.pumpAndSettle();
    // 5 张卡片 + AppBar
    expect(find.byType(CourseCard), findsNWidgets(5));
    expect(find.text('量潮课堂 · 实训基地'), findsOneWidget);
    expect(find.text('~ 量潮课堂'), findsOneWidget);
    expect(find.text('v0.1.0'), findsOneWidget);
  });

  testWidgets('列表页卡片点击跳转详情页', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CourseListScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('📁 知识工作'));
    await tester.pumpAndSettle();
    // 详情页出现：Hero
    expect(find.byType(CourseHero), findsOneWidget);
  });
}