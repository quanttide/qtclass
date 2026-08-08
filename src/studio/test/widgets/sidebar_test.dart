import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/widgets/common/sidebar.dart';

import '../helpers/seed.dart';

/// 侧边栏测试 — 路径与节点
void main() {
  group('Sidebar - 路径与节点', () {
    testWidgets('侧边栏包含 4 张卡片标题', (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(Scaffold(body: Sidebar(onJumpToPath: () {}))),
      );
      await tester.pump();

      expect(find.text('我的学习路径'), findsOneWidget);
      expect(find.text('演示控制'), findsOneWidget);
      expect(find.text('互动节点'), findsOneWidget);
      expect(find.text('课程脉络'), findsOneWidget);
    });

    testWidgets('路径步骤来自课程数据（安装 Zed 步骤可见）', (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(Scaffold(body: Sidebar(onJumpToPath: () {}))),
      );
      await tester.pump();

      expect(find.text('安装 Zed 编辑器'), findsWidgets);
      expect(find.text('获取 API 密钥'), findsWidgets);
      expect(find.text('配置 Zed Assistant'), findsWidgets);
    });
  });
}
