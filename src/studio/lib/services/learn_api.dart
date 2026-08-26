import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_api.dart';

/// 学习服务 API：进度上报 + 提交立项。
/// 客户端只依赖 qtclass 服务端；学习云作为上游被服务端代理，对客户端透明。
/// 基址经 --dart-define=QTCLASS_API_BASE_URL 注入。
class LearnApi {
  LearnApi({
    http.Client? client,
    String? baseUrl,
    Future<String?> Function()? tokenProvider,
  }) : _client = client ?? http.Client(),
       _tokenProvider = tokenProvider ?? AuthApi.token,
       baseUrl = baseUrl ?? defaultBaseUrl();

  final http.Client _client;
  final Future<String?> Function() _tokenProvider;
  final String baseUrl;

  static String defaultBaseUrl() {
    const String fromEnv = String.fromEnvironment('QTCLASS_API_BASE_URL');
    if (fromEnv.isNotEmpty) {
      return fromEnv;
    }
    // release 构建默认生产网关，避免 CI 变量缺失时回退 localhost（debug 开发默认本地）
    if (kReleaseMode) return 'https://api.quanttide.com/qtclass';
    return 'http://localhost:8080';
  }

  /// 上报进度：POST /progress {moduleId, name} → {max, last}（服务端代理学习云）
  Future<({int max, String last})> reportProgress({
    required String moduleId,
    required String name,
  }) async {
    final headers = await _authHeaders();
    final resp = await _client
        .post(
          Uri.parse('$baseUrl/progress'),
          headers: headers,
          body: jsonEncode({'moduleId': moduleId, 'name': name}),
        )
        .timeout(const Duration(seconds: 15));
    if (resp.statusCode != 200) {
      throw LearnApiException('上报进度失败（HTTP ${resp.statusCode}）');
    }
    final body =
        jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
    return (max: body['max'] as int? ?? 0, last: body['last'] as String? ?? '');
  }

  /// 提交立项：POST /proposals（5 问 + 方向类型 + 组队姓名栏，服务端代理学习云）
  Future<void> submitProposal({
    required String projectName,
    required String opportunity,
    required String fit,
    required String hypothesis,
    required String demo,
    required String directionType,
    required String teamMode,
    required String teamLeader,
    required String teamMember,
    required String studentName,
  }) async {
    final headers = await _authHeaders();
    final resp = await _client
        .post(
          Uri.parse('$baseUrl/proposals'),
          headers: headers,
          body: jsonEncode({
            'projectName': projectName,
            'opportunity': opportunity,
            'fit': fit,
            'hypothesis': hypothesis,
            'demo': demo,
            'directionType': directionType,
            'teamMode': teamMode,
            'teamLeader': teamLeader,
            'teamMember': teamMember,
            'studentName': studentName,
          }),
        )
        .timeout(const Duration(seconds: 15));
    if (resp.statusCode != 201) {
      throw LearnApiException(_errorMessage(resp));
    }
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _tokenProvider();
    if (token == null || token.isEmpty) {
      throw const LearnApiException('请先登录', statusCode: 401);
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  String _errorMessage(http.Response resp) {
    try {
      final body =
          jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
      return body['error'] as String? ?? 'HTTP ${resp.statusCode}';
    } on FormatException {
      return 'HTTP ${resp.statusCode}';
    }
  }
}

class LearnApiException implements Exception {
  const LearnApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
