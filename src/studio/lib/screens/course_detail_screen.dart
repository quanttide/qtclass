import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../services/learn_api.dart';
import '../services/learner_service.dart';
import '../services/progress_service.dart';
import '../widgets/course/course_hero.dart';
import '../widgets/course/module_panel.dart';
import '../widgets/course/step_bar.dart';
import 'player_screen.dart';
import 'proposal_screen.dart';

/// 课程详情页 — Hero + StepBar + 模块面板
///
/// 映射自 `doc/screens/course-detail.md`：
/// - 生产实习（view-front）：5 模块硬编码，模块 id m1-m5
/// - 通用课程（view-generic）：按 stages 动态渲染
/// 进度持久化 `qt-progress-<courseId>`；last 为空显示课程首页（Hero）。
class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Course? _course;
  int _currentModule = -1; // -1 = 课程首页（Hero）
  int _maxDone = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final course = CourseService.byId(widget.courseId);
    if (course == null) {
      setState(() => _loaded = true);
      return;
    }
    final progress = await ProgressService.load(widget.courseId);
    if (!mounted) return;
    setState(() {
      _course = course;
      _maxDone = progress.max.clamp(0, course.stages.length);
      // 有进度恢复上次模块，无进度显示课程首页
      _currentModule = progress.last != null
          ? _stageIndex(progress.last!)
          : -1;
      _loaded = true;
    });
  }

  int _stageIndex(String stageId) {
    final stages = _course?.stages ?? const <CourseStage>[];
    final i = stages.indexWhere((s) => s.id == stageId);
    return i < 0 ? -1 : i;
  }

  Future<void> _persist(int moduleIndex, {String? stageId}) async {
    final course = _course;
    if (course == null) return;
    final max = moduleIndex + 1 > _maxDone ? moduleIndex + 1 : _maxDone;
    await ProgressService.save(
      course.id,
      max: max,
      last: stageId ?? (moduleIndex >= 0 ? course.stages[moduleIndex].id : null),
    );
  }

  void _selectModule(int index) {
    setState(() {
      _currentModule = index;
      _maxDone = _maxDone > index ? _maxDone : index + 1;
    });
    _persist(index);
    _reportProgress(index);
  }

  /// 上报进度到学习云（MVP 闭环：后台学员表进度实时可见）。
  /// 本地失败静默（进度本地仍保存，服务端下次进入重试）。
  Future<void> _reportProgress(int moduleIndex) async {
    final course = _course;
    if (course == null || !course.isProd) return;
    try {
      final name = await LearnerService.name();
      await LearnApi().reportProgress(
        moduleId: course.stages[moduleIndex].id,
        name: name,
      );
    } catch (_) {
      // 服务端不可达时不打断学习流程
    }
  }

  void _backToHero() {
    setState(() => _currentModule = -1);
    _persist(-1, stageId: null);
  }

  void _continue() {
    // 有进度：进入 last 模块；无进度：进入第一模块
    _selectModule(_currentModule >= 0 ? _currentModule : 0);
  }

  void _openLesson(CourseLesson lesson) {
    // v0.1：播放器内容为现有 course.json（mock），课时数据切换待服务端
    // GET /courses/{id}/player 就绪后接入。
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlayerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final course = _course;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                children: [
                  Text(
                    '~ 量潮课堂',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    'v0.1.0',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            // 主内容区
            Expanded(
              child: !_loaded
                  ? const Center(child: CircularProgressIndicator())
                  : course == null
                  ? const Center(child: Text('未找到该课程'))
                  : _buildContent(theme, course),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, Course course) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 返回列表
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('返回课程列表'),
              ),
              const SizedBox(height: 16),
              // StepBar（课程首页隐藏）
              if (_currentModule >= 0) ...[
                StepBar(
                  labels: [for (final s in course.stages) s.name],
                  maxDone: _maxDone,
                  current: _currentModule,
                  onSelect: _selectModule,
                ),
                const SizedBox(height: 20),
              ],
              // Hero 或模块面板
              if (_currentModule < 0)
                CourseHero(
                  course: course,
                  progress: _maxDone / course.stages.length,
                  onContinue: _continue,
                  onTeam: course.isProd
                      ? () => _showTeamDialog(theme)
                      : null,
                )
              else
                ModulePanel(
                  stage: course.stages[_currentModule],
                  onNext: _currentModule < course.stages.length - 1
                      ? () => _selectModule(_currentModule + 1)
                      : _backToHero,
                  onBackToHero: _backToHero,
                  onLessonTap: _openLesson,
                  // 生产实习 m5：提交立项入口（MVP 核心动作）
                  footerAction: course.isProd &&
                          course.stages[_currentModule].id == 'm5'
                      ? FilledButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProposalScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.rocket_launch, size: 18),
                          label: const Text('提交立项'),
                        )
                      : null,
                ),
              const SizedBox(height: 16),
              if (_currentModule >= 0)
                TextButton(
                  onPressed: _backToHero,
                  child: const Text('← 返回课程首页'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTeamDialog(ThemeData theme) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('组队广场'),
        content: const Text('组队功能依赖学习云班级系统，v0.1 暂未开放。'),
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