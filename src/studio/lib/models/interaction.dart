import 'choice_option.dart';

/// 互动节点 — 决策点配置（标题、说明、选项）
///
/// 映射自 `doc/models/scene.md → Interaction`。
class Interaction {
  final String title;
  final String desc;
  final List<ChoiceOption> options;

  const Interaction({
    required this.title,
    required this.desc,
    required this.options,
  });

  /// 从 JSON 构造（数据源：assets/course.json → interactions）
  factory Interaction.fromJson(Map<String, dynamic> json) => Interaction(
    title: json['title'] as String,
    desc: json['desc'] as String? ?? '',
    options: (json['options'] as List<dynamic>)
        .map((e) => ChoiceOption.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// 学习路径步骤 — 侧边栏"我的学习路径"条目
class PathStep {
  final String id;
  final String label;
  final String meta;
  final String segmentId; // 关联片段

  const PathStep({
    required this.id,
    required this.label,
    required this.meta,
    required this.segmentId,
  });

  /// 从 JSON 构造（数据源：assets/course.json → pathSteps）
  factory PathStep.fromJson(Map<String, dynamic> json) => PathStep(
    id: json['id'] as String,
    label: json['label'] as String,
    meta: json['meta'] as String,
    segmentId: json['segmentId'] as String,
  );
}

/// 互动节点状态条目 — 侧边栏"互动节点"卡片
class InteractionNode {
  final String index;
  final String label;
  final String interactionId;

  const InteractionNode({
    required this.index,
    required this.label,
    required this.interactionId,
  });

  /// 从 JSON 构造（数据源：assets/course.json → interactionNodes）
  factory InteractionNode.fromJson(Map<String, dynamic> json) =>
      InteractionNode(
        index: json['index'] as String,
        label: json['label'] as String,
        interactionId: json['interactionId'] as String,
      );
}
