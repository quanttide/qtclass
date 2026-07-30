import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/learning_record.dart';

/// 学习记录持久化服务
///
/// 映射自 `doc/screens/player.md` 中的 localStorage 持久化方案。
class HistoryService {
  static const _stateKey = 'qc-player-state';
  static const _historyKey = 'qc-history';

  // ============================================================
  // 播放器状态持久化
  // ============================================================
  Future<void> savePlayerState({
    required String? env,
    required String? runState,
    required bool finished,
    required String currentSegmentId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'env': env,
      'runState': runState,
      'finished': finished,
      'currentSegment': currentSegmentId,
    };
    await prefs.setString(_stateKey, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> loadPlayerState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_stateKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearPlayerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_stateKey);
  }

  // ============================================================
  // 学习记录管理
  // ============================================================
  Future<List<LearningRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => LearningRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addRecord(LearningRecord record) async {
    final history = await loadHistory();
    history.add(record);
    if (history.length > LearningRecord.maxHistoryLength) {
      history.removeRange(0, history.length - LearningRecord.maxHistoryLength);
    }
    await _saveHistory(history);
  }

  Future<void> deleteRecord(int index) async {
    final history = await loadHistory();
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await _saveHistory(history);
    }
  }

  Future<void> _saveHistory(List<LearningRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final data = records.map((r) => r.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(data));
  }
}
