/// Review（评审结论）— 三分去向的记账：录取实训基地 / 留作免费学员 / 退出班级。
///
/// 淘汰与分流是记账，不是赛事界面——赛事与通知学员的交互归 lite，本件只落结论。
/// 沿三件套规矩：`id`(uuid) / `title` / `content`（评审依据说明）孪生；关联
/// [learnerId]、[cohort]、[recordId]（依据的学习记录）、[decidedAt]（epoch 毫秒）。
///
/// 归位（v0.2.0）：lite 刻意不建的对象之一，见 ROADMAP「管理层新对象」。
class Review {
  /// 结论 uuid。
  final String id;

  /// 标题，如「首期一周考核」。
  final String title;

  /// 载荷：依据说明，Markdown。
  final String content;

  /// 被评审学员 id。
  final String learnerId;

  /// 所属班级（对齐 lite 的课程名）。
  final String cohort;

  /// 三分去向。
  final ReviewVerdict verdict;

  /// 作为依据的学习记录 id（可空：先有结论后补记录的过渡期）。
  final String? recordId;

  /// 决定时间（epoch 毫秒），0 表示未记时间。
  final int decidedAt;

  const Review({
    required this.id,
    required this.title,
    this.content = '',
    required this.learnerId,
    required this.cohort,
    required this.verdict,
    this.recordId,
    this.decidedAt = 0,
  });

  /// 从 JSON 构造；[id] / [learnerId] / [verdict] 必填，其余缺省回退。
  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        learnerId: json['learnerId'] as String? ?? '',
        cohort: json['cohort'] as String? ?? '',
        verdict: ReviewVerdict.values.firstWhere(
          (e) => e.name == json['verdict'],
          orElse: () => ReviewVerdict.retained,
        ),
        recordId: json['recordId'] as String?,
        decidedAt: (json['decidedAt'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'learnerId': learnerId,
        'cohort': cohort,
        'verdict': verdict.name,
        if (recordId != null) 'recordId': recordId,
        'decidedAt': decidedAt,
      };
}

/// 三分去向。
enum ReviewVerdict {
  admitted('录取实训基地'),
  retained('留作免费学员'),
  exited('退出班级');

  const ReviewVerdict(this.label);

  /// 中文标签（公告口径原话）。
  final String label;
}
