/// Assignment（大作业 / 题目）— 创作空间的定义层。
///
/// 数据契约三字段（由用户定，2026-11-02）：
/// - [id]：uuid，后续步骤单元与参考答案按 id 配对
/// - [title]：大作业标题
/// - [content]：载荷，当前为 Markdown 长文本（任务书全文）；
///   未来拓展视频等格式时只在 content 上引入格式判别，[id] / [title] 不动
///
/// **独立实现（业务迭代期）**：toolkit 暂不引入本域模型——studio 这份随业务实际
/// 自由迭代，**稳定后固定到 `quanttide-tech-toolkit` 的 `dart/course`**，届时以 toolkit 为正本收敛。
///
/// 分层：studio 的 models 层（BLoC 架构）。映射自 roadmap `qtclass/product/studio.md → Assignment`。
class Assignment {
  /// 大作业 uuid。
  final String id;

  /// 标题。
  final String title;

  /// 载荷：当前为 Markdown 长文本。
  final String content;

  const Assignment({required this.id, required this.title, required this.content});

  /// 从 JSON 构造；[id] 必填，[title] / [content] 缺省回退空串。
  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'content': content};
}
