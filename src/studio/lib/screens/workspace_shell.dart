import 'package:flutter/material.dart';

import 'course_screen.dart';
import 'crowd_screen.dart';
import 'home_screen.dart';
import 'learn_screen.dart';

/// 工作台外壳 — 侧边导航栏，严格按用户旅程排布：
/// 首页（既有 HomeScreen）→ 课程（设计和上架课程）→ 学习（管理班级、学习进度和评审学习作品）
/// → 众包（实践项目和任务）。
class WorkspaceShell extends StatefulWidget {
  const WorkspaceShell({super.key});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  int _index = 0;

  static const _labels = ['首页', '课程', '学习', '众包'];
  static const _icons = [Icons.home, Icons.menu_book, Icons.trending_up, Icons.groups];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pages = [
      const HomeScreen(),
      const CourseScreen(),
      const LearnScreen(),
      const CrowdScreen(),
    ];

    return Scaffold(
      body: Row(
        children: [
          // 侧边导航栏
          Container(
            width: 168,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: theme.dividerColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text(
                    '工作台',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                for (var i = 0; i < _labels.length; i++)
                  ListTile(
                    dense: true,
                    leading: Icon(_icons[i], size: 20),
                    title: Text(_labels[i]),
                    selected: _index == i,
                    onTap: () => setState(() => _index = i),
                  ),
              ],
            ),
          ),
          // 当前旅程屏
          Expanded(child: IndexedStack(index: _index, children: pages)),
        ],
      ),
    );
  }
}
