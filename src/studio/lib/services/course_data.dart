import '../models/segment.dart';
import '../models/choice_option.dart';

/// 课程数据定义 — 所有片段、选项、场景的常量配置
///
/// 映射自 `doc/screens/player.md` 中的 segments 常量
/// 和 `doc/models/scene.md` 中的 ChoiceOption 表。
class CourseData {
  // ============================================================
  // 片段定义
  // ============================================================
  static final Map<String, Segment> segments = {
    'intro': Segment(
      id: 'intro',
      sceneKey: 'intro',
      duration: 14,
      caption: '学习过程不止一种路径。互动节点帮助识别你的当前状态，并提供对应学习内容。',
      chapter: '学习主线 · 开启 Python 学习任务',
      pathStepId: 'pathIntro',
    ),
    'windows': Segment(
      id: 'windows',
      sceneKey: 'environment',
      duration: 10,
      caption: 'Windows 运行环境：了解该环境下运行 Python 程序时需要注意的问题。',
      chapter: '分支内容 · Windows 运行环境',
      pathStepId: 'pathEnvironment',
    ),
    'macos': Segment(
      id: 'macos',
      sceneKey: 'environment',
      duration: 10,
      caption: 'macOS 运行环境：了解该环境下运行 Python 程序时需要注意的问题。',
      chapter: '分支内容 · macOS 运行环境',
      pathStepId: 'pathEnvironment',
    ),
    'linux': Segment(
      id: 'linux',
      sceneKey: 'environment',
      duration: 10,
      caption: 'Linux 运行环境：了解该环境下运行 Python 程序时需要注意的问题。',
      chapter: '分支内容 · Linux 运行环境',
      pathStepId: 'pathEnvironment',
    ),
    'first-program': Segment(
      id: 'first-program',
      sceneKey: 'first-program',
      duration: 12,
      caption: '输入代码并尝试运行：print("Hello, Python!")，根据实际结果选择下一步路径。',
      chapter: '学习主线 · 完成第一次代码运行',
      pathStepId: 'pathProgram',
    ),
    'run-success': Segment(
      id: 'run-success',
      sceneKey: 'run-state',
      duration: 8,
      caption: '程序成功运行！输出 Hello, Python!，环境配置正确，可以继续后续学习内容。',
      chapter: '分支内容 · 程序成功运行',
      pathStepId: 'pathRunState',
    ),
    'run-error': Segment(
      id: 'run-error',
      sceneKey: 'run-state',
      duration: 8,
      caption: '程序没有按照预期运行，常见原因包括缩进问题、语法错误或环境未就绪。',
      chapter: '分支内容 · 运行出现问题',
      pathStepId: 'pathRunState',
    ),
    'run-unknown': Segment(
      id: 'run-unknown',
      sceneKey: 'run-state',
      duration: 8,
      caption: '代码已经完成但不确定如何执行？我们从零开始指导你完成第一次运行。',
      chapter: '分支内容 · 不确定下一步操作',
      pathStepId: 'pathRunState',
    ),
  };

  // ============================================================
  // 互动选项
  // ============================================================
  static final List<ChoiceOption> environmentOptions = [
    const ChoiceOption(
      id: 'windows',
      symbol: '▣',
      title: 'Windows 电脑',
      note: '使用 VS Code 与运行按钮完成第一次执行。',
    ),
    const ChoiceOption(
      id: 'macos',
      symbol: '◉',
      title: 'Mac 电脑',
      note: '确认 Python 命令与终端运行方式。',
    ),
    const ChoiceOption(
      id: 'linux',
      symbol: '◆',
      title: 'Linux 环境',
      note: '通过终端确认环境并运行 .py 文件。',
    ),
  ];

  static final List<ChoiceOption> runStateOptions = [
    const ChoiceOption(
      id: 'success',
      symbol: '✓',
      title: '程序成功运行',
      note: '已经看到 Hello, Python! 输出。',
    ),
    const ChoiceOption(
      id: 'error',
      symbol: '✕',
      title: '运行出现问题',
      note: '程序没有按照预期运行，需要进一步排查。',
    ),
    const ChoiceOption(
      id: 'unknown',
      symbol: '？',
      title: '不确定下一步操作',
      note: '代码已经完成，但不知道如何执行。',
    ),
  ];

  // ============================================================
  // 工具方法
  // ============================================================
  static String labelEnv(String? id) {
    switch (id) {
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'linux':
        return 'Linux';
      default:
        return '未选择';
    }
  }

  static String labelRunState(String? id) {
    switch (id) {
      case 'success':
        return '程序成功运行';
      case 'error':
        return '运行出现问题';
      case 'unknown':
        return '不确定下一步操作';
      default:
        return '未选择';
    }
  }

  /// 环境选择选项的片段 ID 映射
  static String envToSegment(String envId) => envId; // windows → windows

  /// 运行状态选项的片段 ID 映射
  static String runStateToSegment(String runStateId) => 'run-$runStateId';
}
