import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/screens/home_screen.dart';
import 'package:qtclass_studio/screens/player_screen.dart';
import 'package:qtclass_studio/services/player_state.dart';

/// 多尺寸矩阵测试：找出播放页/首页在哪些尺寸下布局溢出/崩坏。
/// 覆盖：手机竖屏、手机横屏、小高度窗口、平板、桌面。
void main() {
  final sizes = <(String, Size)>[
    ('iPhone 竖屏 390x844', const Size(390, 844)),
    ('Android 小屏 360x640', const Size(360, 640)),
    ('iPhone 横屏 844x390', const Size(844, 390)),
    ('Android 横屏 640x360', const Size(640, 360)),
    ('小窗口 800x600', const Size(800, 600)),
    ('平板 768x1024', const Size(768, 1024)),
    ('桌面 1280x800', const Size(1280, 800)),
  ];

  for (final (name, size) in sizes) {
    testWidgets('播放页 @$name 各状态无布局异常', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;

      final state = PlayerState();
      Widget build() => MaterialApp(
        home: ChangeNotifierProvider.value(
          value: state,
          child: const PlayerScreen(),
        ),
      );

      // 初始 intro
      await tester.pumpWidget(build());
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$name intro 异常');

      // 视频片段 install-zed
      state.restoreProgress(segmentId: 'install-zed');
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$name 视频片段异常');

      // 分支片段 e1-site-down
      state.restoreProgress(segmentId: 'e1-site-down');
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$name 分支片段异常');

      // 互动弹层（install-zed 结束后）
      state.restoreProgress(segmentId: 'install-zed');
      state.seek(1.0);
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$name 互动弹层异常');

      // 完成覆盖层
      state.restoreProgress(finished: true);
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$name 完成覆盖层异常');

      // 抽屉打开（窄屏）
      if (size.width <= 1040) {
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$name 抽屉打开异常');
        expect(find.text('我的学习路径'), findsOneWidget);
        await tester.tapAt(const Offset(5, 200)); // 关闭抽屉
        await tester.pumpAndSettle();
      }

      state.pause();
    });

    testWidgets('首页 @$name 无布局异常', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$name 首页异常');
    });
  }
}
