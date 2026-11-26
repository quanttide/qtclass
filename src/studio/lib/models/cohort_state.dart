/// 班级状态动作 — cohort 是 lite 正本（`lite/data/cohorts.ts`），studio 是它的编辑面。
///
/// 三态与字段对齐 lite：招生中 → 进行中 → 已结课，**只进不退、逐级迁移**；
/// 开班日期 / 限额 / 报名窗口 / 报名条件为可编辑字段，无事实留空、不编。
/// 回灌通道留 [CohortSink] 接口缝——正本在仓内文件，studio 出变更；
/// v0.2.0 只定义缝，不实现 git 写回。
///
/// 归位（v0.2.0）：状态与动作挂在 lite 对象上，不另立对象目录，见 ROADMAP「班级状态动作」。
class CohortState {
  /// 对齐 lite cohorts 的 id，如 `ai-programming-1`。
  final String id;

  /// 课程名（对齐 lite 的 course 字段）。
  final String course;

  /// 期名，如「首期」。
  final String name;

  /// 当前状态。
  final CohortPhase phase;

  /// 开班日期，如「11 月 25 日」；无事实为 null。
  final String? start;

  /// 限额，如「免费 3~5 名」；无事实为 null。
  final String? quota;

  /// 报名窗口，如「免费班 11 月 23 日起开放」；无事实为 null。
  final String? window;

  /// 报名条件（交成品口径）；无事实为 null。
  final String? apply;

  const CohortState({
    required this.id,
    required this.course,
    required this.name,
    required this.phase,
    this.start,
    this.quota,
    this.window,
    this.apply,
  });

  /// 相邻向前迁移合法吗：招生中→进行中→已结课；回退与跳级都不允许。
  bool canTransitionTo(CohortPhase to) {
    const order = [CohortPhase.recruiting, CohortPhase.running, CohortPhase.closed];
    return order.indexOf(to) == order.indexOf(phase) + 1;
  }

  /// 执行迁移；非法返回 null（调用方据此提示，不抛异常）。
  CohortState? transitionTo(CohortPhase to) => canTransitionTo(to)
      ? CohortState(
          id: id,
          course: course,
          name: name,
          phase: to,
          start: start,
          quota: quota,
          window: window,
          apply: apply,
        )
      : null;

  /// 从 JSON 构造；无事实字段缺省 null。
  factory CohortState.fromJson(Map<String, dynamic> json) => CohortState(
        id: json['id'] as String,
        course: json['course'] as String? ?? '',
        name: json['name'] as String? ?? '',
        phase: CohortPhase.values.firstWhere(
          (e) => e.name == json['phase'],
          orElse: () => CohortPhase.recruiting,
        ),
        start: json['start'] as String?,
        quota: json['quota'] as String?,
        window: json['window'] as String?,
        apply: json['apply'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'course': course,
        'name': name,
        'phase': phase.name,
        if (start != null) 'start': start,
        if (quota != null) 'quota': quota,
        if (window != null) 'window': window,
        if (apply != null) 'apply': apply,
      };
}

/// 班级三态（标签与 lite 的 COHORT_STATUS_LABEL 一致）。
enum CohortPhase {
  recruiting('招生中'),
  running('进行中'),
  closed('已结课');

  const CohortPhase(this.label);

  /// 中文标签。
  final String label;
}

/// 回灌通道缝：正本在仓内文件，studio 出变更；v0.2.0 不实现 git 写回。
abstract class CohortSink {
  /// 把编辑后的班级状态写回正本。
  Future<void> writeBack(CohortState state);
}
