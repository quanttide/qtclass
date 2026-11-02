/// Solution（参考答案）— 创作空间的答案层，与 [Assignment] 孪生同形。
///
/// 数据契约三字段：
/// - [id]：uuid
/// - [title]：参考答案标题
/// - [content]：载荷，Markdown 长文本——范文正文、正例反例对照、逐条讲解；
///   需要结构时用表格，不为它发明字段；未来拓展视频等格式只在 content 上引入判别
///
/// 定框：**参考答案 / 范例，不是标准答案**——把及格线具象化（老师自看、步骤单元引用），
/// 与「自由发挥 + 陌生人检验」的验收方式兼容；正例反例都在 content 里对照。
///
/// 可选：大作业可以还没有参考答案；一作业一答案档，归属由存储层组合，不设 assignmentId。
/// 实例素材是老师在创作空间的设计产出，无现成来源。
///
/// **独立实现（业务迭代期）**：toolkit 暂不引入本域模型——稳定后固定到
/// `quanttide-tech-toolkit` 的 `dart/course`，届时以 toolkit 为正本收敛。
///
/// 分层：studio 的 models 层（BLoC 架构）。映射自 roadmap `qtclass/product/studio.md → Solution`。
class Solution {
  /// 参考答案 uuid。
  final String id;

  /// 标题。
  final String title;

  /// 载荷：参考交付正文（Markdown）。
  final String content;

  const Solution({required this.id, required this.title, required this.content});

  /// 从 JSON 构造；[id] 必填，[title] / [content] 缺省回退空串。
  factory Solution.fromJson(Map<String, dynamic> json) => Solution(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'content': content};
}
