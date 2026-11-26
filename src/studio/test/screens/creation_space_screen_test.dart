import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/screens/creation_space_screen.dart';
import 'package:qtclass_studio/services/management_store.dart';

Widget _wrap() => ChangeNotifierProvider(
      create: (_) => ManagementStore.seed(),
      child: const MaterialApp(home: CreationSpaceScreen()),
    );

void main() {
  testWidgets('五页签齐全，题目列表渲染种子', (tester) async {
    await tester.pumpWidget(_wrap());
    expect(find.text('创作空间'), findsOneWidget);
    for (final tab in ['题目', '参考答案', '步骤单元', '脚手架', '修订']) {
      expect(find.text(tab), findsOneWidget);
    }
    expect(find.text('量潮模拟经营游戏大作业'), findsOneWidget);
  });

  testWidgets('题目编辑：改标题保存后回写列表', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.tap(find.text('量潮模拟经营游戏大作业'));
    await tester.pumpAndSettle();
    expect(find.text('编辑题目'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '改后的大作业');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('改后的大作业'), findsOneWidget);
    expect(find.text('量潮模拟经营游戏大作业'), findsNothing);
  });

  testWidgets('脚手架：新增流程入列', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.tap(find.text('脚手架'));
    await tester.pumpAndSettle();
    expect(find.text('对不上先查自己的抄法'), findsOneWidget);

    await tester.tap(find.text('新增脚手架'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '新坑点：先全局后细节');
    await tester.enterText(find.byType(TextField).last, '先看全局再下钻。');
    await tester.tap(find.text('保存'));
    await tester.pumpAndSettle();

    expect(find.text('新坑点：先全局后细节'), findsOneWidget);
  });

  testWidgets('修订：预筛缝走桩 → 已预筛 → 合稿留缝', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.tap(find.text('修订'));
    await tester.pumpAndSettle();
    expect(find.text('待预筛'), findsOneWidget);

    await tester.tap(find.text('AI 预筛'));
    await tester.pumpAndSettle();
    expect(find.text('已过预筛缝（桩）'), findsOneWidget);
    expect(find.text('已预筛'), findsOneWidget);
    expect(find.text('AI 预筛'), findsNothing);

    await tester.tap(find.text('合稿（留缝）'));
    await tester.pumpAndSettle();
    expect(find.text('已合稿'), findsOneWidget);
    expect(find.text('合稿（留缝）'), findsNothing);
  });
}
