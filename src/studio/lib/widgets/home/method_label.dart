import 'package:flutter/material.dart';

/// 方法标签 — 互动式学习方式关键词
///
/// 映射自 `doc/screens/home.md → 页面结构 · MethodLabel`。
class MethodLabel extends StatelessWidget {
  final String text;

  const MethodLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: theme.colorScheme.onSurfaceVariant,
        letterSpacing: 0.1,
      ),
    );
  }
}
