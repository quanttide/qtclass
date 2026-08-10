import 'package:flutter/material.dart';
import '../../services/course_data.dart';
import 'course_subtitle.dart';
import 'course_tag.dart';
import 'course_title.dart';
import 'meta_row.dart';
import 'method_label.dart';
import 'objectives_list.dart';
import 'start_button.dart';

/// 首页内容容器 — 垂直居中滚动布局，包裹课程信息全部内容
///
/// 内容区 max-width: 680px；课程数据来自 `CourseData`。
/// 映射自 `doc/screens/home.md → 页面结构 · HomeContent`。
class HomeContent extends StatelessWidget {
  final VoidCallback onStart;

  const HomeContent({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 课程标签
              const CourseTag(label: '氛围编程 · Vibe Coding'),
              const SizedBox(height: 16),
              // 标题
              CourseTitle(text: CourseData.title),
              const SizedBox(height: 12),
              // 副标题
              CourseSubtitle(text: CourseData.description),
              const SizedBox(height: 28),
              // 元信息行
              const MetaRow(),
              const SizedBox(height: 16),
              // 方法标签
              const MethodLabel(text: '互动节点 · 状态反馈 · 分支路径 · 视频演示'),
              const SizedBox(height: 28),
              // 学习目标
              const ObjectivesList(),
              const SizedBox(height: 36),
              // 开始按钮
              StartButton(onPressed: onStart),
            ],
          ),
        ),
      ),
    );
  }
}
