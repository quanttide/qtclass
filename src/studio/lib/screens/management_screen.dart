import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cohort_state.dart';
import '../models/learner.dart';
import '../models/learning_record.dart';
import '../models/review.dart';
import '../services/management_store.dart';

/// 教学管理 — 名册 / 学习记录 / 评审 / 班级状态台（v0.2.0 管理界面）。
///
/// 只有管理者这一个操作面；学员交互全部在 lite，本页不设学员入口。
class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('教学管理')),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: '名册'),
                Tab(text: '学习记录'),
                Tab(text: '评审'),
                Tab(text: '班级状态台'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_RosterTab(), _RecordsTab(), _ReviewsTab(), _CohortTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _fmtDate(int ms) {
  if (ms == 0) return '—';
  final d = DateTime.fromMillisecondsSinceEpoch(ms).toLocal();
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ── 名册 ──

class _RosterTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () => _showAddLearnerDialog(context),
            icon: const Icon(Icons.person_add),
            label: const Text('录入学员'),
          ),
        ),
        Expanded(
          child: store.learners.isEmpty
              ? const Center(child: Text('还没有学员'))
              : ListView(
                  children: [
                    for (final l in store.learners)
                      ListTile(
                        title: Text(l.title),
                        subtitle: Text('${l.cohort} · ${l.level.label}'),
                        trailing: Chip(label: Text(l.status.label)),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

Future<void> _showAddLearnerDialog(BuildContext context) async {
  final store = context.read<ManagementStore>();
  var name = '';
  var cohort = 'AI编程';
  var level = LearnerLevel.none;
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('录入学员'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: '学员展示名'),
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: cohort,
              decoration: const InputDecoration(labelText: '班级'),
              items: const [
                DropdownMenuItem(value: 'AI编程', child: Text('AI编程')),
                DropdownMenuItem(value: 'AI创意', child: Text('AI创意')),
                DropdownMenuItem(value: 'AI办公', child: Text('AI办公')),
              ],
              onChanged: (v) => setState(() => cohort = v ?? cohort),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<LearnerLevel>(
              initialValue: level,
              decoration: const InputDecoration(labelText: '参与度'),
              items: [
                for (final lv in LearnerLevel.values)
                  DropdownMenuItem(value: lv, child: Text(lv.label)),
              ],
              onChanged: (v) => setState(() => level = v ?? level),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('保存'),
          ),
        ],
      ),
    ),
  );
  if (saved == true && name.trim().isNotEmpty) {
    store.addLearner(Learner(
      id: generateId(),
      title: name.trim(),
      cohort: cohort,
      level: level,
    ));
  }
}

// ── 学习记录 ──

class _RecordsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () => _showAddRecordDialog(context),
            icon: const Icon(Icons.edit_note),
            label: const Text('录入记录'),
          ),
        ),
        Expanded(
          child: store.records.isEmpty
              ? const Center(child: Text('还没有学习记录'))
              : ListView(
                  children: [
                    for (final r in [...store.records].reversed)
                      ListTile(
                        title: Text(r.title),
                        subtitle: Text(
                          '${store.learnerById(r.learnerId)?.title ?? '未知学员'}'
                          ' · ${r.taskId} · ${_fmtDate(r.submittedAt)}',
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

Future<void> _showAddRecordDialog(BuildContext context) async {
  final store = context.read<ManagementStore>();
  var title = '';
  var taskId = '';
  var content = '';
  var learnerId = store.learners.isEmpty ? '' : store.learners.first.id;
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('录入学习记录'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '标题，如「第 2 周学习记录」'),
                onChanged: (v) => title = v,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: learnerId,
                decoration: const InputDecoration(labelText: '学员'),
                items: [
                  for (final l in store.learners)
                    DropdownMenuItem(value: l.id, child: Text(l.title)),
                ],
                onChanged: (v) => setState(() => learnerId = v ?? learnerId),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: '任务 id（lite task 标识）'),
                onChanged: (v) => taskId = v,
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: '四要素：做了什么 / 卡点 / 怎么解决 / 待完善',
                ),
                onChanged: (v) => content = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('保存'),
          ),
        ],
      ),
    ),
  );
  if (saved == true && title.trim().isNotEmpty && learnerId.isNotEmpty) {
    store.addRecord(LearningRecord(
      id: generateId(),
      title: title.trim(),
      content: content,
      learnerId: learnerId,
      taskId: taskId.trim(),
      submittedAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}

// ── 评审 ──

class _ReviewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: store.learners.isEmpty ? null : () => _showVerdictDialog(context),
            icon: const Icon(Icons.gavel),
            label: const Text('下结论'),
          ),
        ),
        Expanded(
          child: store.reviews.isEmpty
              ? const Center(child: Text('还没有评审结论'))
              : ListView(
                  children: [
                    for (final r in store.reviews)
                      ListTile(
                        title: Text(r.title),
                        subtitle: Text(
                          '${store.learnerById(r.learnerId)?.title ?? '未知学员'}'
                          ' · ${r.cohort} · ${_fmtDate(r.decidedAt)}',
                        ),
                        trailing: Chip(label: Text(r.verdict.label)),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

Future<void> _showVerdictDialog(BuildContext context) async {
  final store = context.read<ManagementStore>();
  var learnerId = store.learners.first.id;
  var verdict = ReviewVerdict.retained;
  var content = '';
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('评审结论（三分）'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: learnerId,
                decoration: const InputDecoration(labelText: '学员'),
                items: [
                  for (final l in store.learners)
                    DropdownMenuItem(value: l.id, child: Text(l.title)),
                ],
                onChanged: (v) => setState(() => learnerId = v ?? learnerId),
              ),
              const SizedBox(height: 8),
              RadioGroup<ReviewVerdict>(
                groupValue: verdict,
                onChanged: (val) => setState(() => verdict = val ?? verdict),
                child: Column(
                  children: [
                    for (final v in ReviewVerdict.values)
                      RadioListTile<ReviewVerdict>(
                        title: Text(v.label),
                        value: v,
                      ),
                  ],
                ),
              ),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(labelText: '依据说明'),
                onChanged: (v) => content = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('保存'),
          ),
        ],
      ),
    ),
  );
  if (saved == true) {
    final cohort = store.learnerById(learnerId)?.cohort ?? '';
    store.addReview(Review(
      id: generateId(),
      title: '一周考核',
      content: content,
      learnerId: learnerId,
      cohort: cohort,
      verdict: verdict,
      decidedAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}

// ── 班级状态台 ──

CohortPhase? _nextPhase(CohortPhase p) {
  const order = [CohortPhase.recruiting, CohortPhase.running, CohortPhase.closed];
  final i = order.indexOf(p);
  return (i >= 0 && i < order.length - 1) ? order[i + 1] : null;
}

class _CohortTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    if (store.cohorts.isEmpty) return const Center(child: Text('没有班级'));
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final c in store.cohorts)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${c.course} · ${c.name}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Chip(label: Text(c.phase.label)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _fieldRow('开班', c.start),
                  _fieldRow('限额', c.quota),
                  _fieldRow('报名窗口', c.window),
                  _fieldRow('报名条件', c.apply),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (_nextPhase(c.phase) != null)
                        FilledButton.tonal(
                          onPressed: () {
                            final ok = store.transitionCohort(c.id, _nextPhase(c.phase)!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ok ? '已迁移到「${_nextPhase(c.phase)!.label}」' : '迁移非法',
                                ),
                              ),
                            );
                          },
                          child: Text('下一步：${_nextPhase(c.phase)!.label}'),
                        ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _showEditCohortDialog(context, c),
                        child: const Text('编辑字段'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _fieldRow(String label, String? value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Expanded(child: Text(value ?? '—', style: const TextStyle(fontSize: 13))),
          ],
        ),
      );
}

Future<void> _showEditCohortDialog(BuildContext context, CohortState c) async {
  final store = context.read<ManagementStore>();
  var start = c.start ?? '';
  var quota = c.quota ?? '';
  var window = c.window ?? '';
  var apply = c.apply ?? '';
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('编辑字段 · ${c.course}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: start),
              decoration: const InputDecoration(labelText: '开班日期（无则留空）'),
              onChanged: (v) => start = v,
            ),
            TextField(
              controller: TextEditingController(text: quota),
              decoration: const InputDecoration(labelText: '限额（无则留空）'),
              onChanged: (v) => quota = v,
            ),
            TextField(
              controller: TextEditingController(text: window),
              decoration: const InputDecoration(labelText: '报名窗口（无则留空）'),
              onChanged: (v) => window = v,
            ),
            TextField(
              controller: TextEditingController(text: apply),
              decoration: const InputDecoration(labelText: '报名条件（无则留空）'),
              onChanged: (v) => apply = v,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('保存'),
        ),
      ],
    ),
  );
  if (saved == true) {
    store.updateCohort(CohortState(
      id: c.id,
      course: c.course,
      name: c.name,
      phase: c.phase,
      start: start.trim().isEmpty ? null : start.trim(),
      quota: quota.trim().isEmpty ? null : quota.trim(),
      window: window.trim().isEmpty ? null : window.trim(),
      apply: apply.trim().isEmpty ? null : apply.trim(),
    ));
  }
}
