import 'package:flutter/material.dart';
import '../../services/course_data.dart';

/// 学习目标列表 — 勾选列表，展示本节学习目标
///
/// 目标来自课程数据（`CourseData.objectives`）。
/// 映射自 `doc/screens/home.md → 页面结构 · ObjectivesList`。
class ObjectivesList extends StatelessWidget {
  const ObjectivesList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '本节你将掌握',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        ...CourseData.objectives.map((o) => ObjectiveItem(text: o)),
      ],
    );
  }
}

/// 学习目标单项 — 勾选图标 + 目标文案
///
/// 映射自 `doc/screens/home.md → 组件清单 · ObjectivesList（子项 ObjectiveItem）`。
class ObjectiveItem extends StatelessWidget {
  final String text;

  const ObjectiveItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '✓',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
