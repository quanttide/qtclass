import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/screens/crowd_screen.dart';
import 'package:qtclass_studio/services/management_store.dart';

Widget _wrap(ManagementStore store) => ChangeNotifierProvider.value(
      value: store,
      child: const MaterialApp(home: CrowdScreen()),
    );

void main() {
  testWidgets('实践项目清单（真实任务标题）与交付读数', (tester) async {
    await tester.pumpWidget(_wrap(ManagementStore.seed()));
    expect(find.text('众包'), findsOneWidget);
    expect(find.text('实践项目'), findsOneWidget);
    expect(find.text('第二大脑创建插件'), findsOneWidget);
    expect(find.text('量潮模拟经营游戏任务书'), findsOneWidget);
    expect(find.text('qtgame-tycoon'), findsOneWidget);
    // 交付：项目行先见，滚动后学员行也渲染（懒列表分屏）
    expect(find.text('1 件'), findsWidgets);
    expect(find.textContaining('只读投影'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('同学 A'), 300);
    expect(find.text('任务交付'), findsOneWidget);
    expect(find.text('1 件'), findsWidgets);
  });

  testWidgets('无数据时诚实提示', (tester) async {
    await tester.pumpWidget(_wrap(ManagementStore()));
    expect(find.text('还没有实践项目'), findsOneWidget);
    expect(find.text('没有学员'), findsOneWidget);
  });
}
