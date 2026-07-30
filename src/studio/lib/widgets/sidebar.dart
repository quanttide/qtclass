import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_state.dart';
import '../services/course_data.dart';

/// 侧边栏 — 学习路径、演示控制、互动节点、课程脉络
///
/// 映射自 `doc/screens/player.md → 侧边栏`。
class Sidebar extends StatelessWidget {
  final VoidCallback onJumpToPath;

  const Sidebar({super.key, required this.onJumpToPath});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(
      builder: (context, state, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _PathCard(state: state, onJumpToPath: onJumpToPath),
              const SizedBox(height: 14),
              _DemoCard(state: state),
              const SizedBox(height: 14),
              _NodeStatusCard(state: state),
              const SizedBox(height: 14),
              _KnowledgeCard(),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// 我的学习路径
// ============================================================
class _PathCard extends StatelessWidget {
  final PlayerState state;
  final VoidCallback onJumpToPath;

  const _PathCard({required this.state, required this.onJumpToPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '我的学习路径',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 14),
            _PathStep(
              theme: theme,
              stepIndex: 0,
              label: '开启 Python 学习任务',
              meta: '学习主线',
              isDone: state.env != null || state.finished,
              isCurrent: state.currentSegmentId == 'intro',
              hidden: false,
            ),
            _PathStep(
              theme: theme,
              stepIndex: 1,
              label: '选择运行环境',
              meta: state.env != null ? CourseData.labelEnv(state.env) : 'Windows / macOS / Linux',
              isDone: state.env != null,
              isCurrent: ['windows', 'macos', 'linux'].contains(state.currentSegmentId),
              hidden: state.env == null && !state.finished,
              chip: state.env != null ? CourseData.labelEnv(state.env) : null,
            ),
            _PathStep(
              theme: theme,
              stepIndex: 2,
              label: '完成第一次代码运行',
              meta: '运行 print("Hello, Python!")',
              isDone: state.runState != null || state.finished,
              isCurrent: state.currentSegmentId == 'first-program',
              hidden: state.env == null && !state.finished,
            ),
            _PathStep(
              theme: theme,
              stepIndex: 3,
              label: '处理运行反馈',
              meta: state.runState != null
                  ? CourseData.labelRunState(state.runState)
                  : '程序成功运行 / 运行出现问题 / 不确定下一步操作',
              isDone: state.finished || state.runState != null,
              isCurrent: ['run-success', 'run-error', 'run-unknown']
                  .contains(state.currentSegmentId),
              hidden: !state.finished && state.runState == null && state.env == null,
              chip: state.runState != null ? CourseData.labelRunState(state.runState) : null,
            ),
            _PathStep(
              theme: theme,
              stepIndex: 4,
              label: '解锁第一次成功运行',
              meta: '课程完成',
              isDone: state.finished,
              isCurrent: false,
              hidden: !state.finished,
            ),
          ],
        ),
      ),
    );
  }
}

class _PathStep extends StatelessWidget {
  final ThemeData theme;
  final int stepIndex;
  final String label;
  final String meta;
  final bool isDone;
  final bool isCurrent;
  final bool hidden;
  final String? chip;

  const _PathStep({
    required this.theme,
    required this.stepIndex,
    required this.label,
    required this.meta,
    required this.isDone,
    required this.isCurrent,
    required this.hidden,
    this.chip,
  });

  @override
  Widget build(BuildContext context) {
    if (hidden) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 竖线 + 圆点
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone || isCurrent
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: 1.5,
                    ),
                    color: isDone
                        ? theme.colorScheme.primary
                        : isCurrent
                            ? theme.colorScheme.primaryContainer
                            : Colors.transparent,
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.check,
                            size: 14, color: theme.colorScheme.onPrimary)
                        : isCurrent
                            ? Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : null,
                  ),
                ),
                // 竖线
                if (stepIndex < 4)
                  Container(
                    width: 1,
                    height: 28,
                    color: isDone
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // 内容
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isCurrent
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    meta,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  if (chip != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          chip!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 演示控制
// ============================================================
class _DemoCard extends StatelessWidget {
  final PlayerState state;

  const _DemoCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '演示控制',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.read<PlayerState>().seek(1.0),
                    child: const Text('跳至下一节点'),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.read<PlayerState>().resetAll(),
                    child: const Text('重置全部状态'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 互动节点状态
// ============================================================
class _NodeStatusCard extends StatelessWidget {
  final PlayerState state;

  const _NodeStatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '互动节点',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 14),
            _NodeStatusItem(
              theme: theme,
              index: '01',
              label: '选择运行环境',
              status: state.env != null
                  ? '已选择 ${CourseData.labelEnv(state.env)}'
                  : '待完成',
              isDone: state.env != null,
            ),
            const SizedBox(height: 9),
            _NodeStatusItem(
              theme: theme,
              index: '02',
              label: '处理运行反馈',
              status: state.runState != null
                  ? '已选择 ${CourseData.labelRunState(state.runState)}'
                  : '待完成',
              isDone: state.runState != null,
            ),
          ],
        ),
      ),
    );
  }
}

class _NodeStatusItem extends StatelessWidget {
  final ThemeData theme;
  final String index;
  final String label;
  final String status;
  final bool isDone;

  const _NodeStatusItem({
    required this.theme,
    required this.index,
    required this.label,
    required this.status,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(index, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: isDone
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isDone ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 课程脉络
// ============================================================
class _KnowledgeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      ('01', '开启 Python 学习任务'),
      ('02', '选择运行环境'),
      ('03', '完成第一次代码运行'),
      ('04', '处理运行反馈与排查'),
    ];

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
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    children: [
                      Text(
                        item.$1,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.$2,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
