import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/choice_option.dart';
import '../models/segment.dart';

/// 课程业务数据 — 片段、选项的集合。
///
/// 数据源：`assets/course.json`（替换该文件即可替换课程内容）。
/// 加载方式：`CourseData.load()` 在应用启动时执行，解析结果赋值给 [current]。
/// 使用点通过静态代理（[segments]、[environmentOptions] 等）访问当前数据，
/// 因此替换数据不需要改动播放器逻辑。
class CourseData {
  final Map<String, Segment> _segments;
  final List<ChoiceOption> _environmentOptions;
  final List<ChoiceOption> _runStateOptions;

  const CourseData({
    required Map<String, Segment> segments,
    required List<ChoiceOption> environmentOptions,
    required List<ChoiceOption> runStateOptions,
  }) : _segments = segments,
       _environmentOptions = environmentOptions,
       _runStateOptions = runStateOptions;

  /// 当前生效的课程数据（默认内置，`load()` 成功后替换）
  static CourseData current = CourseData.defaults();

  /// 从 JSON 构造（数据源格式见 `assets/course.json`）
  factory CourseData.fromJson(Map<String, dynamic> json) {
    final segments = <String, Segment>{};
    (json['segments'] as Map<String, dynamic>).forEach((key, value) {
      segments[key] = Segment.fromJson(value as Map<String, dynamic>);
    });
    return CourseData(
      segments: segments,
      environmentOptions: (json['environmentOptions'] as List<dynamic>)
          .map((e) => ChoiceOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      runStateOptions: (json['runStateOptions'] as List<dynamic>)
          .map((e) => ChoiceOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 加载课程数据（默认 `assets/course.json`，可传自定义路径切换课程）。
  /// 加载成功后更新 [current]；失败时保留内置默认数据。
  static Future<CourseData> load({
    String assetPath = 'assets/course.json',
  }) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final parsed = CourseData.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      current = parsed;
      return parsed;
    } on Exception {
      return current;
    }
  }

  /// 内置默认数据（fallback / 测试默认，与 `assets/course.json` 一致）
  static CourseData defaults() => const CourseData(
    segments: {
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
    },
    environmentOptions: [
      ChoiceOption(
        id: 'windows',
        symbol: '▣',
        title: 'Windows 电脑',
        note: '使用 VS Code 与运行按钮完成第一次执行。',
      ),
      ChoiceOption(
        id: 'macos',
        symbol: '◉',
        title: 'Mac 电脑',
        note: '确认 Python 命令与终端运行方式。',
      ),
      ChoiceOption(
        id: 'linux',
        symbol: '◆',
        title: 'Linux 环境',
        note: '通过终端确认环境并运行 .py 文件。',
      ),
    ],
    runStateOptions: [
      ChoiceOption(
        id: 'success',
        symbol: '✓',
        title: '程序成功运行',
        note: '已经看到 Hello, Python! 输出。',
      ),
      ChoiceOption(
        id: 'error',
        symbol: '✕',
        title: '运行出现问题',
        note: '程序没有按照预期运行，需要进一步排查。',
      ),
      ChoiceOption(
        id: 'unknown',
        symbol: '？',
        title: '不确定下一步操作',
        note: '代码已经完成，但不知道如何执行。',
      ),
    ],
  );

  // ============================================================
  // 静态代理（使用点访问入口，指向 [current]）
  // ============================================================
  static Map<String, Segment> get segments => current._segments;
  static List<ChoiceOption> get environmentOptions =>
      current._environmentOptions;
  static List<ChoiceOption> get runStateOptions => current._runStateOptions;

  static String labelEnv(String? id) => current._labelEnv(id);
  static String labelRunState(String? id) => current._labelRunState(id);

  /// 环境选择选项的片段 ID 映射
  static String envToSegment(String envId) => envId; // windows → windows

  /// 运行状态选项的片段 ID 映射
  static String runStateToSegment(String runStateId) => 'run-$runStateId';

  // ============================================================
  // 实例方法
  // ============================================================
  String _labelEnv(String? id) {
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

  String _labelRunState(String? id) {
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
}
