import 'package:flutter/material.dart';
import '../../services/course_data.dart';

/// 课程脉络卡片 — 展示课程全部步骤索引
///
/// 步骤列表来自课程数据（`CourseData.pathSteps`）。
/// 映射自 `doc/screens/player.md → 侧边栏 · 课程脉络`。
class KnowledgeCard extends StatelessWidget {
  const KnowledgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = CourseData.pathSteps;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '课程脉络',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  children: [
                    Text(
                      '${i + 1}'.padLeft(2, '0'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        steps[i].label,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
