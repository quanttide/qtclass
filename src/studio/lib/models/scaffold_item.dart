/// ScaffoldItem（脚手架）— 教学经验固化为可复用组件：前置思考题 / 常见坑点 / 反思触发器。
///
/// 示例反例位由 Solution 承接，本件只存脚手架本身。
/// 沿三件套规矩：`id`(uuid) / `title` / `content` 孪生 + [kind] 分类。
///
/// 归位（v0.2.0）：见 ROADMAP「v0.2.0 范围 · 脚手架库」。
class ScaffoldItem {
  /// 脚手架 uuid。
  final String id;

  /// 标题，如「对不上先查自己的抄法」。
  final String title;

  /// 载荷：组件正文，Markdown。
  final String content;

  /// 分类。
  final ScaffoldKind kind;

  const ScaffoldItem({
    required this.id,
    required this.title,
    this.content = '',
    required this.kind,
  });

  /// 从 JSON 构造；[id] 必填，其余缺省回退（kind → 常见坑点）。
  factory ScaffoldItem.fromJson(Map<String, dynamic> json) => ScaffoldItem(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        kind: ScaffoldKind.values.firstWhere(
          (e) => e.name == json['kind'],
          orElse: () => ScaffoldKind.pitfall,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'kind': kind.name,
      };
}

/// 脚手架三类。
enum ScaffoldKind {
  prompt('前置思考题'),
  pitfall('常见坑点'),
  reflection('反思触发器');

  const ScaffoldKind(this.label);

  /// 中文标签。
  final String label;
}
