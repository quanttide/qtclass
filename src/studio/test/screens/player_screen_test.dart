import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/screens/player_screen.dart';
import 'package:qtclass_studio/services/player_state.dart';

import '../helpers/seed.dart';

/// 播放器页面测试 — 场景渲染、互动流程、手机端布局
void main() {
  group('PlayerScreen - 场景渲染', () {
    testWidgets('初始时显示 intro 场景（课时开场）', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(wrapWithProviders(const PlayerScreen()));
      await tester.pump();

      expect(find.textContaining('课时1 · 开发环境搭建'), findsWidgets);
      expect(find.textContaining('你的学习路径，将由你的选择展开。'), findsWidgets);
    });

    testWidgets('进入 install-zed 显示视频场景', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(segmentId: 'install-zed');

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      // 视频片段：显示视频加载（测试环境无视频实现则降级提示）
      expect(
        find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
            find.textContaining('视频').evaluate().isNotEmpty,
        isTrue,
        reason: 'install-zed 应渲染视频场景',
      );

      state.pause();
    });

    testWidgets('进入 e1-site-down 显示分支排查场景', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(segmentId: 'e1-site-down');

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      expect(find.textContaining('Zed 官网无法访问'), findsWidgets);
      expect(find.textContaining('包管理器安装'), findsWidgets);

      state.pause();
    });

    testWidgets('完成课程后显示完成覆盖层', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(finished: true);

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      expect(find.text('你的学习路径已完成'), findsOneWidget);
      expect(find.text('课时完成'), findsWidgets);
    });
  });

  group('互动节点 - 数据驱动', () {
    testWidgets('install-zed 结束后弹出安装检查互动', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(segmentId: 'install-zed');
      state.seek(1.0); // 跳到片段末尾触发互动

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      expect(find.text('Zed 安装是否顺利？'), findsOneWidget);
      expect(find.text('安装成功'), findsWidgets);

      state.pause();
    });

    testWidgets('选择官网无法访问后跳转 e1-site-down 分支', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(segmentId: 'install-zed');

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      state.seek(1.0);
      await tester.pump();

      await tester.tap(find.text('官网无法访问'));
      await tester.pump();
      await tester.tap(find.text('进入对应内容'));
      await tester.pump();

      expect(state.currentSegmentId, 'e1-site-down');
      state.pause();
    });
  });

  group('PlayerScreen - 完整页面', () {
    testWidgets('播放器页面关键元素不崩溃', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(wrapWithProviders(const PlayerScreen()));
      await tester.pump();

      expect(find.text('量潮课堂'), findsWidgets);
      expect(find.textContaining('开发环境搭建'), findsWidgets);
    });
  });

  group('手机端布局 - 窄屏渲染', () {
    testWidgets('手机尺寸下各场景渲染无溢出异常', (tester) async {
      setPhoneScreen(tester);
      final state = PlayerState();

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.textContaining('课时1 · 开发环境搭建'), findsWidgets);
      state.pause();
    });

    testWidgets('手机尺寸下进入分支场景无溢出异常', (tester) async {
      setPhoneScreen(tester);
      final state = PlayerState();
      state.restoreProgress(segmentId: 'e1-site-down');

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.textContaining('Zed 官网无法访问'), findsWidgets);
      state.pause();
    });

    testWidgets('手机尺寸下互动节点弹层可用', (tester) async {
      setPhoneScreen(tester);
      final state = PlayerState();
      state.restoreProgress(segmentId: 'install-zed');
      state.seek(1.0); // 触发互动

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('Zed 安装是否顺利？'), findsOneWidget);
      state.pause();
    });
  });
}
