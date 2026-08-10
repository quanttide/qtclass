import 'package:flutter/material.dart';

/// 课程副标题 — 课程简介文案
///
/// 映射自 `doc/screens/home.md → 页面结构 · CourseSubtitle`。
class CourseSubtitle extends StatelessWidget {
  final String text;

  const CourseSubtitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.65,
      ),
    );
  }
}
