import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_state.dart';
import '../services/course_data.dart';

/// 侧边栏 — 学习路径、演示控制、互动节点、课程脉络
///
/// 路径 / 互动节点 / 脉络均来自课程数据（`CourseData.pathSteps` 等）。
/// 映射自 `doc/screens/player.md → 侧边栏`。
class Sidebar extends StatelessWidget {
  final VoidCallback onJumpToPath;

  const Sidebar({super.key, required this.onJumpToPath});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(
      builder: (context, state, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _PathCard(state: state, onJumpToPath: onJumpToPath),
              const SizedBox(height: 14),
              _DemoCard(state: state),
              const SizedBox(height: 14),
              _NodeStatusCard(state: state),
              const SizedBox(height: 14),
              _KnowledgeCard(),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// 我的学习路径
// ============================================================
class _PathCard extends StatelessWidget {
  final PlayerState state;
  final VoidCallback onJumpToPath;

  const _PathCard({required this.state, required this.onJumpToPath});

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

// ============================================================
// 演示控制
// ============================================================
class _DemoCard extends StatelessWidget {
  final PlayerState state;

  const _DemoCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '演示控制',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.read<PlayerState>().seek(1.0),
                    child: const Text('跳至下一节点'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.read<PlayerState>().resetAll(),
                    child: const Text('重置全部状态'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 互动节点状态
// ============================================================
class _NodeStatusCard extends StatelessWidget {
  final PlayerState state;

  const _NodeStatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nodes = CourseData.interactionNodes;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '互动节点',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 14),
            for (final node in nodes)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _NodeStatusItem(
                  theme: theme,
                  index: node.index,
                  label: node.label,
                  isDone: _isNodeDone(state, node.interactionId),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 互动节点完成判定：该互动的任一选项已被选择，或课程已完成
  bool _isNodeDone(PlayerState state, String interactionId) {
    if (state.finished) return true;
    final interaction = CourseData.interactions[interactionId];
    if (interaction == null) return false;
    return interaction.options.any((o) => state.triedChoices.contains(o.id));
  }
}

class _NodeStatusItem extends StatelessWidget {
  final ThemeData theme;
  final String index;
  final String label;
  final bool isDone;

  const _NodeStatusItem({
    required this.theme,
    required this.index,
    required this.label,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(index, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(
            isDone ? '已完成' : '待完成',
            style: TextStyle(
              fontSize: 12,
              color: isDone
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isDone ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 课程脉络
// ============================================================
class _KnowledgeCard extends StatelessWidget {
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
              '课程脉络',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  children: [
                    Text(
                      '${i + 1}'.padLeft(2, '0'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        steps[i].label,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
