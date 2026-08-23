import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_api.dart';

/// 学习云 API（qtcloud-learn）：进度上报 + 提交立项。
/// 基址经 --dart-define=QTCLASS_LEARN_API_URL 注入（生产 = 网关 /qtcloud-learn）。
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
    const String fromEnv = String.fromEnvironment('QTCLASS_LEARN_API_URL');
    if (fromEnv.isNotEmpty) {
      return fromEnv;
    }
    return 'http://localhost:8080';
  }

  /// 上报进度：POST /api/courses/prod/progress {moduleId, name} → {max, last}
  Future<({int max, String last})> reportProgress({
    required String moduleId,
    required String name,
  }) async {
    final headers = await _authHeaders();
    final resp = await _client
        .post(
          Uri.parse('$baseUrl/api/courses/prod/progress'),
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

  /// 提交立项：POST /api/proposals（5 问 + 方向类型 + 组队姓名栏）
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
          Uri.parse('$baseUrl/api/proposals'),
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
