import 'package:flutter/material.dart';

/// 课程主标题 — 课程名称
///
/// 映射自 `doc/screens/home.md → 页面结构 · CourseTitle`。
class CourseTitle extends StatelessWidget {
  final String text;

  const CourseTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.3,
      ),
    );
  }
}
