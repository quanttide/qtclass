import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/management_store.dart';

/// 两本账 — 活跃（学习记录提交）与交付（任务交付情况），只读。
///
/// 自己与 B/G 端看同一页：投影是同一批对象的读数，不另起目录、不设编辑口。
class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  String _fmtDate(int ms) {
    if (ms == 0) return '从未';
    final d = DateTime.fromMillisecondsSinceEpoch(ms).toLocal();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    final theme = Theme.of(context);
    final byTask = store.deliveriesByTask();
    final tasks = byTask.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('两本账')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('只读投影 · 自己与 B端/G端同一页', style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          Text('活跃账 · 学习记录提交', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          if (store.learners.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('没有学员'),
            )
          else
            for (final l in store.learners)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.title),
                subtitle: Text('${l.cohort} · 最近提交 ${_fmtDate(store.lastSubmittedAt(l.id))}'),
                trailing: Text('${store.recordCountOf(l.id)} 篇'),
              ),
          const Divider(),
          Text('交付账 · 任务交付情况', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('还没有交付'),
            )
          else
            for (final t in tasks)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(t),
                trailing: Text('${byTask[t]} 件'),
              ),
        ],
      ),
    );
  }
}
