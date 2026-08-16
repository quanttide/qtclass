import 'package:shared_preferences/shared_preferences.dart';

/// 学员身份服务 — 对齐原型 qt-learner（localStorage）。
/// v0.1 无登录态：默认「演示学员」，提交立项时用表单所填姓名。
class LearnerService {
  static const _key = 'qt_learner';

  /// 当前学员姓名（未设置时默认演示学员）。
  static Future<String> name() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? '演示学员';
  }

  /// 设置学员姓名（提交立项后更新）。
  static Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, name);
  }
}
