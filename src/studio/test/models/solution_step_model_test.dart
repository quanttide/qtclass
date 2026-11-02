import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/solution_step.dart';

const _write = '1a2b3c4d-5e6f-4071-8283-94a5b6c7d8e9';
const _publish = '2b3c4d5e-6f70-4182-93a4-b5c6d7e8f901';
const _post = '3c4d5e6f-7081-4293-a4b5-c6d7e8f90a12';
const _review = '4d5e6f70-8192-43a4-b5c6-d7e8f90a1b23';

void main() {
  group('SolutionStep 模型', () {
    test('三字段孪生 + after 默认空（入口单元）', () {
      const s = SolutionStep(id: _write, title: '重写文案', content: '## 判断标准\n100 字内讲清类型与爽点');
      expect(s.after, isEmpty);
      expect(s.toJson().containsKey('after'), isFalse);
    });

    test('fromJson：after 缺省空列表、带值解析', () {
      expect(SolutionStep.fromJson({'id': _write, 'title': 't', 'content': 'c'}).after, isEmpty);
      final step = SolutionStep.fromJson({
        'id': _review,
        'title': '复盘',
        'content': 'c',
        'after': [_publish, _post],
      });
      expect(step.after, [_publish, _post]);
    });

    test('toJson / fromJson 往返无损（空 after 不落键）', () {
      for (final json in [
        {'id': _write, 'title': '重写文案', 'content': '正文'},
        {
          'id': _review,
          'title': '复盘',
          'content': '正文',
          'after': [_publish, _post],
        },
      ]) {
        expect(SolutionStep.fromJson(json).toJson(), json);
      }
    });
  });

  group('DAG 组图（小说发行：菱形）', () {
    // 重写文案 → 晋江更新 ┐
    //       └→ 小红书首发 ┴→ 复盘（两个前置 = 多入度）
    final steps = [
      const SolutionStep(id: _write, title: '重写文案', content: 'c'),
      const SolutionStep(
        id: _publish,
        title: '晋江更新',
        content: 'c',
        after: [_write],
      ),
      const SolutionStep(
        id: _post,
        title: '小红书首发',
        content: 'c',
        after: [_write],
      ),
      const SolutionStep(
        id: _review,
        title: '复盘',
        content: 'c',
        after: [_publish, _post],
      ),
    ];

    test('入口唯一：after 为空的只有首步', () {
      final entries = steps.where((s) => s.after.isEmpty).toList();
      expect(entries, hasLength(1));
      expect(entries.single.id, _write);
    });

    test('多入度成立：复盘有两个前置', () {
      final review = steps.firstWhere((s) => s.id == _review);
      expect(review.after, hasLength(2));
    });

    test('边两端都有主：after 引用全部落在图内', () {
      final ids = steps.map((s) => s.id).toSet();
      for (final s in steps) {
        for (final dep in s.after) {
          expect(ids.contains(dep), isTrue, reason: '${s.title} 的前置 $dep 必须在图内');
        }
      }
    });

    test('按 after 拓扑分层：入口 → 分叉 → 汇合', () {
      final entries = steps.where((s) => s.after.isEmpty).map((s) => s.id).toSet();
      expect(entries, isNotEmpty);
      var visited = {...entries};
      final layers = [entries.toList()];
      while (true) {
        final next = steps
            .where((s) =>
                !visited.contains(s.id) &&
                s.after.isNotEmpty &&
                s.after.every(visited.contains))
            .map((s) => s.id)
            .toSet();
        if (next.isEmpty) break;
        layers.add(next.toList());
        visited = visited.union(next);
      }
      expect(layers, hasLength(3)); // 重写文案 → 晋江更新+小红书首发 → 复盘
      expect(layers.last, [_review]);
    });
  });
}
