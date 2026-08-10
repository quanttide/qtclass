import 'package:flutter/material.dart';

/// 开始学习按钮 — 跳转播放器或恢复学习
///
/// 映射自 `doc/screens/home.md → 页面结构 · StartButton`。
class StartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: const Text(
          '开始学习',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
