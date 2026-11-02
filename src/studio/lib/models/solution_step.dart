/// SolutionStep（步骤单元）— Solution 的下级单元，一层不嵌套，
/// 单元之间用 [after] 边组成 DAG。
///
/// 数据契约：三字段与 [Assignment] / [Solution] 孪生 + 关系字段 [after]。
/// - [id]：uuid
/// - [title]：单元标题
/// - [content]：载荷，Markdown 长文本——**单元自足**：判断标准、检查点、
///   "老师为什么这么安排"都写在正文里，注解不设独立模型
/// - [after]：前置步骤 id 列表（空 = 入口）——DAG 的边
///
/// 结构的"深"由 after 链产生，不由层级产生；多入度（复盘要等两件事）是树的
/// parentId 给不了的。投影语义 = lite 的过门槛（完成前置解锁本步）。
/// 防环与勾选状态是 bloc / 运行时的活，不进设计态模型。
///
/// **独立实现（业务迭代期）**：toolkit 暂不引入本域模型——稳定后固定到
/// `quanttide-tech-toolkit` 的 `dart/course`，届时以 toolkit 为正本收敛。
///
/// 分层：studio 的 models 层（BLoC 架构）。映射自 roadmap `qtclass/product/studio.md → SolutionStep`。
class SolutionStep {
  /// 单元 uuid。
  final String id;

  /// 单元标题。
  final String title;

  /// 载荷：单元自足的 Markdown 正文。
  final String content;

  /// 前置步骤 id 列表；空列表为入口单元。
  final List<String> after;

  const SolutionStep({
    required this.id,
    required this.title,
    required this.content,
    this.after = const [],
  });

  /// 从 JSON 构造；[after] 缺省空列表。
  factory SolutionStep.fromJson(Map<String, dynamic> json) => SolutionStep(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        after: (json['after'] as List<dynamic>?)?.cast<String>() ?? const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        if (after.isNotEmpty) 'after': after,
      };
}
