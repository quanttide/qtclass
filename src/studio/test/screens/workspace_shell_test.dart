import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/screens/course_list_screen.dart';
import 'package:qtclass_studio/screens/workspace_shell.dart';
import 'package:qtclass_studio/services/course_service.dart';
import 'package:qtclass_studio/services/management_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget shell() => ChangeNotifierProvider(
        create: (_) => ManagementStore.seed(),
        child: const MaterialApp(home: WorkspaceShell()),
      );

  testWidgets('侧边导航栏四项，旅程顺序：首页 / 课程 / 学习 / 众包', (tester) async {
    await tester.pumpWidget(shell());
    for (final label in ['首页', '课程', '学习', '众包']) {
      expect(find.widgetWithText(ListTile, label), findsOneWidget);
    }
    // 默认首页（既有课程首页）
    expect(find.text('实践项目'), findsNothing);
  });

  testWidgets('按旅程切换：课程 → 学习 → 众包', (tester) async {
    await tester.pumpWidget(shell());

    await tester.tap(find.widgetWithText(ListTile, '课程'));
    await tester.pumpAndSettle();
    expect(find.text('量潮模拟经营游戏大作业'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, '学习'));
    await tester.pumpAndSettle();
    expect(find.text('AI编程 · 首期'), findsOneWidget, reason: '学习屏默认班级页签');

    await tester.tap(find.widgetWithText(ListTile, '众包'));
    await tester.pumpAndSettle();
    expect(find.text('第二大脑创建插件'), findsOneWidget);
  });

  testWidgets('课程列表页一个「工作台」入口进外壳', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await CourseService.load();
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ManagementStore.seed(),
      child: const MaterialApp(home: CourseListScreen()),
    ));
    expect(find.text('工作台'), findsOneWidget);
    expect(find.text('教学管理'), findsNothing);
    expect(find.text('两本账'), findsNothing);
    expect(find.text('创作空间'), findsNothing);

    await tester.tap(find.text('工作台'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, '众包'), findsOneWidget);
  });
}
