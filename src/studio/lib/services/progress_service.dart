import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 课程进度服务 — 每门课独立持久化
///
/// 映射自 `doc/screens/course-detail.md → 进度持久化`：
/// 存储键 `qt-progress-<courseId>`，格式 `{"max":N,"last":"sN"}`。
/// - [max] 只增不减（已完成的模块数）
/// - [last] 上次所在模块；为空时详情页显示课程首页（Hero）
class ProgressService {
  static String _key(String courseId) => 'qt-progress-$courseId';

  static int _max = 0;
  static String? _last;

  /// 读取课程进度；未存储过时返回 max=0、last=null
  static Future<({int max, String? last})> load(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(courseId));
    if (raw == null) return (max: 0, last: null);
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _max = json['max'] as int? ?? 0;
      _last = json['last'] as String?;
    } catch (_) {
      _max = 0;
      _last = null;
    }
    return (max: _max, last: _last);
  }

  /// 保存进度：max 只增不减，last 总是更新
  static Future<void> save(
    String courseId, {
    required int max,
    String? last,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load(courseId);
    final newMax = max > current.max ? max : current.max;
    _max = newMax;
    _last = last;
    await prefs.setString(
      _key(courseId),
      jsonEncode({'max': newMax, 'last': last ?? current.last}),
    );
  }
}
