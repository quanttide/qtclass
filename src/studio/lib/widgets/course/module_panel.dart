import 'package:flutter/material.dart';
import '../../models/course.dart';

/// 模块面板 — 一屏一模块的课时列表
///
/// 映射自 `doc/screens/course-detail.md → .module-panel / .lesson-item`：
/// 课时条目点击进入播放器（v0.1 衔接现有 PlayerScreen）。
class ModulePanel extends StatelessWidget {
  final CourseStage stage;
  final VoidCallback onNext;
  final VoidCallback onBackToHero;
  final ValueChanged<CourseLesson> onLessonTap;

  /// 可选：模块底部动作（生产实习 m5 的"提交立项"入口）。
  final Widget? footerAction;

  const ModulePanel({
    super.key,
    required this.stage,
    required this.onNext,
    required this.onBackToHero,
    required this.onLessonTap,
    this.footerAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 模块标题
            Text(
              '📖 ${stage.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 课时条目
            for (final lesson in stage.lessons) _lessonItem(theme, lesson),
            const SizedBox(height: 24),
            // 操作按钮
            Row(
              children: [
                FilledButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('下一模块'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: onBackToHero,
                  child: const Text('← 返回课程首页'),
                ),
                if (footerAction != null) ...[const Spacer(), footerAction!],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lessonItem(ThemeData theme, CourseLesson lesson) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onLessonTap(lesson),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (lesson.type.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      lesson.type,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  lesson.duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
