/// LearningRecord（学习记录）— 学员交上来的四要素记录。
///
/// 四要素（做了什么 / 遇到什么卡点 / 怎么解决 / 待完善点在哪）写进 [content]，
/// 不为要素发明字段——结构靠约定，筛选靠关联字段与时间。
/// 沿三件套规矩：`id`(uuid) / `title` / `content` 孪生；关联 [learnerId]（谁交的）、
/// [taskId]（交的哪个任务）；[submittedAt] 提交时间（epoch 毫秒）。
///
/// 归位（v0.2.0）：lite 刻意不建的对象之一，见 ROADMAP「管理层新对象」。
class LearningRecord {
  /// 记录 uuid。
  final String id;

  /// 标题，如「第 1 周学习记录」。
  final String title;

  /// 载荷：四要素写在正文里。
  final String content;

  /// 提交学员 id。
  final String learnerId;

  /// 关联任务 id（lite `task` 的标识）。
  final String taskId;

  /// 提交时间（epoch 毫秒），0 表示未记时间。
  final int submittedAt;

  const LearningRecord({
    required this.id,
    required this.title,
    this.content = '',
    required this.learnerId,
    required this.taskId,
    this.submittedAt = 0,
  });

  /// 从 JSON 构造；[id] / [learnerId] 必填，其余缺省回退。
  factory LearningRecord.fromJson(Map<String, dynamic> json) => LearningRecord(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        learnerId: json['learnerId'] as String? ?? '',
        taskId: json['taskId'] as String? ?? '',
        submittedAt: (json['submittedAt'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'learnerId': learnerId,
        'taskId': taskId,
        'submittedAt': submittedAt,
      };
}
