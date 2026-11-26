import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/cohort_state.dart';
import 'package:qtclass_studio/models/learner.dart';
import 'package:qtclass_studio/models/learning_record.dart';
import 'package:qtclass_studio/models/revision.dart';
import 'package:qtclass_studio/models/review.dart';
import 'package:qtclass_studio/services/management_store.dart';

void main() {
  group('ManagementStore', () {
    test('种子对齐 lite 现状：三班招生中', () {
      final store = ManagementStore.seed();
      expect(store.cohorts, hasLength(3));
      expect(store.cohorts.every((c) => c.phase == CohortPhase.recruiting), isTrue);
      expect(store.cohorts.map((c) => c.course), containsAll(['AI编程', 'AI创意', 'AI办公']));
      expect(store.learners, hasLength(2));
      expect(store.records, hasLength(1));
    });

    test('写操作触发 notifyListeners', () {
      final store = ManagementStore.seed();
      var notified = 0;
      store.addListener(() => notified++);
      store.addRecord(const LearningRecord(
        id: 'eeee2222-3333-4444-8555-666677778888',
        title: 'r',
        learnerId: 'aaaa1111-2222-4333-8444-555566667777',
        taskId: 't',
      ));
      expect(notified, 1);
      expect(store.transitionCohort('ai-office-1', CohortPhase.running), isTrue);
      expect(notified, 2);
      expect(store.transitionCohort('ai-office-1', CohortPhase.recruiting), isFalse);
      expect(notified, 2, reason: '非法迁移不写不通知');
    });

    test('updateCohort 按 id 替换字段，找不到返回 false', () {
      final store = ManagementStore.seed();
      final office = store.cohorts.firstWhere((c) => c.id == 'ai-office-1');
      final edited = CohortState(
        id: office.id,
        course: office.course,
        name: office.name,
        phase: office.phase,
        start: office.start,
        quota: '免费 2 名',
      );
      expect(store.updateCohort(edited), isTrue);
      expect(store.cohorts.firstWhere((c) => c.id == 'ai-office-1').quota, '免费 2 名');
      expect(store.updateCohort(const CohortState(id: 'nope', course: '', name: '', phase: CohortPhase.recruiting)), isFalse);
    });

    test('预筛缝：桩实现写回意见并进「已预筛」；合稿只进不退', () async {
      final store = ManagementStore.seed();
      final id = store.revisions.first.id;
      expect(await store.prefilterRevision(id), isTrue);
      final after = store.revisions.first;
      expect(after.status, RevisionStatus.prefilered);
      expect(after.content, contains('桩预筛'));
      expect(store.mergeRevision(id), isTrue);
      expect(store.revisions.first.status, RevisionStatus.merged);
      expect(store.mergeRevision(id), isFalse, reason: '已合稿不能再迁');
    });

    test('两本账读数：活跃按记录、交付按件与任务汇总', () {
      final store = ManagementStore.seed();
      const a = 'aaaa1111-2222-4333-8444-555566667777';
      const b = 'bbbb1111-2222-4333-8444-555566667777';
      expect(store.recordCountOf(a), 1);
      expect(store.recordCountOf(b), 0);
      expect(store.deliveryCountOf(a), 1);
      expect(store.deliveriesByTask(), {'qtgame-tycoon': 1});
      expect(store.lastSubmittedAt(a), 1764192000000);
      expect(store.lastSubmittedAt(b), 0);
      expect(store.learnerById(a)?.title, '同学 A');
      expect(store.learnerById('nope'), isNull);
    });

    test('generateId 为 uuid v4 形态且互不相同', () {
      final id = generateId();
      expect(
        id,
        matches(RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        )),
      );
      expect(generateId(), isNot(id));
    });

    test('评审与学员写入', () {
      final store = ManagementStore.seed();
      store.addLearner(const Learner(id: 'cccc2222-3333-4444-8555-666677778888', title: '同学 C', cohort: 'AI创意'));
      store.addReview(Review(
        id: 'dddd2222-3333-4444-8555-666677778888',
        title: '一周考核',
        learnerId: 'aaaa1111-2222-4333-8444-555566667777',
        cohort: 'AI编程',
        verdict: ReviewVerdict.retained,
      ));
      expect(store.learners, hasLength(3));
      expect(store.reviews, hasLength(1));
    });
  });
}
