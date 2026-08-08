import 'package:flutter/material.dart';
import '../../services/player_state.dart';

/// 字幕框 — 播放舞台底部的提示字幕
class CaptionBox extends StatelessWidget {
  final PlayerState state;

  const CaptionBox({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final seg = state.currentSegment;

    return Positioned(
      left: 21,
      right: 21,
      bottom: 24,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 840),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFF171717).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          state.finished
              ? '学习完成！你可以查看学习记录或重新开始。'
              : (seg?.caption ?? '点击播放，开始你的学习任务。'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.55,
          ),
        ),
      ),
    );
  }
}
