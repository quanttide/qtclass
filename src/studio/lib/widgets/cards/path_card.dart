import 'package:flutter/material.dart';
import '../../services/course_data.dart';
import '../../services/player_state.dart';

/// 我的学习路径卡片 — 展示课程路径步骤与完成状态
///
/// 路径步骤来自课程数据（`CourseData.pathSteps`）。
/// 映射自 `doc/screens/player.md → 侧边栏 · 我的学习路径`。
class PathCard extends StatelessWidget {
  final PlayerState state;
  final VoidCallback onJumpToPath;

  const PathCard({super.key, required this.state, required this.onJumpToPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = CourseData.pathSteps;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '我的学习路径',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < steps.length; i++)
              _PathStep(
                theme: theme,
                stepIndex: i,
                stepCount: steps.length,
                label: steps[i].label,
                meta: steps[i].meta,
                isDone:
                    state.finished ||
                    (state.visited.contains(steps[i].segmentId) &&
                        state.currentSegmentId != steps[i].segmentId),
                isCurrent: state.currentSegmentId == steps[i].segmentId,
              ),
          ],
        ),
      ),
    );
  }
}

class _PathStep extends StatelessWidget {
  final ThemeData theme;
  final int stepIndex;
  final int stepCount;
  final String label;
  final String meta;
  final bool isDone;
  final bool isCurrent;

  const _PathStep({
    required this.theme,
    required this.stepIndex,
    required this.stepCount,
    required this.label,
    required this.meta,
    required this.isDone,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 竖线 + 圆点
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone || isCurrent
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: 1.5,
                    ),
                    color: isDone
                        ? theme.colorScheme.primary
                        : isCurrent
                        ? theme.colorScheme.primaryContainer
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(
                            Icons.check,
                            size: 14,
                            color: theme.colorScheme.onPrimary,
                          )
                        : isCurrent
                        ? Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : null,
                  ),
                ),
                // 竖线
                if (stepIndex < stepCount - 1)
                  Container(
                    width: 1,
                    height: 28,
                    color: isDone
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // 内容
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isCurrent
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    meta,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
