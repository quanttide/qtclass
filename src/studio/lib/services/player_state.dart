import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/segment.dart';
import 'course_data.dart';

/// 播放器运行时状态枚举
enum InteractionType { env, runState }

/// 播放器状态机 — 驱动所有 UI 变化
///
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

  // 用户选择
  String? _env;
  String? _runState;
  InteractionType? _interactionType;
  String? _selectedChoice;
  bool _finished = false;
  final List<String> _triedRunStates = [];

  // ============================================================
  // Getters
  // ============================================================
  String get currentSegmentId => _currentSegmentId;
  double get elapsed => _elapsed;
  bool get playing => _playing;
  double get playbackRate => _playbackRate;
  bool get endHandled => _endHandled;

  String? get env => _env;
  String? get runState => _runState;
  InteractionType? get interactionType => _interactionType;
  String? get selectedChoice => _selectedChoice;
  bool get finished => _finished;
  List<String> get triedRunStates => List.unmodifiable(_triedRunStates);

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
    if (_finished || _interactionType != null) return;
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
    if (_elapsed < seg.duration - 0.2) _endHandled = false;
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
  // 片段切换
  // ============================================================
  void setActiveSegment(String segmentId) {
    if (!CourseData.segments.containsKey(segmentId)) return;
    pause();
    _currentSegmentId = segmentId;
    _elapsed = 0;
    _endHandled = false;
    notifyListeners();
    play();
  }

  void _handleSegmentEnd() {
    if (_endHandled) return;
    _endHandled = true;
    notifyListeners();

    // 使用微任务延迟执行，确保 UI 已完成状态更新
    Future.microtask(() {
      if (_currentSegmentId == 'intro') {
        _openInteraction(InteractionType.env);
      } else if (['windows', 'macos', 'linux'].contains(_currentSegmentId)) {
        setActiveSegment('first-program');
      } else if (_currentSegmentId == 'first-program') {
        _openInteraction(InteractionType.runState);
      } else if (_currentSegmentId == 'run-success') {
        _finishLesson();
      } else if (['run-error', 'run-unknown'].contains(_currentSegmentId)) {
        _openInteraction(InteractionType.runState);
      }
    });
  }

  // ============================================================
  // 互动节点
  // ============================================================
  void _openInteraction(InteractionType type) {
    pause();
    _interactionType = type;
    _selectedChoice = null;
    notifyListeners();
  }

  void selectOption(String choiceId) {
    _selectedChoice = choiceId;
    notifyListeners();
  }

  void confirmChoice() {
    final choice = _selectedChoice;
    final type = _interactionType;
    if (choice == null || type == null) return;

    if (type == InteractionType.env) {
      _env = choice;
      _interactionType = null;
      _selectedChoice = null;
      notifyListeners();
      setActiveSegment(choice); // windows / macos / linux
    } else if (type == InteractionType.runState) {
      _runState = choice;
      if (!_triedRunStates.contains(choice)) {
        _triedRunStates.add(choice);
      }
      _interactionType = null;
      _selectedChoice = null;
      notifyListeners();
      setActiveSegment('run-$choice');
    }
  }

  void closeInteraction() {
    _interactionType = null;
    _selectedChoice = null;
    notifyListeners();
  }

  /// 过滤已尝试过的运行状态选项
  List<String> get availableRunStateIds {
    return CourseData.runStateOptions
        .map((o) => o.id)
        .where((id) => !_triedRunStates.contains(id))
        .toList();
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
    _env = null;
    _runState = null;
    _selectedChoice = null;
    _interactionType = null;
    _finished = false;
    _endHandled = false;
    _playbackRate = 1;
    _triedRunStates.clear();
    notifyListeners();
  }

  // ============================================================
  // 进度恢复
  // ============================================================
  void restoreProgress({
    String? env,
    String? runState,
    bool finished = false,
  }) {
    _env = env;
    _runState = runState;
    _finished = finished;

    if (finished) {
      _currentSegmentId = 'run-success';
      notifyListeners();
    } else if (runState != null) {
      setActiveSegment('run-$runState');
    } else if (env != null) {
      setActiveSegment(env);
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
