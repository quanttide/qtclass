import 'package:flutter/material.dart';
import '../../services/course_data.dart';
import '../../services/player_state.dart';

/// 顶栏 — 品牌、课程标题、返回按钮
///
/// 窄屏时显示侧边栏抽屉入口；窄屏隐藏次要标签。
class Topbar extends StatelessWidget {
  final PlayerState state;
  final VoidCallback onOpenSidebar;

  const Topbar({super.key, required this.state, required this.onOpenSidebar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 600;
    final isCompact = width < 1040; // 侧边栏收进抽屉时显示菜单入口

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isNarrow ? 14 : 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // 窄屏：侧边栏抽屉入口
          if (isCompact) ...[
            IconButton(
              icon: const Icon(Icons.menu),
              tooltip: '打开侧边栏',
              visualDensity: VisualDensity.compact,
              onPressed: onOpenSidebar,
            ),
            const SizedBox(width: 4),
          ],
          // 品牌
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.onSurface, width: 2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'QC',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 标题（窄屏收缩 + 省略号）
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '量潮课堂',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  CourseData.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // 次要标签（窄屏隐藏）
          if (!isNarrow) const SizedBox(width: 20),
          if (!isNarrow)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '互动影游式课程原型',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(width: 8),
          // 操作按钮
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('← 返回首页'),
          ),
        ],
      ),
    );
  }
}
