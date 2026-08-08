import 'package:flutter/material.dart';

/// 任务卡片 — 场景视觉（main 场景）
///
/// 模拟窗口风格的任务说明卡，用于非视频片段的场景展示。
class TaskCard extends StatelessWidget {
  final String caption;

  const TaskCard({super.key, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 46,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              3,
              (_) => Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(right: 7),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6B6B6B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            caption,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
