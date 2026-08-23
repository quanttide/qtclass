import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../widgets/course/course_card.dart';
import 'course_detail_screen.dart';

/// 课程列表页 — 系统默认入口，五门课程的阶梯式导航
///
/// 映射自 `doc/screens/course-list.md`：
/// AppBar（品牌 + 版本 + 头像）+ 页面标题区 + 课程卡片网格。
/// 点击课程卡片跳转课程详情页。
class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courses = CourseService.all;

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
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'v0.1.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 头像圆（qtcloud-learn 登录态占位）
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.15,
                    ),
                    child: Text(
                      'Z',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 内容区
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 48,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      children: [
                        // 页面标题
                        Text(
                          '量潮课堂 · 实训基地',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '从基础到实战，五门课程形成一条完整的成长阶梯',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 课程卡片网格
                        for (final (i, course) in courses.indexed) ...[
                          if (i > 0) const SizedBox(height: 12),
                          _CourseCardLink(course: course, number: i + 1),
                        ],
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
}

class _CourseCardLink extends StatelessWidget {
  final Course course;
  final int number;

  const _CourseCardLink({required this.course, required this.number});

  @override
  Widget build(BuildContext context) {
    return CourseCard(
      course: course,
      number: number,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CourseDetailScreen(courseId: course.id),
        ),
      ),
    );
  }
}
