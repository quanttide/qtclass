import 'package:flutter/material.dart';
import '../../services/course_data.dart';

/// 元信息行 — 适合人群、预计时间、选择节点、难度
///
/// 数据来自课程数据（`CourseData.segments` / `CourseData.interactionNodes`）。
/// 映射自 `doc/screens/home.md → 页面结构 · MetaRow`。
class MetaRow extends StatelessWidget {
  const MetaRow({super.key});

  /// 课程预计时长（视频片段总秒数换算分钟，向上取整）
  int _totalMinutes() {
    final totalSeconds = CourseData.segments.values
        .where((s) => s.video != null)
        .fold<double>(0, (sum, s) => sum + s.duration);
    return (totalSeconds / 60).ceil().clamp(1, 999);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const MetaItem(label: '适合人群', value: '开发者'),
        const SizedBox(width: 28),
        MetaItem(label: '预计时间', value: '约 ${_totalMinutes()} 分钟'),
        const SizedBox(width: 28),
        MetaItem(
          label: '选择节点',
          value: '${CourseData.interactionNodes.length} 个',
        ),
        const SizedBox(width: 28),
        const MetaItem(label: '难度', value: '入门'),
      ],
    );
  }
}

/// 元信息单项 — 标签 + 值
///
/// 映射自 `doc/screens/home.md → 组件清单 · MetaRow（子项 MetaItem）`。
class MetaItem extends StatelessWidget {
  final String label;
  final String value;

  const MetaItem({super.key, required this.label, required this.value});

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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
