import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/screens/ledger_screen.dart';
import 'package:qtclass_studio/services/management_store.dart';

Widget _wrap() => ChangeNotifierProvider(
      create: (_) => ManagementStore.seed(),
      child: const MaterialApp(home: LedgerScreen()),
    );

void main() {
  testWidgets('两本账：只读抬头 + 活跃与交付读数', (tester) async {
    await tester.pumpWidget(_wrap());
    expect(find.text('两本账'), findsOneWidget);
    expect(find.textContaining('只读投影'), findsOneWidget);
    expect(find.text('活跃账 · 学习记录提交'), findsOneWidget);
    expect(find.text('交付账 · 任务交付情况'), findsOneWidget);

    // 活跃账：同学 A 1 篇、同学 B 0 篇
    expect(find.text('同学 A'), findsOneWidget);
    expect(find.text('1 篇'), findsOneWidget);
    expect(find.text('0 篇'), findsOneWidget);

    // 交付账：按任务汇总
    expect(find.text('hello-world'), findsOneWidget);
    expect(find.text('1 件'), findsOneWidget);
  });

  testWidgets('无数据时诚实提示', (tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ManagementStore(),
      child: const MaterialApp(home: LedgerScreen()),
    ));
    expect(find.text('没有学员'), findsOneWidget);
    expect(find.text('还没有交付'), findsOneWidget);
  });
}
