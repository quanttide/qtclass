import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/course_data.dart';
import '../../services/player_state.dart';
import '../cards/result_info_card.dart';

/// 完成覆盖层 — 学习路径完成后的结果展示
class FinishOverlay extends StatelessWidget {
  final PlayerState state;

  const FinishOverlay({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doneCount = CourseData.pathSteps
        .where((s) => state.visited.contains(s.segmentId))
        .length;

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.96),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✓ 圆环
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 34,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  '你的学习路径已完成',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '本次学习过程中，你通过不同选择完成了一条适合自己的学习路径。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 20),
                // 信息行
                Row(
                  children: [
                    Expanded(
                      child: ResultInfoCard(
                        theme: theme,
                        title: '学习进度',
                        value:
                            '已完成 $doneCount/${CourseData.pathSteps.length} 步',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ResultInfoCard(
                        theme: theme,
                        title: '当前阶段',
                        value: '课时完成',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.read<PlayerState>().resetAll(),
                      child: const Text('重播'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('下一课程即将上线，敬请期待')),
                        );
                      },
                      child: const Text('继续学习'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
