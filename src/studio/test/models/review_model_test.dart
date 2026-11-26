import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/review.dart';

const _id = '3c4d5e6f-7a8b-4c1d-ae3f-4a5b6c7d8e9f';
const _learnerId = '1a2b3c4d-5e6f-4a1b-8c2d-3e4f5a6b7c8d';
const _recordId = '2b3c4d5e-6f7a-4b1c-9d2e-3f4a5b6c7d8e';

void main() {
  group('Review 模型', () {
    test('三分去向标签与公告口径一致', () {
      expect(ReviewVerdict.admitted.label, '录取实训基地');
      expect(ReviewVerdict.retained.label, '留作免费学员');
      expect(ReviewVerdict.exited.label, '退出班级');
      expect(ReviewVerdict.values, hasLength(3));
    });

    test('构造与读取：结论记账不带赛事字段', () {
      const r = Review(
        id: _id,
        title: '首期一周考核',
        content: '依据第 1 周学习记录：有提交、反馈积极',
        learnerId: _learnerId,
        cohort: 'AI编程',
        verdict: ReviewVerdict.retained,
        recordId: _recordId,
        decidedAt: 1764192000000,
      );
      expect(r.verdict, ReviewVerdict.retained);
      expect(r.recordId, _recordId);
      expect(r.cohort, 'AI编程');
    });

    test('recordId 可空，toJson 不写空键', () {
      const r = Review(
        id: _id,
        title: 't',
        learnerId: _learnerId,
        cohort: 'AI编程',
        verdict: ReviewVerdict.exited,
      );
      expect(r.recordId, isNull);
      expect(r.toJson().containsKey('recordId'), isFalse);
    });

    test('缺省回退 verdict → 留作免费学员；往返无损', () {
      final parsed = Review.fromJson({'id': _id, 'learnerId': _learnerId});
      expect(parsed.verdict, ReviewVerdict.retained);
      const r = Review(
        id: _id,
        title: 't',
        learnerId: _learnerId,
        cohort: 'AI创意',
        verdict: ReviewVerdict.admitted,
        recordId: _recordId,
      );
      expect(Review.fromJson(r.toJson()).toJson(), r.toJson());
    });
  });
}
