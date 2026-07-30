import 'package:flutter/material.dart';
import '../services/course_data.dart';

/// 结果页 — 课程完成后的学习路径总结
///
/// 映射自 `doc/screens/result.html`。
class ResultScreen extends StatelessWidget {
  final String env;

  const ResultScreen({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final envDisplay = CourseData.labelEnv(env);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 导航栏
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              height: 56,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                children: [
                  Text(
                    '量潮课堂',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    ),
                    child: const Text('← 返回首页'),
                  ),
                ],
              ),
            ),
            // 内容
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      children: [
                        // 标签
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '分支结果 · 学习路径生成',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '你的 Python 学习路径已生成',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '根据你的设备环境，我们调整了对应的运行方式。不同选择会影响学习入口，但最终都会进入 Python 基础学习。',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // 路径可视化
                        _buildPathVisualization(theme),
                        const SizedBox(height: 44),
                        // 信息卡片
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCard(
                                theme: theme,
                                title: '你的学习路线',
                                value: '$envDisplay 运行环境',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _InfoCard(
                                theme: theme,
                                title: '当前阶段',
                                value: '解锁第一次成功运行',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // 继续按钮
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('下一课程即将上线，敬请期待'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: const Text(
                            '继续学习',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathVisualization(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PathNode(
          theme: theme,
          label: '开启 Python 学习任务',
          isDone: true,
        ),
        _PathLine(theme: theme, isDone: true),
        _PathNode(
          theme: theme,
          label: '选择运行环境',
          isDone: true,
        ),
        _PathLine(theme: theme, isDone: false),
        _PathNode(
          theme: theme,
          label: '解锁第一次成功运行',
          isDone: false,
          isNext: true,
        ),
      ],
    );
  }
}

class _PathNode extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final bool isDone;
  final bool isNext;

  const _PathNode({
    required this.theme,
    required this.label,
    required this.isDone,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone ? theme.colorScheme.primary : theme.dividerColor,
              width: 2,
            ),
            color: isDone
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check, color: theme.colorScheme.primary, size: 20)
                : Icon(Icons.arrow_forward,
                    color: theme.colorScheme.primary, size: 20),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDone ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PathLine extends StatelessWidget {
  final ThemeData theme;
  final bool isDone;

  const _PathLine({required this.theme, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 2,
      margin: const EdgeInsets.only(bottom: 26),
      color: isDone ? theme.colorScheme.primary : theme.dividerColor,
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String value;

  const _InfoCard({
    required this.theme,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surfaceContainerLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
