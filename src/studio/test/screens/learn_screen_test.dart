import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/screens/learn_screen.dart';
import 'package:qtclass_studio/services/management_store.dart';

Widget _wrap() => ChangeNotifierProvider(
      create: (_) => ManagementStore.seed(),
      child: const MaterialApp(home: LearnScreen()),
    );

void main() {
  testWidgets('四页签按旅程词：班级 / 名册 / 学习进度 / 评审', (tester) async {
    await tester.pumpWidget(_wrap());
    expect(find.text('学习'), findsOneWidget);
    for (final tab in ['班级', '名册', '学习进度', '评审']) {
      expect(find.text(tab), findsOneWidget);
    }
    // 默认落在班级页签
    expect(find.text('AI编程 · 首期'), findsOneWidget);
  });

  testWidgets('名册渲染种子学员', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.tap(find.text('名册'));
    await tester.pumpAndSettle();
    expect(find.text('同学 A'), findsOneWidget);
    expect(find.text('AI编程 · 以作者身份产出'), findsOneWidget);
    expect(find.text('在读'), findsWidgets);
  });

  testWidgets('学习进度：课堂读数 + 录入记录闭环', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.tap(find.text('学习进度'));
    await tester.pumpAndSettle();
    // 课堂账读数（原两本中的课堂一本）
    expect(find.text('学习记录提交'), findsOneWidget);
    expect(find.textContaining('同学 A · 1 篇'), findsOneWidget);
    expect(find.text('第 1 周学习记录'), findsOneWidget);

    await tester.tap(find.text('录入记录'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '第 2 周学习记录');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('第 2 周学习记录'), findsOneWidget);
    expect(find.textContaining('同学 A · 2 篇'), findsOneWidget);
  });

  testWidgets('班级：招生中 → 进行中 只进不退', (tester) async {
    await tester.pumpWidget(_wrap());
    expect(find.text('招生中'), findsNWidgets(3));

    await tester.tap(find.text('下一步：进行中').first);
    await tester.pumpAndSettle();

    expect(find.text('已迁移到「进行中」'), findsOneWidget);
    expect(find.text('进行中'), findsOneWidget, reason: '只剩 AI编程 一班是进行中');
    expect(find.text('下一步：进行中'), findsNWidgets(2));
  });

  testWidgets('评审：下结论入列', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.tap(find.text('评审'));
    await tester.pumpAndSettle();
    expect(find.text('还没有评审结论'), findsOneWidget);

    await tester.tap(find.text('下结论'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('一周考核'), findsOneWidget);
    expect(find.text('留作免费学员'), findsOneWidget);
  });
}
