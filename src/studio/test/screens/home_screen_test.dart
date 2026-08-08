import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/screens/home_screen.dart';
import 'package:qtclass_studio/screens/player_screen.dart';
import 'package:qtclass_studio/services/player_state.dart';

/// 课程首页测试
void main() {
  group('HomeScreen - 课程信息', () {
    testWidgets('渲染课程标题与描述', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => PlayerState(),
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pump();

      expect(find.textContaining('开发环境搭建'), findsWidgets);
      expect(find.text('开始学习'), findsOneWidget);
      expect(find.text('互动节点 · 状态反馈 · 分支路径 · 视频演示'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('点击开始学习跳转播放器页面', (tester) async {
      // Provider 置于 MaterialApp 外层，保证 push 的新路由可访问
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => PlayerState(),
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('开始学习'));
      await tester.pumpAndSettle();

      expect(find.byType(PlayerScreen), findsOneWidget);
    });
  });
}
