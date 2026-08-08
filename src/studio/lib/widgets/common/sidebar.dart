import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/player_state.dart';
import '../cards/demo_card.dart';
import '../cards/knowledge_card.dart';
import '../cards/node_status_card.dart';
import '../cards/path_card.dart';

/// 侧边栏 — 学习路径、演示控制、互动节点、课程脉络
///
/// 路径 / 互动节点 / 脉络均来自课程数据（`CourseData.pathSteps` 等）。
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
              PathCard(state: state, onJumpToPath: onJumpToPath),
              const SizedBox(height: 14),
              DemoCard(state: state),
              const SizedBox(height: 14),
              NodeStatusCard(state: state),
              const SizedBox(height: 14),
              const KnowledgeCard(),
            ],
          ),
        );
      },
    );
  }
}
