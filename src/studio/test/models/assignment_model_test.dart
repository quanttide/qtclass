import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/assignment.dart';

const _fictionId = 'f7ae7a7a-ebc9-4d95-ad94-199995a46cda';
const _gameId = 'e24114b5-135f-4c88-9ef9-8ee73f9f9388';

final _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  group('Assignment 模型', () {
    test('三字段构造与读取', () {
      const a = Assignment(id: _fictionId, title: '量潮小说发行大作业', content: '# 量潮小说发行任务书');
      expect(a.id, _fictionId);
      expect(a.title, '量潮小说发行大作业');
      expect(a.content, startsWith('#'));
    });

    test('fromJson 解析完整载荷，id 必填', () {
      final a = Assignment.fromJson({
        'id': _gameId,
        'title': '量潮模拟经营游戏大作业',
        'content': '# 量潮模拟经营游戏任务书\n\n## 4399 平台上线\n...',
      });
      expect(a.id, _gameId);
      expect(a.title, contains('游戏'));
      expect(a.content, contains('4399'));
      expect(a.id, matches(_uuidPattern));
    });

    test('title / content 缺省回退空串', () {
      final a = Assignment.fromJson({'id': _fictionId});
      expect(a.title, '');
      expect(a.content, '');
    });

    test('toJson / fromJson 往返无损', () {
      const a = Assignment(id: _gameId, title: '标题', content: '## Markdown 正文');
      expect(Assignment.fromJson(a.toJson()).toJson(), a.toJson());
    });

    test('两份真实实例 id 为 uuid 形态', () {
      expect(_fictionId, matches(_uuidPattern));
      expect(_gameId, matches(_uuidPattern));
    });
  });
}
