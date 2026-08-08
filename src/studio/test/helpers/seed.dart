import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/services/player_state.dart';

/// 测试辅助 — 共享的 Provider 包裹与屏幕尺寸设置
///
/// 对应 qtdata studio 的 `test/helpers/seed.dart` 角色：测试数据与包裹工具。

/// 创建测试用的 Provider 包裹
Widget wrapWithProviders(Widget child, {PlayerState? state}) {
  return MaterialApp(
    home: ChangeNotifierProvider.value(
      value: state ?? PlayerState(),
      child: child,
    ),
  );
}

/// 设置大测试窗口（1280x800）避免播放器布局溢出
void setLargeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1.0;
}

/// 设置手机尺寸（iPhone 15，390 x 844）
void setPhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
}
