import 'package:flutter/material.dart';

/// 课程分类标签 — 课程类型与系列标识
///
/// 映射自 `doc/screens/home.md → 页面结构 · CourseTag`。
class CourseTag extends StatelessWidget {
  final String label;

  const CourseTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
