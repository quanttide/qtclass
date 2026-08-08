import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/course_data.dart';
import '../services/player_state.dart';
import '../widgets/common/sidebar.dart';
import '../widgets/common/topbar.dart';
import '../widgets/stage/player_controls.dart';
import '../widgets/stage/player_stage.dart';

/// 互动式课程播放器
///
/// 页面骨架：顶栏 + 主列（标题区 + 播放舞台 + 控制栏）+ 侧边栏。
/// 映射自 `doc/screens/player.html` — 核心交互界面。
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 1040;

    return Scaffold(
      key: _scaffoldKey,
      // 窄屏：侧边栏收进抽屉（手机/平板竖屏），播放器占满整列
      drawer: isWide
          ? null
          : Drawer(
              child: SafeArea(
                child: Sidebar(onJumpToPath: () => _showConfirmDialog(context)),
              ),
            ),
      body: SafeArea(
        child: Consumer<PlayerState>(
          builder: (context, state, _) {
            return Column(
              children: [
                // 顶栏
                Topbar(
                  state: state,
                  onOpenSidebar: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                // 工作区
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _MainColumn(state: state)),
                            SizedBox(
                              width: 318,
                              child: Sidebar(
                                onJumpToPath: () => _showConfirmDialog(context),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return _MainColumn(state: state);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    final state = context.read<PlayerState>();
    if (state.visited.length > 1) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('跳转路径'),
          content: const Text('返回之前的步骤可能影响当前进度。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('知道了'),
            ),
          ],
        ),
      );
    }
  }
}

// ============================================================
// 主列 — 课程标题区 + 播放舞台 + 控制栏
// ============================================================
class _MainColumn extends StatelessWidget {
  final PlayerState state;

  const _MainColumn({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 课程标题
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '课时1 · 开发环境搭建',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CourseData.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CourseData.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              // 状态标签
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      state.finished
                          ? '学习任务完成'
                          : state.playing
                          ? '正在播放'
                          : state.interactionId != null
                          ? '等待选择'
                          : '等待播放',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 播放器
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
            child: Column(
              children: [
                // 播放舞台
                Expanded(child: PlayerStage(state: state)),
                const SizedBox(height: 0),
                // 控制栏
                const PlayerControls(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
