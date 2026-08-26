import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/segment.dart';
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
/// 可选参数 [courseId]/[lessonId]/[lessonTitle]：从详情页课时点击进入时，
/// 加载该课时的播放数据（GET /courses/{courseId}/player）并定位到对应课时；
/// 不传时保持旧行为（全局 CourseData 单课数据）。
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    this.courseId,
    this.lessonId,
    this.lessonTitle,
    this.courseApiUrl,
    this.playerDataClient,
  });

  final String? courseId;
  final String? lessonId;
  final String? lessonTitle;
  final String? courseApiUrl;
  final http.Client? playerDataClient;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  /// 从 API 加载指定课程的播放数据并定位到课时（失败时保留全局数据，不阻塞播放器）。
  Future<void> _init() async {
    final courseId = widget.courseId;
    final lessonId = widget.lessonId;
    if (courseId == null || lessonId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final apiUrl =
          widget.courseApiUrl ??
          const String.fromEnvironment('QTCLASS_API_BASE_URL');
      if (apiUrl.isNotEmpty) {
        final baseUrl = apiUrl.replaceFirst(RegExp(r'/$'), '');
        final courseData = await CourseData.loadFromUrl(
          '$baseUrl/courses/$courseId/player',
          client: widget.playerDataClient,
        );
        if (courseData == null) return;
        final selectedSegment = _selectInitialSegment(courseData, lessonId);
        if (selectedSegment != null && mounted) {
          context.read<PlayerState>().setActiveSegment(selectedSegment.id);
        }
      }
    } catch (_) {
      // 播放数据加载失败：保留现有数据（v0.1 容错）
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Segment? _selectInitialSegment(CourseData courseData, String lessonId) {
    for (final seg in courseData.segmentMap.values) {
      if (seg.pathStepId == lessonId) return seg;
    }
    final lessonTitle = widget.lessonTitle;
    if (lessonTitle != null && lessonTitle.isNotEmpty) {
      for (final seg in courseData.segmentMap.values) {
        if (seg.title == lessonTitle) return seg;
      }
    }
    return courseData.segmentMap.isEmpty
        ? null
        : courseData.segmentMap.values.first;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
                            Expanded(
                              child: _MainColumn(
                                state: state,
                                lessonTitle: widget.lessonTitle,
                              ),
                            ),
                            SizedBox(
                              width: 318,
                              child: Sidebar(
                                onJumpToPath: () => _showConfirmDialog(context),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return _MainColumn(
                          state: state,
                          lessonTitle: widget.lessonTitle,
                        );
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
  final String? lessonTitle;

  const _MainColumn({required this.state, this.lessonTitle});

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
                      lessonTitle ?? '课时1 · 开发环境搭建',
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
