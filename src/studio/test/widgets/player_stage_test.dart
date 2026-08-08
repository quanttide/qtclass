import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/services/player_state.dart';
import 'package:qtclass_studio/widgets/stage/player_stage.dart';

import '../helpers/seed.dart';

/// 播放舞台测试 — 场景渲染（组件级）
void main() {
  Widget buildStage(PlayerState state) {
    return wrapWithProviders(
      Scaffold(
        body: SizedBox(
          width: 1200,
          height: 600,
          child: PlayerStage(state: state),
        ),
      ),
      state: state,
    );
  }

  group('PlayerStage - 场景渲染', () {
    testWidgets('初始时显示 intro 场景（课时开场）', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      await tester.pumpWidget(buildStage(state));
      await tester.pump();

      expect(find.textContaining('你的学习路径，将由你的选择展开。'), findsWidgets);
      expect(find.text('Zed'), findsOneWidget); // Orbit 视觉

      state.pause();
    });

    testWidgets('进入 e1-site-down 显示终端排查卡片', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(segmentId: 'e1-site-down');

      await tester.pumpWidget(buildStage(state));
      await tester.pump();

      expect(find.textContaining('Zed 官网无法访问'), findsWidgets);
      expect(find.textContaining('包管理器安装'), findsWidgets);

      state.pause();
    });

    testWidgets('完成课程后显示完成覆盖层', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(finished: true);

      await tester.pumpWidget(buildStage(state));
      await tester.pump();

      expect(find.text('你的学习路径已完成'), findsOneWidget);
      expect(find.text('课时完成'), findsWidgets);
    });
  });
}
