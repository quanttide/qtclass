/// 互动选项 — 互动节点中的可选卡片
///
/// 映射自 `doc/models/scene.md → ChoiceOption`。
class ChoiceOption {
  final String id;
  final String symbol; // 卡片左上角符号（如 ✓, ✕, ▣）
  final String title;
  final String note; // 辅助说明
  final String feedback; // 选中后即时反馈文案

  const ChoiceOption({
    required this.id,
    required this.symbol,
    required this.title,
    required this.note,
    this.feedback = '',
  });

  /// 从 JSON 构造（数据源：assets/course.json）
  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
    id: json['id'] as String,
    symbol: json['symbol'] as String,
    title: json['title'] as String,
    note: json['note'] as String,
    feedback: json['feedback'] as String? ?? '',
  );
}
