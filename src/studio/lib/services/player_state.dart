import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/segment.dart';
import 'course_data.dart';

/// 播放器状态机 — 驱动所有 UI 变化
///
/// 流程完全由课程数据驱动（`assets/course.json`）：
/// 片段结束 → 读 `Segment.interaction`（弹互动）→ 读 `Segment.next`（跳转）→ 读 `Segment.action`（完成）。
/// 映射自 `doc/models/scene.md → State` 对象。
class PlayerState extends ChangeNotifier {
  // ============================================================
  // 核心状态
  // ============================================================
  String _currentSegmentId = 'intro';
  double _elapsed = 0;
  bool _playing = false;
  Timer? _timer;
  double _playbackRate = 1;
  bool _endHandled = false;

  // 互动状态
  String? _interactionId;
  String? _selectedChoice;
  bool _finished = false;
  final List<String> _triedChoices = [];

  // 已访问片段（侧边栏路径完成状态）
  final Set<String> _visited = {'intro'};

  // ============================================================
  // Getters
  // ============================================================
  String get currentSegmentId => _currentSegmentId;
  double get elapsed => _elapsed;
  bool get playing => _playing;
  double get playbackRate => _playbackRate;
  bool get endHandled => _endHandled;

  String? get interactionId => _interactionId;
  String? get selectedChoice => _selectedChoice;
  bool get finished => _finished;
  List<String> get triedChoices => List.unmodifiable(_triedChoices);
  Set<String> get visited => Set.unmodifiable(_visited);

  Segment? get currentSegment => CourseData.segments[_currentSegmentId];

  /// 当前片段剩余秒数
  double get remaining {
    final seg = currentSegment;
    if (seg == null) return 0;
    return (seg.duration - _elapsed).clamp(0, seg.duration);
  }

  /// 当前播放进度（0.0 ~ 1.0）
  double get progress {
    final seg = currentSegment;
    if (seg == null || seg.duration <= 0) return 0;
    return (_elapsed / seg.duration).clamp(0, 1);
  }

  // ============================================================
  // 播放控制
  // ============================================================
  void play() {
    if (_finished || _interactionId != null) return;
    _playing = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), _tick);
    notifyListeners();
  }

  void pause() {
    _playing = false;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void togglePlay() {
    _playing ? pause() : play();
  }

  void _tick(Timer timer) {
    _elapsed += 0.1 * _playbackRate;
    notifyListeners();

    final seg = currentSegment;
    if (seg != null && _elapsed >= seg.duration) {
      pause();
      _handleSegmentEnd();
    }
  }

  /// 跳转到指定时间点（百分比 0.0~1.0）
  void seek(double ratio) {
    final seg = currentSegment;
    if (seg == null) return;
    _elapsed = (ratio * seg.duration).clamp(0, seg.duration);
    if (_elapsed < seg.duration - 0.2) {
      _endHandled = false;
    } else if (_elapsed >= seg.duration) {
      // 跳到末尾时直接触发片段结束，不等待 timer
      pause();
      _handleSegmentEnd();
      return;
    }
    notifyListeners();
  }

  /// 循环切换播放倍速：1× → 1.25× → 1.5× → 2× → 1×
  void cycleSpeed() {
    const rates = [1.0, 1.25, 1.5, 2.0];
    final idx = rates.indexOf(_playbackRate);
    _playbackRate = rates[(idx + 1) % rates.length];
    notifyListeners();
  }

  /// 重播当前片段
  void restartCurrentScene() {
    _elapsed = 0;
    _endHandled = false;
    notifyListeners();
    play();
  }

  // ============================================================
  // 片段切换（数据驱动）
  // ============================================================
  void setActiveSegment(String segmentId) {
    if (!CourseData.segments.containsKey(segmentId)) return;
    pause();
    _currentSegmentId = segmentId;
    _elapsed = 0;
    _endHandled = false;
    _visited.add(segmentId);
    notifyListeners();
    play();
  }

  void _handleSegmentEnd() {
    if (_endHandled) return;
    _endHandled = true;
    notifyListeners();

    final seg = currentSegment;
    if (seg == null) return;

    // 使用微任务延迟执行，确保 UI 已完成状态更新
    Future.microtask(() {
      if (seg.interaction != null) {
        _openInteraction(seg.interaction!);
      } else if (seg.next != null) {
        setActiveSegment(seg.next!);
      } else if (seg.action == 'finish') {
        _finishLesson();
      }
    });
  }

  // ============================================================
  // 互动节点（数据驱动）
  // ============================================================
  void _openInteraction(String interactionId) {
    pause();
    _interactionId = interactionId;
    _selectedChoice = null;
    notifyListeners();
  }

  void selectOption(String choiceId) {
    _selectedChoice = choiceId;
    notifyListeners();
  }

  void confirmChoice() {
    final choice = _selectedChoice;
    final interactionId = _interactionId;
    if (choice == null || interactionId == null) return;
    final interaction = CourseData.interactions[interactionId];
    if (interaction == null) return;

    final matched = interaction.options.where((o) => o.id == choice);
    final option = matched.isEmpty ? null : matched.first;
    if (option == null) return;

    if (!_triedChoices.contains(choice)) {
      _triedChoices.add(choice);
    }
    _interactionId = null;
    _selectedChoice = null;
    notifyListeners();

    if (option.next != null) {
      setActiveSegment(option.next!);
    }
  }

  void closeInteraction() {
    _interactionId = null;
    _selectedChoice = null;
    notifyListeners();
  }

  // ============================================================
  // 课程完成
  // ============================================================
  void _finishLesson() {
    pause();
    _finished = true;
    notifyListeners();
  }

  // ============================================================
  // 重置
  // ============================================================
  void resetAll() {
    pause();
    _currentSegmentId = 'intro';
    _elapsed = 0;
    _selectedChoice = null;
    _interactionId = null;
    _finished = false;
    _endHandled = false;
    _playbackRate = 1;
    _triedChoices.clear();
    _visited
      ..clear()
      ..add('intro');
    notifyListeners();
  }

  // ============================================================
  // 进度恢复
  // ============================================================
  void restoreProgress({String? segmentId, bool finished = false}) {
    _finished = finished;
    if (finished) {
      _currentSegmentId = 'verify';
      notifyListeners();
    } else if (segmentId != null) {
      setActiveSegment(segmentId);
    } else {
      setActiveSegment('intro');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
