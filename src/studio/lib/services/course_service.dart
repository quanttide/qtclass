import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/course.dart';

/// 课程目录服务 — 课程列表与详情的数据源
///
/// 数据源优先级：
/// 1. 服务端 API（qtcloud-course，`GET /courses` / `GET /courses/{id}`）
/// 2. 本地资产 `assets/course_list.json`（v0.1 mock）
///
/// 与 [CourseData]（播放器单门课数据）解耦：本服务管课程目录，
/// 播放器数据由 `GET /courses/{id}/player` 对应（v0.1 暂用现有 course.json）。
class CourseService {
  /// 课程列表（id → Course），启动时加载
  static Map<String, Course> _courses = const {};

  static List<Course> get all => _courses.values.toList();

  static Course? byId(String id) => _courses[id];

  static bool get loaded => _courses.isNotEmpty;

  /// 加载课程目录：优先服务端 API，失败回退本地资产。
  static Future<void> load({
    String assetPath = 'assets/course_list.json',
    String? apiUrl,
  }) async {
    if (apiUrl != null && apiUrl.isNotEmpty) {
      try {
        final resp = await http
            .get(Uri.parse('$apiUrl/courses'))
            .timeout(const Duration(seconds: 30));
        if (resp.statusCode == 200) {
          _fromJson(jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>);
          return;
        }
      } catch (_) {
        // 服务端不可用，回退本地资产
      }
    }
    final raw = await rootBundle.loadString(assetPath);
    _fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static void _fromJson(Map<String, dynamic> json) {
    _courses = {
      for (final c in json['courses'] as List<dynamic>)
        (c as Map<String, dynamic>)['id'] as String: Course.fromJson(c),
    };
  }
}