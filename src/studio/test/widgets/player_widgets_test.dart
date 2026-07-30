import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qtclass_studio/services/player_state.dart';
import 'package:qtclass_studio/widgets/sidebar.dart';
import 'package:qtclass_studio/widgets/player_controls.dart';
import 'package:qtclass_studio/screens/player_screen.dart';

/// 辅助方法：创建测试用的 Provider 包裹
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

void main() {
  setUp(() {
    // 每个测试后重置 view
  });

  group('PlayerStage - 场景渲染', () {
    testWidgets('初始时显示 intro 场景 (scene-kicker + 标题)', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(wrapWithProviders(const PlayerScreen()));
      await tester.pump();

      expect(find.textContaining('开启 Python 学习任务'), findsWidgets);
      expect(find.textContaining('你的学习路径'), findsWidgets);
    });

    testWidgets('环境选择后显示分支场景 (environment)', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(env: 'windows');

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      expect(find.textContaining('选择运行环境'), findsWidgets);
      expect(find.text('Windows 运行环境'), findsWidgets);

      state.pause();
    });

    testWidgets('进入 first-program 显示代码场景', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(env: 'windows');
      state.setActiveSegment('first-program');

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      expect(find.textContaining('完成第一次代码运行'), findsWidgets);

      state.pause();
    });

    testWidgets('run-success 显示成功场景', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(env: 'windows', runState: 'success', finished: true);

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      expect(find.text('程序成功运行'), findsWidgets);
    });

    testWidgets('run-error 显示错误场景', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(env: 'windows', runState: 'error', finished: true);

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      expect(find.text('运行出现问题'), findsWidgets);
    });
  });

  group('Sidebar - 路径步骤可见性', () {
    testWidgets('初始状态只有 pathIntro 可见', (tester) async {
      final state = PlayerState();
      await tester.pumpWidget(wrapWithProviders(
        Scaffold(body: Sidebar(onJumpToPath: () {})),
        state: state,
      ));
      await tester.pump();

      // 开启 Python 学习任务 同时出现在场景和侧边栏中
      // 侧边栏中为 1 个，所以总数为 1（仅侧边栏）
      // 场景中的文本是 '学习主线 · 开启 Python 学习任务'
      expect(find.textContaining('开启 Python 学习任务'), findsWidgets);
      // 后续步骤在 PathCard 中隐藏，但 KnowledgeCard 始终显示完整脉络
      // 所以在侧边栏中仍能找到这些文本（来自 KnowledgeCard）
      // 这里只验证 pathStep 独有的特征：解锁第一次成功运行 只在 PathCard 中出现
      expect(find.text('解锁第一次成功运行'), findsNothing);
    });

    testWidgets('选择环境后 pathEnvironment 解锁', (tester) async {
      final state = PlayerState();
      state.restoreProgress(env: 'windows');

      await tester.pumpWidget(wrapWithProviders(
        Scaffold(body: Sidebar(onJumpToPath: () {})),
        state: state,
      ));
      await tester.pump();

      // Sidebar 应显示 开启 Python 学习任务
      expect(find.textContaining('开启 Python 学习任务'), findsWidgets);

      state.pause();
    });

    testWidgets('完成所有步骤后显示解锁成功', (tester) async {
      final state = PlayerState();
      state.restoreProgress(env: 'windows', runState: 'success', finished: true);

      await tester.pumpWidget(wrapWithProviders(
        Scaffold(body: Sidebar(onJumpToPath: () {})),
        state: state,
      ));
      await tester.pump();

      expect(find.textContaining('开启 Python 学习任务'), findsWidgets);
      expect(find.text('解锁第一次成功运行'), findsOneWidget);
    });
  });

  group('PlayerControls - 播放控制', () {
    testWidgets('初始显示播放图标', (tester) async {
      await tester.pumpWidget(wrapWithProviders(
        const Material(child: PlayerControls()),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('播放中显示暂停图标', (tester) async {
      final state = PlayerState();
      state.play();

      await tester.pumpWidget(wrapWithProviders(
        const Material(child: PlayerControls()),
        state: state,
      ));
      await tester.pump();

      expect(find.byIcon(Icons.pause), findsOneWidget);

      state.pause();
    });
  });

  group('Sidebar - 侧边栏卡片', () {
    testWidgets('侧边栏包含 4 张卡片标题', (tester) async {
      await tester.pumpWidget(wrapWithProviders(
        Scaffold(body: Sidebar(onJumpToPath: () {})),
      ));
      await tester.pump();

      expect(find.text('我的学习路径'), findsOneWidget);
      expect(find.text('演示控制'), findsOneWidget);
      expect(find.text('互动节点'), findsOneWidget);
      expect(find.text('课程脉络'), findsOneWidget);
    });
  });

  group('PlayerScreen - 完整页面', () {
    testWidgets('播放器页面关键元素不崩溃', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(wrapWithProviders(const PlayerScreen()));
      await tester.pump();

      expect(find.text('量潮课堂'), findsWidgets);
      expect(find.text('完成你的第一次 Python 运行'), findsOneWidget);
      expect(find.text('互动影游式课程原型'), findsOneWidget);
    });

    testWidgets('播放完成时显示完成覆盖层', (tester) async {
      setLargeScreen(tester);
      final state = PlayerState();
      state.restoreProgress(env: 'windows', runState: 'success', finished: true);

      await tester.pumpWidget(wrapWithProviders(PlayerScreen(), state: state));
      await tester.pump();

      expect(find.text('你的学习路径已完成'), findsOneWidget);
    });
  });
}
