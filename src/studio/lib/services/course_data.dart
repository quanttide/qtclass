import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/interaction.dart';
import '../models/segment.dart';

/// 课程业务数据 — 片段、互动节点、学习路径的集合。
///
/// 数据源：`assets/course.json`（替换该文件即可替换课程内容）。
/// 加载方式：`CourseData.load()` 在应用启动时执行，解析结果赋值给 [current]。
/// 使用点通过静态代理（[segments]、[interactions] 等）访问当前数据，
/// 因此替换数据不需要改动播放器逻辑。
class CourseData {
  final String _title;
  final String _description;
  final List<String> _objectives;
  final Map<String, Segment> _segments;
  final Map<String, Interaction> _interactions;
  final List<PathStep> _pathSteps;
  final List<InteractionNode> _interactionNodes;

  const CourseData({
    String title = '',
    String description = '',
    List<String> objectives = const [],
    required Map<String, Segment> segments,
    required Map<String, Interaction> interactions,
    required List<PathStep> pathSteps,
    required List<InteractionNode> interactionNodes,
  }) : _title = title,
       _description = description,
       _objectives = objectives,
       _segments = segments,
       _interactions = interactions,
       _pathSteps = pathSteps,
       _interactionNodes = interactionNodes;

  /// 当前生效的课程数据（默认内置，`load()` 成功后替换）
  static CourseData current = CourseData.fromJson(defaultJson);

  /// 从 JSON 构造（数据源格式见 `assets/course.json`）
  factory CourseData.fromJson(Map<String, dynamic> json) {
    final segments = <String, Segment>{};
    (json['segments'] as Map<String, dynamic>).forEach((key, value) {
      segments[key] = Segment.fromJson(value as Map<String, dynamic>);
    });
    final interactions = <String, Interaction>{};
    (json['interactions'] as Map<String, dynamic>? ?? {}).forEach((key, value) {
      interactions[key] = Interaction.fromJson(value as Map<String, dynamic>);
    });
    return CourseData(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      objectives: (json['objectives'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      segments: segments,
      interactions: interactions,
      pathSteps: (json['pathSteps'] as List<dynamic>? ?? [])
          .map((e) => PathStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      interactionNodes: (json['interactionNodes'] as List<dynamic>? ?? [])
          .map((e) => InteractionNode.fromJson(e as Map<String, dynamic>))
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

  // ============================================================
  // 静态代理（使用点访问入口，指向 [current]）
  // ============================================================
  static Map<String, Segment> get segments => current._segments;
  static Map<String, Interaction> get interactions => current._interactions;
  static List<PathStep> get pathSteps => current._pathSteps;
  static List<InteractionNode> get interactionNodes =>
      current._interactionNodes;
  static String get title => current._title;
  static String get description => current._description;
  static List<String> get objectives => current._objectives;

  /// 内置默认数据（fallback / 测试默认，与 `assets/course.json` 一致）
  static Map<String, dynamic> get defaultJson => {
    'title': '氛围编程 — 课时1：开发环境搭建',
    'description':
        '完成 Zed 编辑器的下载安装与基础配置，注册 DeepSeek 账号并获取 API 密钥，最后在 Zed 的 Assistant 面板中填入密钥并验证连接。',
    'objectives': [
      '完成 Zed 编辑器的下载、安装与基础配置',
      '注册 DeepSeek 账号并获取 API 密钥',
      '在 Zed Assistant 中接入 DeepSeek 并验证连接可用',
    ],
    'segments': {
      'intro': {
        'id': 'intro',
        'sceneKey': 'intro',
        'duration': 14,
        'title': '你的学习路径，将由你的选择展开。',
        'caption':
            '氛围编程（Vibe Coding）课时1：开发环境搭建。不同学习者的设备与卡点各不相同，互动节点将帮助你识别当前状态，提供对应的解决路径。',
        'chapter': '课时1 · 开发环境搭建',
        'pathStepId': 'pathIntro',
        'next': 'install-zed',
      },
      'install-zed': {
        'id': 'install-zed',
        'sceneKey': 'main',
        'duration': 136.6,
        'title': '下载安装 Zed 编辑器',
        'caption':
            '从 Zed 官网（zed.dev）下载对应操作系统的安装包（Windows 的 .exe / macOS 的 .dmg），双击运行完成安装。安装完成后启动 Zed。',
        'chapter': '主线 · 安装 Zed',
        'pathStepId': 'pathInstall',
        'video': 'assets/videos/lesson1-sence1.mp4',
        'interaction': 'install-check',
      },
      'e1-site-down': {
        'id': 'e1-site-down',
        'sceneKey': 'error',
        'duration': 16,
        'title': 'Zed 官网无法访问',
        'caption':
            '先确认本地网络正常并刷新页面；若仍无法访问，等待 10-15 分钟重试，或开启代理 / 使用镜像源。官网持续不可用时，改用包管理器安装：macOS 运行 brew install --cask zed，Windows 运行 winget install zed。安装后运行 zed --version 验证。',
        'chapter': '分支 · 官网无法访问',
        'pathStepId': 'pathInstall',
        'next': 'getting-api-key',
      },
      'getting-api-key': {
        'id': 'getting-api-key',
        'sceneKey': 'main',
        'duration': 48.5,
        'title': '获取 DeepSeek API 密钥',
        'caption':
            '注册 DeepSeek 账号（deepseek.com），登录后进入「API 管理」创建新密钥，复制保存。注意：密钥只在创建时可见，需立即妥善保存。',
        'chapter': '主线 · 获取 API 密钥',
        'pathStepId': 'pathApiKey',
        'video': 'assets/videos/lesson1-sence2.mp4',
        'interaction': 'api-check',
      },
      'e1-auth-failure': {
        'id': 'e1-auth-failure',
        'sceneKey': 'error',
        'duration': 16,
        'title': '认证失败',
        'caption':
            '若返回「Invalid API Key」，回到 DeepSeek 官网重新生成密钥并更新；若网络超时，检查防火墙或代理设置；若提示 Rate Limit Exceeded，请稍后再试或升级套餐。',
        'chapter': '分支 · 认证失败',
        'pathStepId': 'pathApiKey',
        'next': 'configure-zed',
      },
      'configure-zed': {
        'id': 'configure-zed',
        'sceneKey': 'main',
        'duration': 22.7,
        'title': '配置 Zed Assistant',
        'caption':
            '打开 Zed，通过 Ctrl+Shift+A 打开 Assistant 面板，在「API Key」输入框粘贴 DeepSeek 密钥并点击 Apply 保存。若找不到面板，确认 Zed 版本 ≥ 0.10.0。',
        'chapter': '主线 · 配置 Zed',
        'pathStepId': 'pathConfigure',
        'video': 'assets/videos/lesson1-sence3.mp4',
        'interaction': 'config-check',
      },
      'e1-old-version': {
        'id': 'e1-old-version',
        'sceneKey': 'error',
        'duration': 14,
        'title': 'Zed 版本过旧',
        'caption':
            '旧版本可能不支持 Assistant 面板或部分功能。请升级 Zed 到最新版本（菜单「Check for Updates」或从官网重新下载），升级后重新打开 Assistant 面板。',
        'chapter': '分支 · 版本过旧',
        'pathStepId': 'pathConfigure',
        'next': 'configure-zed',
      },
      'verify': {
        'id': 'verify',
        'sceneKey': 'success',
        'duration': 12,
        'title': '验证连接可用',
        'caption':
            '在 Assistant 面板点击「Test Connection」，返回 Connected Successfully 即配置正确。至此，课时1 开发环境搭建完成，可以开始后续的编程实战。',
        'chapter': '主线 · 验证连接',
        'pathStepId': 'pathVerify',
        'action': 'finish',
      },
    },
    'interactions': {
      'install-check': {
        'title': 'Zed 安装是否顺利？',
        'desc': '根据你遇到的情况选择，系统会给出对应的处理路径。',
        'options': [
          {
            'id': 'ok',
            'symbol': '✓',
            'title': '安装成功',
            'note': 'Zed 已安装并成功启动',
            'feedback': '很好！接下来注册 DeepSeek 账号并获取 API 密钥。',
            'next': 'getting-api-key',
          },
          {
            'id': 'site-down',
            'symbol': '⚠',
            'title': '官网无法访问',
            'note': 'E1：下载页面打不开',
            'feedback': '按官网无法访问的排查步骤处理。',
            'next': 'e1-site-down',
          },
          {
            'id': 'install-error',
            'symbol': '✕',
            'title': '安装过程报错',
            'note': '下载中断或安装失败',
            'feedback': '检查网络后重新下载；权限不足时以管理员身份运行安装程序。',
            'next': 'e1-site-down',
          },
        ],
      },
      'api-check': {
        'title': '密钥获取是否顺利？',
        'desc': '选择你当前的情况，继续对应的路径。',
        'options': [
          {
            'id': 'ok',
            'symbol': '✓',
            'title': '已拿到密钥',
            'note': '已复制保存 API 密钥',
            'feedback': '接下来在 Zed 的 Assistant 面板中填入密钥。',
            'next': 'configure-zed',
          },
          {
            'id': 'auth-failure',
            'symbol': '✕',
            'title': '注册或生成失败',
            'note': 'E1：邮箱已注册 / 密钥上限',
            'feedback': '找回密码或删除旧密钥后重新生成。',
            'next': 'e1-auth-failure',
          },
        ],
      },
      'config-check': {
        'title': '配置是否完成？',
        'desc': '选择你当前的情况，继续对应的路径。',
        'options': [
          {
            'id': 'ok',
            'symbol': '✓',
            'title': '已填入密钥',
            'note': 'Apply 保存成功',
            'feedback': '最后验证连接是否可用。',
            'next': 'verify',
          },
          {
            'id': 'auth-failure',
            'symbol': '✕',
            'title': '提示 Invalid API Key',
            'note': 'E1：认证失败',
            'feedback': '重新生成密钥并更新。',
            'next': 'e1-auth-failure',
          },
          {
            'id': 'old-version',
            'symbol': '⚠',
            'title': '找不到 Assistant 面板',
            'note': 'E1：Zed 版本过旧',
            'feedback': '升级 Zed 到最新版本后重试。',
            'next': 'e1-old-version',
          },
        ],
      },
    },
    'pathSteps': [
      {
        'id': 'pathIntro',
        'label': '开启课时',
        'meta': '课时1 · 开发环境搭建',
        'segmentId': 'intro',
      },
      {
        'id': 'pathInstall',
        'label': '安装 Zed 编辑器',
        'meta': '下载安装并启动',
        'segmentId': 'install-zed',
      },
      {
        'id': 'pathApiKey',
        'label': '获取 API 密钥',
        'meta': '注册 DeepSeek 账号',
        'segmentId': 'getting-api-key',
      },
      {
        'id': 'pathConfigure',
        'label': '配置 Zed Assistant',
        'meta': '填入密钥并保存',
        'segmentId': 'configure-zed',
      },
      {
        'id': 'pathVerify',
        'label': '验证连接可用',
        'meta': '课时完成',
        'segmentId': 'verify',
      },
    ],
    'interactionNodes': [
      {'index': '01', 'label': '安装检查', 'interactionId': 'install-check'},
      {'index': '02', 'label': '密钥检查', 'interactionId': 'api-check'},
      {'index': '03', 'label': '配置检查', 'interactionId': 'config-check'},
    ],
  };
}
