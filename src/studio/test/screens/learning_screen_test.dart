import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qtclass_studio/screens/learning_screen.dart';
import 'package:qtclass_studio/services/auth_api.dart';
import 'package:qtclass_studio/services/learn_api.dart';

String _jwt({required String sub}) {
  String enc(Map<String, dynamic> value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${enc({'alg': 'none'})}.${enc({'sub': sub})}.sig';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('AuthApi.userId 从 JWT sub 解析 user_id', () async {
    await AuthApi.saveToken(_jwt(sub: 'user-1'));
    expect(await AuthApi.userId(), 'user-1');
  });

  testWidgets('学习页展示训练营/任务并可标记完成', (tester) async {
    await AuthApi.saveToken(_jwt(sub: 'user-1'));
    final completions = <Map<String, dynamic>>[];
    late Map<String, dynamic> completionBody;
    final client = MockClient((request) async {
      if (request.url.path == '/schedules') {
        return http.Response(
          jsonEncode([
            {
              'id': 'schedule-agent-engineer',
              'title': '智能体工程师训练营',
              'description': '按学习路径推进',
              'tasks': [
                {
                  'id': 'task-data-second-brain',
                  'title': '熟悉数据工程第二大脑',
                  'description': '提交一条改进建议',
                },
              ],
            },
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      if (request.url.path == '/tasks') {
        return http.Response(
          jsonEncode([
            {
              'id': 'task-data-second-brain',
              'title': '熟悉数据工程第二大脑',
              'description': '提交一条改进建议',
            },
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      if (request.url.path == '/learners') {
        return http.Response(
          jsonEncode([
            {'id': 'lea-1', 'user_id': 'user-1'},
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      if (request.url.path == '/completions' && request.method == 'GET') {
        return http.Response(
          jsonEncode(completions),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      if (request.url.path == '/completions' && request.method == 'POST') {
        completionBody = jsonDecode(request.body) as Map<String, dynamic>;
        completions.add({'id': 'com-1', ...completionBody});
        return http.Response(
          jsonEncode({'id': 'com-1', ...completionBody}),
          201,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response('{"error":"not found"}', 404);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: LearningScreen(
          api: LearnApi(
            client: client,
            baseUrl: '',
            tokenProvider: AuthApi.token,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('智能体工程师训练营'), findsOneWidget);
    expect(find.text('熟悉数据工程第二大脑'), findsWidgets);

    await tester.tap(find.text('标记完成').first);
    await tester.pumpAndSettle();

    expect(completionBody['learner_id'], 'lea-1');
    expect(completionBody['task_id'], 'task-data-second-brain');
    expect(completionBody['status'], 'completed');
    expect(find.text('已完成'), findsWidgets);
  });
}
