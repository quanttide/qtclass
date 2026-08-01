import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_state.dart';
import '../services/course_data.dart';
import '../widgets/player_controls.dart';
import '../widgets/interaction_overlay.dart';
import '../widgets/sidebar.dart';

/// 互动式课程播放器
///
/// 映射自 `doc/screens/player.html` — 核心交互界面。
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<PlayerState>(
          builder: (context, state, _) {
            return Column(
              children: [
                // 顶栏
                _Topbar(state: state),
                // 工作区
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 1040;

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _MainColumn(state: state),
                            ),
                            SizedBox(
                              width: 318,
                              child: Sidebar(
                                onJumpToPath: () => _showConfirmDialog(context, state),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: _MainColumn(state: state),
                            ),
                            SizedBox(
                              height: 320,
                              child: SingleChildScrollView(
                                child: Sidebar(
                                  onJumpToPath: () => _showConfirmDialog(context, state),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, PlayerState state) {
    if (state.env != null || state.runState != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('跳转路径'),
          content: const Text('返回之前的步骤可能影响当前进度。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('知道了'),
            ),
          ],
        ),
      );
    }
  }
}

// ============================================================
// 顶栏
// ============================================================
class _Topbar extends StatelessWidget {
  final PlayerState state;

  const _Topbar({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // 品牌
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onSurface, width: 2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'QC',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '量潮课堂',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Python 基础 · 第1课',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '互动影游式课程原型',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          // 操作按钮
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('← 返回首页'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 主列
// ============================================================
class _MainColumn extends StatelessWidget {
  final PlayerState state;

  const _MainColumn({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 课程标题
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHAPTER 01 · 第一次运行',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '完成你的第一次 Python 运行',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '通过互动节点识别学习状态，根据用户选择进入不同学习路径。',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              // 状态标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      state.finished
                          ? '学习任务完成'
                          : state.playing
                              ? '正在播放'
                              : state.interactionType != null
                                  ? '等待选择'
                                  : '等待播放',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 播放器
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
            child: Column(
              children: [
                // 播放舞台
                Expanded(
                  child: _PlayerStage(state: state),
                ),
                const SizedBox(height: 0),
                // 控制栏
                const PlayerControls(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 播放舞台
// ============================================================
class _PlayerStage extends StatelessWidget {
  final PlayerState state;

  const _PlayerStage({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 760;

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 48,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 场景
              _buildScene(context, state, isNarrow),
              // 字幕框
              _CaptionBox(state: state),
              // 互动覆盖层
              const InteractionOverlay(),
              // 完成覆盖层
              if (state.finished) _FinishOverlay(state: state),
              // 浮动按钮
              Positioned(
                bottom: 14,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FloatButton(
                      label: '${state.playbackRate}×',
                      onTap: () => context.read<PlayerState>().cycleSpeed(),
                    ),
                    const SizedBox(width: 8),
                    _FloatButton(
                      label: '⛶',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScene(BuildContext context, PlayerState state, bool isNarrow) {
    final theme = Theme.of(context);
    final seg = state.currentSegment;
    final sceneKey = seg?.sceneKey ?? 'intro';

    if (isNarrow) {
      return Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SceneText(sceneKey: sceneKey, state: state, theme: theme),
            const SizedBox(height: 20),
            Center(child: _SceneVisual(sceneKey: sceneKey, theme: theme)),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: _SceneText(sceneKey: sceneKey, state: state, theme: theme),
          ),
          const SizedBox(width: 26),
          Expanded(
            flex: 9,
            child: Center(
              child: _SceneVisual(sceneKey: sceneKey, theme: theme),
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneText extends StatelessWidget {
  final String sceneKey;
  final PlayerState state;
  final ThemeData theme;

  const _SceneText({
    required this.sceneKey,
    required this.state,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final data = _sceneTextData(sceneKey, state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.kicker != null)
          Text(
            data.kicker!,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        if (data.kicker != null) const SizedBox(height: 12),
        Text(
          data.title,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.14,
            letterSpacing: -0.3,
          ),
        ),
        if (data.desc != null) ...[
          const SizedBox(height: 18),
          Text(
            data.desc!,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.8,
              fontSize: 15,
            ),
          ),
        ],
      ],
    );
  }

  _SceneTextData _sceneTextData(String key, PlayerState state) {
    switch (key) {
      case 'intro':
        return const _SceneTextData(
          kicker: '学习主线 · 开启 Python 学习任务',
          title: '你的学习路径，将由你的选择展开。',
          desc: '不同学习者的设备环境和遇到的卡点各不相同。互动节点帮助系统理解你的状态，提供更适合你的学习路径。',
        );
      case 'environment':
        final isWindows = state.currentSegmentId == 'windows';
        final isMacos = state.currentSegmentId == 'macos';
        return _SceneTextData(
          kicker: '个性化分支 · 选择运行环境',
          title: isWindows
              ? 'Windows 运行环境'
              : isMacos
                  ? 'macOS 运行环境'
                  : 'Linux 运行环境',
          desc: isWindows
              ? '了解该环境下运行 Python 程序时需要注意的问题。确认 Python 解释器后，可通过 VS Code 运行按钮执行 .py 文件。'
              : isMacos
                  ? '了解该环境下运行 Python 程序时需要注意的问题。可在 Terminal 使用 python3 命令，也可在 VS Code 中选择对应解释器。'
                  : '了解该环境下运行 Python 程序时需要注意的问题。先确认 python3 --version，再通过 python3 文件名.py 运行程序。',
        );
      case 'first-program':
        return const _SceneTextData(
          kicker: '学习主线 · 完成第一次代码运行',
          title: '完成第一次代码运行任务',
          desc: '无论使用什么系统，Python 代码是通用的。下面我们编写一个简单的 print 语句，然后尝试运行它。',
        );
      case 'run-state':
        final isSuccess = state.currentSegmentId == 'run-success';
        final isError = state.currentSegmentId == 'run-error';
        return _SceneTextData(
          kicker: '个性化分支 · 处理运行反馈',
          title: isSuccess
              ? '程序成功运行'
              : isError
                  ? '运行出现问题'
                  : '不确定下一步操作',
          desc: isSuccess
              ? '你的环境配置正确，程序已顺利输出结果。可以继续学习后续内容。'
              : isError
                  ? '程序没有按照预期运行，常见原因：缩进不对、拼写错误或环境变量未配置。'
                  : '代码已完成，但不确定如何执行。运行 Python 程序只需几个简单步骤。',
        );
      default:
        return const _SceneTextData(title: '');
    }
  }
}

class _SceneTextData {
  final String? kicker;
  final String title;
  final String? desc;

  const _SceneTextData({this.kicker, required this.title, this.desc});
}

class _SceneVisual extends StatelessWidget {
  final String sceneKey;
  final ThemeData theme;

  const _SceneVisual({required this.sceneKey, required this.theme});

  @override
  Widget build(BuildContext context) {
    switch (sceneKey) {
      case 'intro':
        return _OrbitVisual(theme: theme);
      case 'environment':
        return _SystemCard(theme: theme);
      case 'first-program':
        return _CodeCard();
      case 'run-state':
        return _TerminalCard(theme: theme);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _OrbitVisual extends StatelessWidget {
  final ThemeData theme;
  const _OrbitVisual({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.onSurface, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Python',
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w900,
              fontSize: 28,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  final ThemeData theme;
  const _SystemCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.onSurface, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 顶部小条
          Container(
            width: 55,
            height: 7,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 10),
          // 模拟屏幕
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(10),
              color: theme.colorScheme.surfaceContainerLow,
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Bar(width: 0.82, color: theme.colorScheme.primary),
                const SizedBox(height: 8),
                _Bar(width: 0.66, color: null),
                const SizedBox(height: 8),
                _Bar(width: 0.48, color: null),
                const SizedBox(height: 8),
                _Bar(width: 0.74, color: null),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double width;
  final Color? color;

  const _Bar({required this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: width,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: color ?? Colors.grey.shade300,
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 46,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '# 完成第一次代码运行',
            style: TextStyle(fontFamily: 'monospace', color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.75),
              children: [
                TextSpan(
                  text: 'print',
                  style: TextStyle(color: Colors.green.shade300),
                ),
                const TextSpan(
                  text: '(',
                  style: TextStyle(color: Colors.white70),
                ),
                TextSpan(
                  text: '"Hello, Python!"',
                  style: TextStyle(color: Colors.orange.shade200),
                ),
                const TextSpan(
                  text: ')',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalCard extends StatelessWidget {
  final ThemeData theme;
  const _TerminalCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlayerState>();
    final isSuccess = state.currentSegmentId == 'run-success';
    final isError = state.currentSegmentId == 'run-error';

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 46,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部圆点
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF383838))),
            ),
            child: Row(
              children: List.generate(3, (_) => Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(right: 7),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6B6B6B),
                ),
              )),
            ),
          ),
          // 终端内容
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSuccess) ...[
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.8),
                      children: [
                        const TextSpan(
                          text: '\$ python3 hello.py',
                          style: TextStyle(color: Color(0xFF9CC6AD)),
                        ),
                        TextSpan(
                          text: '\nHello, Python!',
                          style: TextStyle(color: Colors.green.shade300),
                        ),
                      ],
                    ),
                  ),
                ] else if (isError) ...[
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.8),
                      children: [
                        const TextSpan(
                          text: '\$ python3 hello.py',
                          style: TextStyle(color: Color(0xFF9CC6AD)),
                        ),
                        TextSpan(
                          text: '\nSyntaxError: invalid syntax',
                          style: TextStyle(color: Colors.red.shade300),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.8),
                      children: [
                        const TextSpan(
                          text: '\$ which python3',
                          style: TextStyle(color: Color(0xFF9CC6AD)),
                        ),
                        const TextSpan(
                          text: '\n/usr/bin/python3',
                          style: TextStyle(color: Color(0xFFBCE7C8)),
                        ),
                        const TextSpan(
                          text: '\n\$ python3 hello.py',
                          style: TextStyle(color: Color(0xFF9CC6AD)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 字幕框
// ============================================================
class _CaptionBox extends StatelessWidget {
  final PlayerState state;

  const _CaptionBox({required this.state});

  @override
  Widget build(BuildContext context) {
    final seg = state.currentSegment;

    return Positioned(
      left: 21,
      right: 21,
      bottom: 24,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 840),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFF171717).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          state.finished
              ? '学习完成！你可以查看学习记录或重新开始。'
              : (seg?.caption ?? '点击播放，开始你的学习任务。'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.55,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 浮动按钮
// ============================================================
class _FloatButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FloatButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF171717).withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 完成覆盖层
// ============================================================
class _FinishOverlay extends StatelessWidget {
  final PlayerState state;

  const _FinishOverlay({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final env = state.env ?? 'windows';
    final envDisplay = CourseData.labelEnv(env);

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.96),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✓ 圆环
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 34,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  '你的学习路径已完成',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '本次学习过程中，你通过不同选择完成了一条适合自己的学习路径。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 20),
                // 信息行
                Row(
                  children: [
                    Expanded(
                      child: _ResultInfoCard(
                        theme: theme,
                        title: '你的学习路线',
                        value: '$envDisplay 运行环境',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResultInfoCard(
                        theme: theme,
                        title: '当前阶段',
                        value: '解锁第一次成功运行',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.read<PlayerState>().resetAll(),
                      child: const Text('重播'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('下一课程即将上线，敬请期待'),
                          ),
                        );
                      },
                      child: const Text('继续学习'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultInfoCard extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String value;

  const _ResultInfoCard({
    required this.theme,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 历史记录弹窗
