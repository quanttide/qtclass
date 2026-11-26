import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/scaffold_item.dart';

const _id = '4d5e6f7a-8b9c-4d1e-bf4a-5b6c7d8e9f0a';

void main() {
  group('ScaffoldItem 脚手架', () {
    test('三类标签与 ROADMAP 口径一致', () {
      expect(ScaffoldKind.prompt.label, '前置思考题');
      expect(ScaffoldKind.pitfall.label, '常见坑点');
      expect(ScaffoldKind.reflection.label, '反思触发器');
      expect(ScaffoldKind.values, hasLength(3));
    });

    test('构造与读取', () {
      const s = ScaffoldItem(
        id: _id,
        title: '对不上先查自己的抄法',
        content: '拿你抄的底牌对它的数，再定罪。',
        kind: ScaffoldKind.pitfall,
      );
      expect(s.kind, ScaffoldKind.pitfall);
      expect(s.content, contains('底牌'));
    });

    test('缺省 kind → 常见坑点；往返无损', () {
      final parsed = ScaffoldItem.fromJson({'id': _id, 'title': 't'});
      expect(parsed.kind, ScaffoldKind.pitfall);
      const s = ScaffoldItem(
        id: _id,
        title: '全局意识',
        kind: ScaffoldKind.reflection,
      );
      expect(ScaffoldItem.fromJson(s.toJson()).toJson(), s.toJson());
    });
  });
}
