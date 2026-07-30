/// 学习记录 — 保存在 localStorage 中的历史记录条目
///
/// 映射自 `doc/models/scene.md → LearningRecord`。
class LearningRecord {
  final String time; // 保存时间（中文格式）
  final String? env; // 选择的环境 ID
  final String envLabel; // 环境中文名
  final String? runState; // 选择的运行状态 ID
  final String runStateLabel; // 运行状态中文名
  final bool finished; // 是否已完成课程

  const LearningRecord({
    required this.time,
    this.env,
    required this.envLabel,
    this.runState,
    required this.runStateLabel,
    required this.finished,
  });

  Map<String, dynamic> toJson() => {
        'time': time,
        'env': env,
        'envLabel': envLabel,
        'runState': runState,
        'runStateLabel': runStateLabel,
        'finished': finished,
      };

  factory LearningRecord.fromJson(Map<String, dynamic> json) => LearningRecord(
        time: json['time'] as String,
        env: json['env'] as String?,
        envLabel: json['envLabel'] as String,
        runState: json['runState'] as String?,
        runStateLabel: json['runStateLabel'] as String,
        finished: json['finished'] as bool,
      );

  static const maxHistoryLength = 20;
}
