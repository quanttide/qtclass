import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/learning_record.dart';

const _id = '2b3c4d5e-6f7a-4b1c-9d2e-3f4a5b6c7d8e';
const _learnerId = '1a2b3c4d-5e6f-4a1b-8c2d-3e4f5a6b7c8d';

void main() {
  group('LearningRecord 模型', () {
    test('三字段孪生 + 关联字段构造与读取', () {
      const r = LearningRecord(
        id: _id,
        title: '第 1 周学习记录',
        content: '做了什么：复现摆摊游戏\n卡点：提示词\n解决：…\n待完善：…',
        learnerId: _learnerId,
        taskId: 'second-brain-init',
        submittedAt: 1764192000000,
      );
      expect(r.id, _id);
      expect(r.title, '第 1 周学习记录');
      expect(r.content, contains('卡点'));
      expect(r.learnerId, _learnerId);
      expect(r.taskId, 'second-brain-init');
      expect(r.submittedAt, 1764192000000);
    });

    test('缺省回退：content 空、submittedAt 0', () {
      final r = LearningRecord.fromJson({'id': _id, 'learnerId': _learnerId});
      expect(r.content, '');
      expect(r.taskId, '');
      expect(r.submittedAt, 0);
    });

    test('submittedAt 接受 num 并转 int', () {
      final r = LearningRecord.fromJson({
        'id': _id,
        'learnerId': _learnerId,
        'submittedAt': 1764192000000.0,
      });
      expect(r.submittedAt, 1764192000000);
    });

    test('toJson / fromJson 往返无损', () {
      const r = LearningRecord(
        id: _id,
        title: '记录',
        learnerId: _learnerId,
        taskId: 'task-x',
        submittedAt: 42,
      );
      expect(LearningRecord.fromJson(r.toJson()).toJson(), r.toJson());
    });
  });
}
