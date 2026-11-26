import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/learner.dart';

const _id = '1a2b3c4d-5e6f-4a1b-8c2d-3e4f5a6b7c8d';

final _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  group('Learner 模型', () {
    test('三字段孪生 + 关联字段构造与读取', () {
      const l = Learner(
        id: _id,
        title: '同学 A',
        content: '首周跟进',
        cohort: 'AI编程',
        level: LearnerLevel.player,
        status: LearnerStatus.active,
      );
      expect(l.id, _id);
      expect(l.title, '同学 A');
      expect(l.content, '首周跟进');
      expect(l.cohort, 'AI编程');
      expect(l.level, LearnerLevel.player);
      expect(l.status, LearnerStatus.active);
    });

    test('参与度四级中文标签齐', () {
      expect(LearnerLevel.none.label, '没有参与');
      expect(LearnerLevel.player.label, '以玩家身份参与');
      expect(LearnerLevel.author.label, '以作者身份产出');
      expect(LearnerLevel.mentor.label, '以指导者身份帮助');
      expect(LearnerLevel.values, hasLength(4));
    });

    test('缺省：level 没有参与、status 在读', () {
      final l = Learner.fromJson({'id': _id, 'title': '同学 B', 'cohort': 'AI办公'});
      expect(l.level, LearnerLevel.none);
      expect(l.status, LearnerStatus.active);
      expect(l.content, '');
    });

    test('toJson / fromJson 往返无损', () {
      const l = Learner(
        id: _id,
        title: '同学 A',
        cohort: 'AI创意',
        level: LearnerLevel.author,
        status: LearnerStatus.exited,
      );
      expect(Learner.fromJson(l.toJson()).toJson(), l.toJson());
      expect(l.id, matches(_uuidPattern));
    });
  });
}
