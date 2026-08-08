import 'package:flutter/material.dart';

/// 浮动按钮 — 播放舞台右下角的快捷操作
class FloatButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const FloatButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF171717).withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
