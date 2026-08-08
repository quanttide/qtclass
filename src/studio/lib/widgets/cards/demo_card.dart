import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/player_state.dart';

/// 演示控制卡片 — 跳转下一节点 / 重置全部状态
///
/// 映射自 `doc/screens/player.md → 侧边栏 · 演示控制`。
class DemoCard extends StatelessWidget {
  final PlayerState state;

  const DemoCard({super.key, required this.state});

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
