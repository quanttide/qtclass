import 'package:flutter/material.dart';
import '../services/history_service.dart';
import 'player_screen.dart';

/// 课程首页
///
/// 映射自 `doc/screens/home.html`。
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _historyService = HistoryService();
  bool _hasProgress = false;

  @override
  void initState() {
    super.initState();
    _checkProgress();
  }

  Future<void> _checkProgress() async {
    final state = await _historyService.loadPlayerState();
    if (mounted) {
      setState(() {
        _hasProgress = state != null;
      });
    }
  }

  void _startLearning() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(resume: _hasProgress),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 顶栏导航
            _buildNavBar(theme),
            // 内容
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 课程标签
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Python 入门 · 互动课程',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 标题
                        Text(
                          'Python 基础：第一个 Python 程序',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '通过互动式课程体验，在关键节点做出选择，根据你的学习状态进入不同路径。借鉴互动影游中的剧情结构与剧情选择机制，让学习过程更加清晰可追踪。',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.65,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // 元信息行
                        Row(
                          children: [
                            _MetaItem(label: '适合人群', value: '零基础'),
                            const SizedBox(width: 28),
                            _MetaItem(label: '预计时间', value: '约 5 分钟'),
                            const SizedBox(width: 28),
                            _MetaItem(label: '选择节点', value: '2 个'),
                            const SizedBox(width: 28),
                            _MetaItem(label: '难度', value: '入门'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 方法标签
                        Text(
                          '互动节点 · 状态反馈 · 分支路径 · 学习追踪',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // 学习目标
                        Text(
                          '本节你将掌握',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _ObjectiveItem(text: '理解 Python 程序的基本运行流程'),
                        _ObjectiveItem(text: '完成第一个 print 程序'),
                        _ObjectiveItem(text: '学会处理常见的运行问题'),
                        const SizedBox(height: 36),
                        // 按钮
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _startLearning,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                            child: Text(
                              _hasProgress ? '继续学习' : '开始学习',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
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

  Widget _buildNavBar(ThemeData theme) {
    return Container(
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
          Text(
            '课程首页',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetaItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ObjectiveItem extends StatelessWidget {
  final String text;

  const _ObjectiveItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '✓',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
