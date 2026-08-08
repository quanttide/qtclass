import 'package:flutter/material.dart';

/// 终端卡片 — 场景视觉（error / success 场景）
///
/// 模拟终端窗口风格的排查/结果展示卡。
class TerminalCard extends StatelessWidget {
  final ThemeData theme;
  final String caption;

  const TerminalCard({super.key, required this.theme, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 46,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部圆点
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF383838))),
            ),
            child: Row(
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
          ),
          // 终端内容
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              caption,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
