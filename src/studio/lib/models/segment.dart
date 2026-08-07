/// 播放片段 — 播放器的最小播放单元
///
/// 每个片段有固定时长，播放结束时根据流程字段跳转：
/// - [next]：自然结束后的下一个片段
/// - [interaction]：结束后弹出的互动节点 id（见 `CourseData.interactions`）
/// - [action]：结束动作（如 'finish' 表示完成课程）
/// 映射自 `doc/models/scene.md → Segment`。
class Segment {
  final String id;
  final String sceneKey; // data-scene 渲染标识
  final double duration; // 播放时长（秒）
  final String title; // 场景标题
  final String caption; // 底部字幕文案
  final String chapter; // 章节标签
  final String pathStepId; // 关联侧边栏路径步骤 ID
  final String? next; // 结束后的下一片段 ID
  final String? interaction; // 结束后弹出的互动节点 ID
  final String? action; // 结束动作：'finish'

  const Segment({
    required this.id,
    required this.sceneKey,
    required this.duration,
    required this.title,
    required this.caption,
    required this.chapter,
    required this.pathStepId,
    this.next,
    this.interaction,
    this.action,
  });

  /// 从 JSON 构造（数据源：assets/course.json）
  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
    id: json['id'] as String,
    sceneKey: json['sceneKey'] as String,
    duration: (json['duration'] as num).toDouble(),
    title: json['title'] as String? ?? '',
    caption: json['caption'] as String,
    chapter: json['chapter'] as String,
    pathStepId: json['pathStepId'] as String,
    next: json['next'] as String?,
    interaction: json['interaction'] as String?,
    action: json['action'] as String?,
  );

  /// 片段类型
  SegmentType get type {
    if (id == 'intro' || id == 'first-program') return SegmentType.mainLine;
    return SegmentType.branch;
  }
}

enum SegmentType { mainLine, branch }
