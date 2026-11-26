/// Learner（学员）— 管理层对象：lite 刻意不建学员面，学员的账记在 studio。
///
/// 数据契约沿三件套规矩：`id`(uuid) / `title`（学员展示名）/ `content`（备注载荷，
/// Markdown）孪生，关联字段另列——[cohort] 班级归属（取值对齐 lite 的课程名，
/// 如 AI编程）、[level] 参与度四级、[status] 在读与退出。
///
/// 参与度四级取自课堂讨论口径，分级跟课程内容无关，任何课都能照此给学员定位置。
/// 归位（v0.2.0）：lite 刻意不建的对象之一，见 ROADMAP「管理层新对象」。
class Learner {
  /// 学员 uuid。
  final String id;

  /// 学员展示名（真名或代称由运营定，见署名口径：先问本人意愿）。
  final String title;

  /// 备注载荷：Markdown 长文本。
  final String content;

  /// 班级归属，对齐 lite 的课程名（AI编程 / AI创意 / AI办公）。
  final String cohort;

  /// 参与度四级。
  final LearnerLevel level;

  /// 在读与退出。
  final LearnerStatus status;

  const Learner({
    required this.id,
    required this.title,
    this.content = '',
    required this.cohort,
    this.level = LearnerLevel.none,
    this.status = LearnerStatus.active,
  });

  /// 从 JSON 构造；[id] 必填，其余缺省回退（level → 没有参与，status → 在读）。
  factory Learner.fromJson(Map<String, dynamic> json) => Learner(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        cohort: json['cohort'] as String? ?? '',
        level: LearnerLevel.values.firstWhere(
          (e) => e.name == json['level'],
          orElse: () => LearnerLevel.none,
        ),
        status: LearnerStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => LearnerStatus.active,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'cohort': cohort,
        'level': level.name,
        'status': status.name,
      };
}

/// 参与度四级。
enum LearnerLevel {
  none('没有参与'),
  player('以玩家身份参与'),
  author('以作者身份产出'),
  mentor('以指导者身份帮助');

  const LearnerLevel(this.label);

  /// 中文标签（界面与账面共用）。
  final String label;
}

/// 在读与退出。
enum LearnerStatus {
  active('在读'),
  exited('退出');

  const LearnerStatus(this.label);

  /// 中文标签。
  final String label;
}
