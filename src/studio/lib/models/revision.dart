/// Revision（任务书修订）— 修订回环（任务书生产线）的骨架对象。
///
/// 流：draft（待预筛）→ prefilered（已预筛）→ merged（已合稿回灌仓内任务书）。
/// AI 预筛 diff 走 [DiffPreFilter] 接口缝——v0.2.0 只立骨架与缝，不接真实实现；
/// 合稿回灌同样只留缝（正本在仓内文件）。
/// 沿三件套规矩：`id`(uuid) / `title` / `content`（修订说明）孪生；
/// 关联 [taskId]（改哪份任务书）、[before] / [after]（修订前后全文）。
///
/// 归位（v0.2.0）：见 ROADMAP「v0.2.0 范围 · 修订回环」。
class Revision {
  /// 修订 uuid。
  final String id;

  /// 关联任务 id（lite `task` 的标识）。
  final String taskId;

  /// 标题，如「游戏任务书第 3 步补验收句」。
  final String title;

  /// 修订说明，Markdown。
  final String content;

  /// 修订前全文。
  final String before;

  /// 修订后全文（合稿稿）。
  final String after;

  /// 状态。
  final RevisionStatus status;

  const Revision({
    required this.id,
    required this.taskId,
    required this.title,
    this.content = '',
    this.before = '',
    this.after = '',
    this.status = RevisionStatus.draft,
  });

  /// 状态迁移（只进不退）；非法返回 null。
  Revision? transitionTo(RevisionStatus to) {
    const order = [
      RevisionStatus.draft,
      RevisionStatus.prefilered,
      RevisionStatus.merged,
    ];
    if (order.indexOf(to) != order.indexOf(status) + 1) return null;
    return Revision(
      id: id,
      taskId: taskId,
      title: title,
      content: content,
      before: before,
      after: after,
      status: to,
    );
  }

  /// 从 JSON 构造；[id] / [taskId] 必填，其余缺省回退。
  factory Revision.fromJson(Map<String, dynamic> json) => Revision(
        id: json['id'] as String,
        taskId: json['taskId'] as String? ?? '',
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        before: json['before'] as String? ?? '',
        after: json['after'] as String? ?? '',
        status: RevisionStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => RevisionStatus.draft,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskId': taskId,
        'title': title,
        'content': content,
        'before': before,
        'after': after,
        'status': status.name,
      };
}

/// 修订三态。
enum RevisionStatus {
  draft('待预筛'),
  prefilered('已预筛'),
  merged('已合稿');

  const RevisionStatus(this.label);

  /// 中文标签。
  final String label;
}

/// AI 预筛 diff 的接口缝——返回预筛后的修订说明；v0.2.0 不接真实 AI。
abstract class DiffPreFilter {
  /// 对修订做预筛，返回预筛意见（写回修订说明）。
  Future<String> prefilter(Revision revision);
}
