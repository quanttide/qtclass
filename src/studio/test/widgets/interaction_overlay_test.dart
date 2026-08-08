import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/services/player_state.dart';
import 'package:qtclass_studio/widgets/dialogs/interaction_overlay.dart';

import '../helpers/seed.dart';

/// 互动覆盖层测试 — 数据驱动弹层（组件级）
void main() {
  Widget buildOverlay(PlayerState state) {
    return wrapWithProviders(
      const Scaffold(body: InteractionOverlay()),
      state: state,
    );
  }

  group('InteractionOverlay - 互动弹层', () {
    testWidgets('无互动时渲染为空', (tester) async {
      final state = PlayerState();
      await tester.pumpWidget(buildOverlay(state));
      await tester.pump();

      expect(find.text('互动节点'), findsNothing);
      expect(find.byType(InteractionOverlay), findsOneWidget);
      state.pause();
    });

    testWidgets('install-zed 片段结束后弹出安装检查互动', (tester) async {
      final state = PlayerState();
      state.restoreProgress(segmentId: 'install-zed');
      state.seek(1.0); // 跳到片段末尾触发互动

      await tester.pumpWidget(buildOverlay(state));
      await tester.pump();

      expect(find.text('Zed 安装是否顺利？'), findsOneWidget);
      expect(find.text('安装成功'), findsWidgets);

      state.pause();
    });

    testWidgets('选择选项后确认跳转对应分支', (tester) async {
      final state = PlayerState();
      state.restoreProgress(segmentId: 'install-zed');
      state.seek(1.0);

      await tester.pumpWidget(buildOverlay(state));
      await tester.pump();

      await tester.tap(find.text('官网无法访问'));
      await tester.pump();
      await tester.tap(find.text('进入对应内容'));
      await tester.pump();

      expect(state.currentSegmentId, 'e1-site-down');
      state.pause();
    });
  });
}
