import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/assignment.dart';
import '../models/cohort_state.dart';
import '../models/learner.dart';
import '../models/learning_record.dart';
import '../models/revision.dart';
import '../models/review.dart';
import '../models/solution.dart';
import '../models/solution_step.dart';
import '../models/scaffold_item.dart';

/// Delivery（交付）— 交付账的最小读数数据：管理录入、内存种子。
/// 不入 models 层：它是账的原料，不是领域对象；数据源与录入通道随 v0.3 定。
class Delivery {
  final String learnerId;
  final String taskId;
  final int at;

  const Delivery({required this.learnerId, required this.taskId, this.at = 0});
}

/// 生成 uuid v4 形态的新 id（不引第三方包，与既有手写 uuid 惯例一致）。
String generateId() {
  final r = Random();
  String hex(int n) => List.generate(n, (_) => r.nextInt(16).toRadixString(16)).join();
  const variants = ['8', '9', 'a', 'b'];
  return '${hex(8)}-${hex(4)}-4${hex(3)}-${variants[r.nextInt(4)]}${hex(3)}-${hex(12)}';
}

/// 预筛桩：v0.2.0 不接真实 AI，固定意见——缝在 [DiffPreFilter]，实现后替换本桩。
class EchoDiffPreFilter implements DiffPreFilter {
  @override
  Future<String> prefilter(Revision revision) async =>
      '桩预筛（未接 AI）：请人工复核 before/after 差异后合稿。';
}

/// PracticeTask（实践项目）— 众包屏的项目清单；id 对齐 lite `data/tasks/` 的 slug，
/// title 取任务书 frontmatter 的 title（真实事实，不编）。
class PracticeTask {
  final String id;
  final String title;

  const PracticeTask({required this.id, required this.title});
}

/// ManagementStore — 管理层的内存仓（v0.2.0：不新造存储通道，数据先内存/本地）。
///
/// 对象以 lite 分解为正本（cohort 字段对齐），本仓只装 lite 刻意不建的对象与
/// 管理原料；回灌缝见 [CohortSink]，预筛缝见 [DiffPreFilter]。
class ManagementStore extends ChangeNotifier {
  final List<Learner> learners;
  final List<LearningRecord> records;
  final List<Review> reviews;
  final List<CohortState> cohorts;
  final List<ScaffoldItem> scaffolds;
  final List<Revision> revisions;
  final List<Delivery> deliveries;
  final List<PracticeTask> tasks;
  final List<Assignment> assignments;
  final List<Solution> solutions;
  final List<SolutionStep> steps;

  ManagementStore({
    List<Learner>? learners,
    List<LearningRecord>? records,
    List<Review>? reviews,
    List<CohortState>? cohorts,
    List<ScaffoldItem>? scaffolds,
    List<Revision>? revisions,
    List<Delivery>? deliveries,
    List<PracticeTask>? tasks,
    List<Assignment>? assignments,
    List<Solution>? solutions,
    List<SolutionStep>? steps,
  })  : learners = learners ?? [],
        records = records ?? [],
        reviews = reviews ?? [],
        cohorts = cohorts ?? [],
        scaffolds = scaffolds ?? [],
        revisions = revisions ?? [],
        deliveries = deliveries ?? [],
        tasks = tasks ?? [],
        assignments = assignments ?? [],
        solutions = solutions ?? [],
        steps = steps ?? [];

  /// 演示种子：三班（对齐 lite 现状）+ 两学员 + 记录/交付/脚手架各若干。
  factory ManagementStore.seed() => ManagementStore(
        cohorts: [
          const CohortState(
            id: 'ai-programming-1',
            course: 'AI编程',
            name: '首期',
            phase: CohortPhase.recruiting,
            quota: '免费 3~5 名',
            window: '免费班 11 月 23 日起开放',
            apply: '按第 1 课交成品：自己上线的游戏网址，附一段制作说明',
          ),
          const CohortState(
            id: 'ai-creative-1',
            course: 'AI创意',
            name: '首期',
            phase: CohortPhase.recruiting,
            start: '11 月 25 日',
            apply: '按第 1 课交成品：你生成的第一张图，附一段制作说明',
          ),
          const CohortState(
            id: 'ai-office-1',
            course: 'AI办公',
            name: '首期',
            phase: CohortPhase.recruiting,
            start: '11 月 27 日',
          ),
        ],
        learners: [
          Learner(
            id: 'aaaa1111-2222-4333-8444-555566667777',
            title: '同学 A',
            content: '第 1 周已交记录与作品',
            cohort: 'AI编程',
            level: LearnerLevel.author,
          ),
          Learner(
            id: 'bbbb1111-2222-4333-8444-555566667777',
            title: '同学 B',
            cohort: 'AI办公',
            level: LearnerLevel.player,
          ),
        ],
        records: [
          LearningRecord(
            id: 'cccc1111-2222-4333-8444-555566667777',
            title: '第 1 周学习记录',
            content: '做了什么：复现摆摊游戏上线\n卡点：提示词总跑偏\n解决：照课时指令逐条抄\n待完善：第 4 步宣发',
            learnerId: 'aaaa1111-2222-4333-8444-555566667777',
            taskId: 'qtgame-tycoon',
            submittedAt: 1764192000000,
          ),
        ],
        tasks: const [
          PracticeTask(id: 'second-brain-init', title: '第二大脑创建插件'),
          PracticeTask(id: 'qtgame-tycoon', title: '量潮模拟经营游戏任务书'),
          PracticeTask(id: 'quanttide-fiction-of-founder', title: '量潮小说发行任务书'),
          PracticeTask(id: 'legal-evidence', title: '评论区侵权「有效取证流水线」解决方案设计'),
          PracticeTask(id: 'project-retrospective-system', title: '项目复盘系统搭建'),
          PracticeTask(id: 'learn-profile', title: '贡献学习档案'),
        ],
        deliveries: [
          const Delivery(
            learnerId: 'aaaa1111-2222-4333-8444-555566667777',
            taskId: 'qtgame-tycoon',
            at: 1764192000000,
          ),
        ],
        scaffolds: [
          const ScaffoldItem(
            id: 'dddd1111-2222-4333-8444-555566667777',
            title: '对不上先查自己的抄法',
            content: '拿你抄的底牌对它的数：对不上先自查抄法，再定罪。',
            kind: ScaffoldKind.pitfall,
          ),
          const ScaffoldItem(
            id: 'eeee1111-2222-4333-8444-555566667777',
            title: '全局意识防被 AI 带跑偏',
            content: '投入到过分细节里而迷失，是所有人都会有的问题——先看全局再下钻。',
            kind: ScaffoldKind.reflection,
          ),
          const ScaffoldItem(
            id: 'ffff1111-2222-4333-8444-555566667777',
            title: '动手前先复述任务',
            content: '先复述你要去哪几处、查哪几项，等「开始」再动手。',
            kind: ScaffoldKind.prompt,
          ),
        ],
        assignments: [
          const Assignment(
            id: '11111111-1111-4111-8111-111111111111',
            title: '量潮模拟经营游戏大作业',
            content: '# 任务书\n\n以已上线的摆摊游戏为参照，复现一个可上线的作品。',
          ),
        ],
        solutions: [
          const Solution(
            id: '22222222-2222-4222-8222-222222222222',
            title: '参考：运营简报范文',
            content: '# 运营简报\n\n第一栏每条带来源链接与抓取日期；第二栏写清查不到问谁。',
          ),
        ],
        steps: [
          const SolutionStep(
            id: '33333333-3333-4333-8333-333333333333',
            title: '第 1 步：打开工具',
            content: '粘贴指令，等「开始」再动手。',
          ),
          const SolutionStep(
            id: '44444444-4444-4444-8444-444444444444',
            title: '第 2 步：逐条核对',
            content: '拿底牌对它的数。',
            after: ['33333333-3333-4333-8333-333333333333'],
          ),
        ],
        revisions: [
          const Revision(
            id: '99991111-2222-4333-8444-555566667777',
            taskId: 'hello-world',
            title: '第 4 步补宣发验收句',
            content: '把「拿出去」步的验收写死：能发给朋友玩的链接。',
            before: '# 第 4 步：拿出去\n',
            after: '# 第 4 步：拿出去\n\n验收：能发给朋友玩的链接。',
          ),
        ],
      );

  // ── 写操作（全部 notifyListeners）──

  void addLearner(Learner learner) {
    learners.add(learner);
    notifyListeners();
  }

  void addRecord(LearningRecord record) {
    records.add(record);
    notifyListeners();
  }

  void addReview(Review review) {
    reviews.add(review);
    notifyListeners();
  }

  void addScaffold(ScaffoldItem item) {
    scaffolds.add(item);
    notifyListeners();
  }

  void addRevision(Revision revision) {
    revisions.add(revision);
    notifyListeners();
  }

  void addDelivery(Delivery delivery) {
    deliveries.add(delivery);
    notifyListeners();
  }

  /// 按 id 替换班级状态（字段编辑的落点）；找不到返回 false。
  bool updateCohort(CohortState next) {
    final i = cohorts.indexWhere((c) => c.id == next.id);
    if (i < 0) return false;
    cohorts[i] = next;
    notifyListeners();
    return true;
  }

  /// 班级状态迁移（只进不退）；非法或找不到返回 false。
  bool transitionCohort(String id, CohortPhase to) {
    final i = cohorts.indexWhere((c) => c.id == id);
    if (i < 0) return false;
    final next = cohorts[i].transitionTo(to);
    if (next == null) return false;
    cohorts[i] = next;
    notifyListeners();
    return true;
  }

  /// 修订预筛：走 [DiffPreFilter] 缝（默认桩），通过后进「已预筛」。
  Future<bool> prefilterRevision(String id, {DiffPreFilter? filter}) async {
    final i = revisions.indexWhere((r) => r.id == id);
    if (i < 0) return false;
    final opinion = await (filter ?? EchoDiffPreFilter()).prefilter(revisions[i]);
    final next = revisions[i].transitionTo(RevisionStatus.prefilered);
    if (next == null) return false;
    revisions[i] = Revision(
      id: next.id,
      taskId: next.taskId,
      title: next.title,
      content: opinion,
      before: next.before,
      after: next.after,
      status: next.status,
    );
    notifyListeners();
    return true;
  }

  /// 修订合稿：已预筛 → 已合稿（回灌仓内文件只留缝，v0.2.0 不实现）。
  bool mergeRevision(String id) {
    final i = revisions.indexWhere((r) => r.id == id);
    if (i < 0) return false;
    final next = revisions[i].transitionTo(RevisionStatus.merged);
    if (next == null) return false;
    revisions[i] = next;
    notifyListeners();
    return true;
  }

  /// 按 id 替换创作空间三件与脚手架（编辑的落点）；找不到则忽略。
  void replaceAssignment(Assignment v) {
    final i = assignments.indexWhere((e) => e.id == v.id);
    if (i >= 0) {
      assignments[i] = v;
      notifyListeners();
    }
  }

  void replaceSolution(Solution v) {
    final i = solutions.indexWhere((e) => e.id == v.id);
    if (i >= 0) {
      solutions[i] = v;
      notifyListeners();
    }
  }

  void replaceSolutionStep(SolutionStep v) {
    final i = steps.indexWhere((e) => e.id == v.id);
    if (i >= 0) {
      steps[i] = v;
      notifyListeners();
    }
  }

  void replaceScaffold(ScaffoldItem v) {
    final i = scaffolds.indexWhere((e) => e.id == v.id);
    if (i >= 0) {
      scaffolds[i] = v;
      notifyListeners();
    }
  }

  // ── 账读数（两本账的数据面）──

  Learner? learnerById(String id) {
    for (final l in learners) {
      if (l.id == id) return l;
    }
    return null;
  }

  List<LearningRecord> recordsOf(String learnerId) =>
      records.where((r) => r.learnerId == learnerId).toList();

  /// 活跃账：学员的记录提交数。
  int recordCountOf(String learnerId) => recordsOf(learnerId).length;

  /// 交付账：学员的交付件数。
  int deliveryCountOf(String learnerId) =>
      deliveries.where((d) => d.learnerId == learnerId).length;

  /// 交付账：按任务汇总的交付件数。
  Map<String, int> deliveriesByTask() {
    final out = <String, int>{};
    for (final d in deliveries) {
      out[d.taskId] = (out[d.taskId] ?? 0) + 1;
    }
    return out;
  }

  /// 最近一次提交时间（epoch 毫秒），无记录返回 0。
  int lastSubmittedAt(String learnerId) {
    var latest = 0;
    for (final r in recordsOf(learnerId)) {
      if (r.submittedAt > latest) latest = r.submittedAt;
    }
    return latest;
  }
}
