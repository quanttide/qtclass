import 'package:flutter/material.dart';
import '../../services/course_data.dart';
import '../../services/player_state.dart';

/// 互动节点状态卡片 — 展示各互动节点的完成情况
///
/// 节点列表来自课程数据（`CourseData.interactionNodes`）。
/// 映射自 `doc/screens/player.md → 侧边栏 · 互动节点`。
class NodeStatusCard extends StatelessWidget {
  final PlayerState state;

  const NodeStatusCard({super.key, required this.state});

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
