import 'package:flutter/material.dart';

/// 难度胶囊标签 — 4 种变体
///
/// 映射自 `doc/screens/course-list.md → 难度标签 .badge`：
/// beginner（入门）/ intermediate（进阶）/ advanced（高阶）/ capstone（实训）。
class DifficultyBadge extends StatelessWidget {
  final String label;
  final String badgeClass;

  const DifficultyBadge({super.key, required this.label, required this.badgeClass});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _color),
      ),
    );
  }

  Color get _color => switch (badgeClass) {
    'intermediate' => Colors.teal,
    'advanced' => Colors.indigo,
    'capstone' => const Color(0xFF2F6B4F),
    _ => Colors.blue,
  };
}