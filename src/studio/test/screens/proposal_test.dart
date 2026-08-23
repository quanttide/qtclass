// 立项表单 + 进度上报测试：LearnApi 请求体校验（MockClient）+ 表单姓名栏切换
// （个人独立 → 个人姓名；搭档 → 队长+队员）。

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qtclass_studio/screens/proposal_screen.dart';
import 'package:qtclass_studio/services/auth_api.dart';
import 'package:qtclass_studio/services/learn_api.dart';
import 'package:qtclass_studio/services/learner_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('LearnApi.reportProgress 上报 {moduleId, name}', () async {
    late Map<String, dynamic> sent;
    late String? authHeader;
    final client = MockClient((request) async {
      authHeader = request.headers['Authorization'];
      sent = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        '{"max":3,"last":"m3"}',
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final api = LearnApi(
      client: client,
      baseUrl: 'http://fake',
      tokenProvider: () async => 'test-token',
    );

    final result = await api.reportProgress(moduleId: 'm3', name: '演示学员');
    expect(authHeader, 'Bearer test-token');
    expect(sent['moduleId'], 'm3');
    expect(sent['name'], '演示学员');
    expect(result.max, 3);
    expect(result.last, 'm3');
  });

  test('LearnApi 无 token 时抛 401 登录提示', () async {
    final client = MockClient((_) async => http.Response('{}', 200));
    final api = LearnApi(
      client: client,
      baseUrl: 'http://fake',
      tokenProvider: () async => null,
    );

    expect(
      () => api.reportProgress(moduleId: 'm1', name: '演示学员'),
      throwsA(
        isA<LearnApiException>()
            .having((e) => e.statusCode, 'statusCode', 401)
            .having((e) => e.message, 'message', '请先登录'),
      ),
    );
  });

  test('LearnApi.submitProposal 提交 5 问 + 姓名栏', () async {
    late Map<String, dynamic> sent;
    final client = MockClient((request) async {
      sent = jsonDecode(request.body) as Map<String, dynamic>;
      return http.Response(
        '{"id":"appl-1"}',
        201,
        headers: {'content-type': 'application/json'},
      );
    });
    final api = LearnApi(
      client: client,
      baseUrl: 'http://fake',
      tokenProvider: () async => 'test-token',
    );

    await api.submitProposal(
      projectName: '选课助手',
      opportunity: '机会描述',
      fit: '匹配原因',
      hypothesis: '核心假设',
      demo: 'Demo 方案',
      directionType: '内容',
      teamMode: 'partner',
      teamLeader: '张三',
      teamMember: '李四、王五',
      studentName: '张三',
    );
    expect(sent['projectName'], '选课助手');
    expect(sent['opportunity'], '机会描述');
    expect(sent['teamMode'], 'partner');
    expect(sent['teamLeader'], '张三');
    expect(sent['teamMember'], '李四、王五');
  });

  test('AuthApi.login 表单登录并保存 token', () async {
    late String requestBody;
    final client = MockClient((request) async {
      requestBody = request.body;
      return http.Response(
        '{"access_token":"jwt-token"}',
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final api = AuthApi(client: client, baseUrl: 'http://auth');

    await api.login(username: 'test-verify-0815', password: 'TestPass123');

    expect(requestBody, contains('grant_type=password'));
    expect(requestBody, contains('username=test-verify-0815'));
    expect(await AuthApi.token(), 'jwt-token');
  });

  testWidgets('立项表单：组队方式切换姓名栏（个人→队长+队员）', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final client = MockClient((request) async {
      return http.Response(
        '{"id":"appl-1"}',
        201,
        headers: {'content-type': 'application/json'},
      );
    });
    await tester.pumpWidget(
      MaterialApp(
        home: ProposalScreen(
          api: LearnApi(
            client: client,
            baseUrl: 'http://fake',
            tokenProvider: () async => 'test-token',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 默认个人独立：显示"你的姓名（个人独立）"
    expect(find.text('你的姓名（个人独立）'), findsOneWidget);

    // 切到搭档：队长 + 队员输入框
    await tester.tap(find.text('个人独立'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('已找好搭档').last);
    await tester.pumpAndSettle();
    expect(find.text('队长姓名'), findsOneWidget);
    expect(find.text('队员姓名（多个用顿号分隔）'), findsOneWidget);
  });

  testWidgets('提交立项成功：更新学员身份并返回', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final client = MockClient((request) async {
      return http.Response(
        '{"id":"appl-1"}',
        201,
        headers: {'content-type': 'application/json'},
      );
    });
    await tester.pumpWidget(
      MaterialApp(
        home: ProposalScreen(
          api: LearnApi(
            client: client,
            baseUrl: 'http://fake',
            tokenProvider: () async => 'test-token',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '张三');
    await tester.enterText(find.byType(TextField).at(1), '选课助手');
    await tester.tap(find.text('提交立项'));
    await tester.pumpAndSettle();

    expect(await LearnerService.name(), '张三');
  });
}
