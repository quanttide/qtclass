/// 播放片段 — 播放器的最小播放单元
///
/// 每个片段有固定时长，播放结束时触发下一跳逻辑。
/// 映射自 `doc/models/scene.md → Segment`。
class Segment {
  final String id;
  final String sceneKey; // data-scene 渲染标识
  final double duration; // 播放时长（秒）
  final String caption; // 底部字幕文案
  final String chapter; // 章节标签
  final String pathStepId; // 关联侧边栏路径步骤 ID

  const Segment({
    required this.id,
    required this.sceneKey,
    required this.duration,
    required this.caption,
    required this.chapter,
    required this.pathStepId,
  });

  /// 片段类型
  SegmentType get type {
    if (id == 'intro' || id == 'first-program') return SegmentType.mainLine;
    return SegmentType.branch;
  }
}

enum SegmentType { mainLine, branch }
