import 'package:flutter/material.dart';

/// 步骤条 — 课程模块导航（StepBar）
///
/// 映射自 `doc/screens/course-detail.md → .steps / .stepbar`：
/// 步骤节点三态：ok（绿底白勾）/ on（蓝底白字）/ 默认（灰底灰字）。
/// 完成态之间的连接线变绿。
class StepBar extends StatelessWidget {
  final List<String> labels; // 模块名（与 stages 顺序一致）
  final int maxDone; // 已完成模块数（ok 态数量）
  final int current; // 当前模块下标（on 态）
  final ValueChanged<int> onSelect;

  const StepBar({
    super.key,
    required this.labels,
    required this.maxDone,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++) ...[
              if (i > 0) _connector(done: i <= maxDone, theme: theme),
              _stepNode(
                index: i,
                label: labels[i],
                state: i == current
                    ? _StepState.current
                    : (i < maxDone ? _StepState.done : _StepState.todo),
                theme: theme,
                onTap: () => onSelect(i),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _connector({required bool done, required ThemeData theme}) {
    final color = done
        ? Colors.green
        : theme.colorScheme.onSurface.withValues(alpha: 0.2);
    return Container(width: 24, height: 2, color: color);
  }

  Widget _stepNode({
    required int index,
    required String label,
    required _StepState state,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    final Color bg;
    final Color fg;
    final IconData? icon;
    switch (state) {
      case _StepState.done:
        bg = Colors.green;
        fg = Colors.white;
        icon = Icons.check;
      case _StepState.current:
        bg = theme.colorScheme.primary;
        fg = Colors.white;
        icon = null;
      case _StepState.todo:
        bg = theme.colorScheme.onSurface.withValues(alpha: 0.1);
        fg = theme.colorScheme.onSurface.withValues(alpha: 0.5);
        icon = null;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
              alignment: Alignment.center,
              child: icon != null
                  ? Icon(icon, size: 16, color: fg)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: fg),
                    ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: state == _StepState.current ? FontWeight.w700 : FontWeight.w400,
                color: state == _StepState.done
                    ? Colors.green
                    : (state == _StepState.current
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _StepState { done, current, todo }