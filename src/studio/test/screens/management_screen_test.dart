import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/screens/course_list_screen.dart';
import 'package:qtclass_studio/screens/management_screen.dart';
import 'package:qtclass_studio/services/course_service.dart';
import 'package:qtclass_studio/services/management_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap() => ChangeNotifierProvider(
      create: (_) => ManagementStore.seed(),
      child: const MaterialApp(home: ManagementScreen()),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('四页签齐全，名册渲染种子学员', (tester) async {
    await tester.pumpWidget(_wrap());
    expect(find.text('教学管理'), findsOneWidget);
    for (final tab in ['名册', '学习记录', '评审', '班级状态台']) {
      expect(find.text(tab), findsOneWidget);
    }
    expect(find.text('同学 A'), findsOneWidget);
    expect(find.text('AI编程 · 以作者身份产出'), findsOneWidget);
    expect(find.text('在读'), findsWidgets);
  });

  testWidgets('录入学习记录：对话框填四要素保存后入列', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.tap(find.text('学习记录'));
    await tester.pumpAndSettle();
    expect(find.text('第 1 周学习记录'), findsOneWidget);

    await tester.tap(find.text('录入记录'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '第 2 周学习记录');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('第 2 周学习记录'), findsOneWidget);
    expect(find.text('第 1 周学习记录'), findsOneWidget);
  });

  testWidgets('班级状态台：招生中 → 进行中 只进不退', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.tap(find.text('班级状态台'));
    await tester.pumpAndSettle();
    expect(find.text('AI编程 · 首期'), findsOneWidget);
    expect(find.text('招生中'), findsNWidgets(3));

    await tester.tap(find.text('下一步：进行中').first);
    await tester.pumpAndSettle();

    expect(find.text('已迁移到「进行中」'), findsOneWidget);
    expect(find.text('进行中'), findsOneWidget, reason: '只剩 AI编程 一班是进行中');
    expect(find.text('下一步：进行中'), findsNWidgets(2), reason: '另两班仍在招生中');
  });

  testWidgets('首页三个管理入口可导航', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CourseService.load();
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ManagementStore.seed(),
      child: const MaterialApp(home: CourseListScreen()),
    ));
    expect(find.text('教学管理'), findsOneWidget);
    expect(find.text('两本账'), findsOneWidget);
    expect(find.text('创作空间'), findsOneWidget);

    await tester.tap(find.text('教学管理'));
    await tester.pumpAndSettle();
    expect(find.text('名册'), findsOneWidget);
    expect(find.text('同学 A'), findsOneWidget);
  });
}
