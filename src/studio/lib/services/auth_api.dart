import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  AuthApi({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl = baseUrl ?? defaultBaseUrl();

  static const tokenKey = 'qtclass_token';

  final http.Client _client;
  final String baseUrl;

  static String defaultBaseUrl() {
    const String fromEnv = String.fromEnvironment('QTCLASS_AUTH_API_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return 'http://localhost:8080';
  }

  static Future<String?> token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<bool> hasToken() async {
    final value = await token();
    return value != null && value.isNotEmpty;
  }

  static Future<void> saveToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, value);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final resp = await _client
        .post(
          Uri.parse('${baseUrl.replaceFirst(RegExp(r'/$'), '')}/oauth/token'),
          headers: const {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'grant_type': 'password',
            'username': username,
            'password': password,
          },
        )
        .timeout(const Duration(seconds: 15));
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw AuthApiException(_errorMessage(resp));
    }
    final body =
        jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
    final accessToken = body['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw const AuthApiException('登录失败：认证服务未返回 token');
    }
    await saveToken(accessToken);
  }

  String _errorMessage(http.Response resp) {
    try {
      final body =
          jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
      return body['error_description'] as String? ??
          body['error'] as String? ??
          '登录失败（HTTP ${resp.statusCode}）';
    } on FormatException {
      return '登录失败（HTTP ${resp.statusCode}）';
    }
  }
}

class AuthApiException implements Exception {
  const AuthApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
