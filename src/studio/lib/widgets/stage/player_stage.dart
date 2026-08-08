import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/player_state.dart';
import '../cards/task_card.dart';
import '../cards/terminal_card.dart';
import '../common/caption_box.dart';
import '../common/float_button.dart';
import '../common/scene_text.dart';
import '../dialogs/finish_overlay.dart';
import '../dialogs/interaction_overlay.dart';
import 'video_scene.dart';

/// 播放舞台 — 场景渲染、字幕、互动/完成覆盖层、浮动按钮
///
/// 宽屏布局需要足够的纵向空间：舞台过矮时回退到可滚动窄布局，
/// 否则场景文字（kicker+标题+描述）会被压缩溢出（如手机横屏）。
class PlayerStage extends StatelessWidget {
  final PlayerState state;

  const PlayerStage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow =
            constraints.maxWidth < 760 || constraints.maxHeight < 260;

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
              CaptionBox(state: state),
              // 互动覆盖层
              const InteractionOverlay(),
              // 完成覆盖层
              if (state.finished) FinishOverlay(state: state),
              // 浮动按钮
              Positioned(
                bottom: 14,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatButton(
                      label: '${state.playbackRate}×',
                      onTap: () => context.read<PlayerState>().cycleSpeed(),
                    ),
                    const SizedBox(width: 8),
                    FloatButton(label: '⛶', onTap: () {}),
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
          child: VideoScene(assetPath: seg!.video!, state: state),
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
            SceneText(sceneKey: sceneKey, state: state, theme: theme),
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
            child: SceneText(sceneKey: sceneKey, state: state, theme: theme),
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

/// 场景视觉分发 — 按场景类型渲染对应视觉组件
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
        return TaskCard(caption: caption);
      case 'error':
      case 'success':
        return TerminalCard(caption: caption, theme: theme);
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
