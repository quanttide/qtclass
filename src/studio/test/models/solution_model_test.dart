import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/solution.dart';

const _solutionId = 'a3f2b8c4-5d6e-4f70-8a91-b2c3d4e5f607';

void main() {
  group('Solution 模型', () {
    test('三字段与 Assignment 同形', () {
      const s = Solution(
        id: _solutionId,
        title: '小说发行参考答案：合格交付长什么样',
        content: '# 合格小红书笔记范例\n\n陌生人看完会说「有点想看」。',
      );
      expect(s.id, _solutionId);
      expect(s.title, contains('参考答案'));
      expect(s.content, startsWith('#'));
      expect(s.toJson().keys.toList(), ['id', 'title', 'content']);
    });

    test('fromJson：id 必填，title / content 缺省回退空串', () {
      expect(Solution.fromJson({'id': _solutionId}).title, '');
      expect(Solution.fromJson({'id': _solutionId}).content, '');
      expect(() => Solution.fromJson(const {}), throwsA(isA<TypeError>()));
    });

    test('toJson / fromJson 往返无损', () {
      const s = Solution(id: _solutionId, title: '标题', content: '## 范例正文');
      expect(Solution.fromJson(s.toJson()).toJson(), s.toJson());
    });
  });
}
