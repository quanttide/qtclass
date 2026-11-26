import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/revision.dart';

const _id = '5e6f7a8b-9c0d-4e1f-c05b-6c7d8e9f0a1b';

/// 预筛缝的桩实现：不接真实 AI，只回一句固定意见。
class _StubPreFilter implements DiffPreFilter {
  @override
  Future<String> prefilter(Revision revision) async => '桩预筛：diff 通过';
}

void main() {
  group('Revision 修订回环骨架', () {
    test('三态标签与只进不退', () {
      expect(RevisionStatus.draft.label, '待预筛');
      expect(RevisionStatus.prefilered.label, '已预筛');
      expect(RevisionStatus.merged.label, '已合稿');

      const r = Revision(id: _id, taskId: 'task-x', title: 't');
      expect(r.status, RevisionStatus.draft);
      expect(r.transitionTo(RevisionStatus.merged), isNull); // 跳级非法
      expect(r.transitionTo(RevisionStatus.draft), isNull); // 回退非法
      final prefilered = r.transitionTo(RevisionStatus.prefilered)!;
      expect(prefilered.status, RevisionStatus.prefilered);
      expect(prefilered.transitionTo(RevisionStatus.merged)!.status, RevisionStatus.merged);
    });

    test('字段与往返无损', () {
      const r = Revision(
        id: _id,
        taskId: 'game-task',
        title: '第 3 步补验收句',
        content: '修订说明',
        before: '# 旧任务书',
        after: '# 新任务书',
        status: RevisionStatus.prefilered,
      );
      expect(r.before, '# 旧任务书');
      expect(r.after, '# 新任务书');
      expect(Revision.fromJson(r.toJson()).toJson(), r.toJson());
    });

    test('DiffPreFilter 接口缝可被桩实现', () async {
      const r = Revision(id: _id, taskId: 'task-x', title: 't');
      final out = await _StubPreFilter().prefilter(r);
      expect(out, contains('桩预筛'));
    });
  });
}
