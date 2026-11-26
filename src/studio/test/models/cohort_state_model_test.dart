import 'package:flutter_test/flutter_test.dart';
import 'package:qtclass_studio/models/cohort_state.dart';

void main() {
  group('CohortState 班级状态动作', () {
    test('三态标签与 lite 的 COHORT_STATUS_LABEL 一致', () {
      expect(CohortPhase.recruiting.label, '招生中');
      expect(CohortPhase.running.label, '进行中');
      expect(CohortPhase.closed.label, '已结课');
      expect(CohortPhase.values, hasLength(3));
    });

    test('相邻向前迁移合法：招生中→进行中→已结课', () {
      const c = CohortState(
        id: 'ai-programming-1',
        course: 'AI编程',
        name: '首期',
        phase: CohortPhase.recruiting,
      );
      expect(c.canTransitionTo(CohortPhase.running), isTrue);
      expect(c.transitionTo(CohortPhase.running)?.phase, CohortPhase.running);
      expect(
        c.transitionTo(CohortPhase.running)?.transitionTo(CohortPhase.closed)?.phase,
        CohortPhase.closed,
      );
    });

    test('回退与跳级非法，返回 null 不抛异常', () {
      const running = CohortState(
        id: 'x-1',
        course: 'AI办公',
        name: '首期',
        phase: CohortPhase.running,
      );
      expect(running.canTransitionTo(CohortPhase.recruiting), isFalse);
      expect(running.transitionTo(CohortPhase.recruiting), isNull);
      const recruiting = CohortState(
        id: 'y-1',
        course: 'AI创意',
        name: '首期',
        phase: CohortPhase.recruiting,
      );
      expect(recruiting.transitionTo(CohortPhase.closed), isNull);
    });

    test('迁移保留无事实字段原样', () {
      const c = CohortState(
        id: 'ai-creative-1',
        course: 'AI创意',
        name: '首期',
        phase: CohortPhase.recruiting,
        start: '11 月 25 日',
        apply: '按第 1 课交成品',
      );
      final next = c.transitionTo(CohortPhase.running)!;
      expect(next.start, '11 月 25 日');
      expect(next.apply, '按第 1 课交成品');
      expect(next.quota, isNull);
    });

    test('无事实字段 toJson 不写空键；往返无损', () {
      const c = CohortState(
        id: 'ai-office-1',
        course: 'AI办公',
        name: '首期',
        phase: CohortPhase.recruiting,
        start: '11 月 27 日',
      );
      final json = c.toJson();
      expect(json.containsKey('quota'), isFalse);
      expect(json.containsKey('window'), isFalse);
      expect(CohortState.fromJson(json).toJson(), json);
    });

    test('非法 status 名回退招生中', () {
      final c = CohortState.fromJson({'id': 'z-1', 'course': 'AI编程', 'name': '首期'});
      expect(c.phase, CohortPhase.recruiting);
    });
  });
}
