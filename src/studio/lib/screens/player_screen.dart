import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
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
                            Expanded(child: _MainColumn(state: state)),
                            SizedBox(
                              width: 318,
                              child: Sidebar(
                                onJumpToPath: () =>
                                    _showConfirmDialog(context, state),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(child: _MainColumn(state: state)),
                            SizedBox(
                              height: 320,
                              child: SingleChildScrollView(
                                child: Sidebar(
                                  onJumpToPath: () =>
                                      _showConfirmDialog(context, state),
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
    if (state.visited.length > 1) {
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
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isNarrow ? 14 : 28),
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
          // 标题（窄屏收缩 + 省略号）
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '量潮课堂',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  CourseData.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // 次要标签（窄屏隐藏）
          if (!isNarrow) const SizedBox(width: 20),
          if (!isNarrow)
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
          const SizedBox(width: 8),
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
                      '课时1 · 开发环境搭建',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CourseData.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CourseData.description,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
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
                          : state.interactionId != null
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
                Expanded(child: _PlayerStage(state: state)),
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
                    _FloatButton(label: '⛶', onTap: () {}),
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
    final caption = seg?.caption ?? '';

    // 视频片段：全区域播放视频
    if (seg?.video != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: _VideoScene(assetPath: seg!.video!, state: state),
        ),
      );
    }

    if (isNarrow) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SceneText(sceneKey: sceneKey, state: state, theme: theme),
            const SizedBox(height: 20),
            Center(
              child: _SceneVisual(
                sceneKey: sceneKey,
                caption: caption,
                theme: theme,
              ),
            ),
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
              child: _SceneVisual(
                sceneKey: sceneKey,
                caption: caption,
                theme: theme,
              ),
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
    final seg = state.currentSegment;
    if (seg == null) return const _SceneTextData(title: '');
    return _SceneTextData(
      kicker: seg.chapter,
      title: seg.title.isNotEmpty ? seg.title : seg.caption,
      desc: seg.caption,
    );
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
  final String caption;
  final ThemeData theme;

  const _SceneVisual({
    required this.sceneKey,
    required this.caption,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    switch (sceneKey) {
      case 'intro':
        return _OrbitVisual(theme: theme);
      case 'main':
        return _TaskCard(caption: caption);
      case 'error':
      case 'success':
        return _TerminalCard(caption: caption, theme: theme);
      default:
        return const SizedBox.shrink();
    }
  }
}

/// 视频场景 — 片段关联视频时全区域播放
///
/// 与 [PlayerState] 联动：播放/暂停同步；视频结束时触发片段结束。
/// 平台不支持 video_player 时（如 Linux 桌面）降级显示提示。
class _VideoScene extends StatefulWidget {
  final String assetPath;
  final PlayerState state;

  const _VideoScene({required this.assetPath, required this.state});

  @override
  State<_VideoScene> createState() => _VideoSceneState();
}

class _VideoSceneState extends State<_VideoScene> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void didUpdateWidget(_VideoScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _disposeVideo();
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    debugPrint('VIDEO: init start ${widget.assetPath}');
    final controller = VideoPlayerController.asset(widget.assetPath);
    try {
      await controller.initialize().timeout(const Duration(seconds: 30));
      if (!mounted) {
        await controller.dispose();
        return;
      }
      debugPrint('VIDEO: init ok duration=${controller.value.duration}');
      setState(() => _controller = controller);
      // 同步视频实际时长到播放器状态
      final duration = controller.value.duration.inMilliseconds / 1000;
      widget.state.setDurationOverride(duration);
      if (widget.state.playing) controller.play();
      controller.addListener(_onVideoTick);
    } catch (e) {
      debugPrint('VIDEO: init FAILED: $e');
      await controller.dispose();
      if (mounted) {
        setState(() {
          _failed = true;
          _controller = null;
        });
      }
    }
  }

  void _onVideoTick() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isCompleted && !widget.state.finished) {
      widget.state.seek(1.0); // 视频播放完 → 触发片段结束
    }
  }

  void _syncPlayback() {
    final controller = _controller;
    if (controller == null) return;
    if (widget.state.playing && !controller.value.isPlaying) {
      controller.play();
    } else if (!widget.state.playing && controller.value.isPlaying) {
      controller.pause();
    }
  }

  void _disposeVideo() {
    _controller?.removeListener(_onVideoTick);
    _controller?.dispose();
    _controller = null;
    // 不在此通知：dispose 期间 notifyListeners 会触发 markNeedsBuild 异常；
    // 片段切换时 PlayerState.setActiveSegment 已清除动态时长
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 播放状态联动
    widget.state.addListener(_syncPlayback);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPlayback());

    if (_failed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.videocam_off,
              size: 40,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            const Text(
              '当前平台暂不支持视频播放，请在 Web 端查看课时视频。',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: VideoPlayer(controller),
      ),
    );
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
            'Zed',
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

class _TaskCard extends StatelessWidget {
  final String caption;

  const _TaskCard({required this.caption});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
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
          Row(
            children: List.generate(
              3,
              (_) => Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(right: 7),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6B6B6B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            caption,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalCard extends StatelessWidget {
  final ThemeData theme;
  final String caption;
  const _TerminalCard({required this.theme, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
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
              children: List.generate(
                3,
                (_) => Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.only(right: 7),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ),
            ),
          ),
          // 终端内容
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              caption,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.7,
              ),
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
    final doneCount = CourseData.pathSteps
        .where((s) => state.visited.contains(s.segmentId))
        .length;

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
                        title: '学习进度',
                        value:
                            '已完成 $doneCount/${CourseData.pathSteps.length} 步',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResultInfoCard(
                        theme: theme,
                        title: '当前阶段',
                        value: '课时完成',
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
                          const SnackBar(content: Text('下一课程即将上线，敬请期待')),
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
