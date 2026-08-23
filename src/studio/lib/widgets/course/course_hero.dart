import 'package:flutter/material.dart';
import '../../models/course.dart';

/// 课程 Hero 区 — 详情页顶部概览卡片
///
/// 映射自 `doc/screens/course-detail.md → .course-hero`：
/// 标签 + 标题 + 描述 + 元信息（模块数/时长/人数）+ 进度条 + CTA。
class CourseHero extends StatelessWidget {
  final Course course;
  final double progress; // 0.0 ~ 1.0
  final VoidCallback onContinue;
  final VoidCallback? onTeam;

  const CourseHero({
    super.key,
    required this.course,
    required this.progress,
    required this.onContinue,
    this.onTeam,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${course.icon} ${course.badge}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 标题
          Text(
            course.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // 描述
          Text(
            course.desc,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          // 元信息
          Text(
            '📚 ${course.meta.modules} 个模块 · ⏱ ${course.meta.duration} · ${course.meta.students} 人在学',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 20),
          // CTA
          Row(
            children: [
              FilledButton.icon(
                onPressed: onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.play_arrow, size: 20),
                label: const Text('继续学习'),
              ),
              if (onTeam != null) ...[
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: onTeam,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.group, size: 18),
                  label: const Text('组队广场'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
