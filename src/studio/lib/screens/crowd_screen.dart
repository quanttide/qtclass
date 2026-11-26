import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/management_store.dart';

/// 众包 — 实践项目和任务：项目清单（对齐 lite 任务书）与交付读数。
class CrowdScreen extends StatelessWidget {
  const CrowdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    final theme = Theme.of(context);
    final byTask = store.deliveriesByTask();

    return Scaffold(
      appBar: AppBar(title: const Text('众包')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('只读投影 · 自己与 B端/G端同一页', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Text('实践项目', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          if (store.tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('还没有实践项目'),
            )
          else
            for (final t in store.tasks)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(t.title),
                subtitle: Text(t.id),
                trailing: Text('${byTask[t.id] ?? 0} 件'),
              ),
          const Divider(),
          Text('任务交付', style: theme.textTheme.titleMedium),
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
                subtitle: Text(l.cohort),
                trailing: Text('${store.deliveryCountOf(l.id)} 件'),
              ),
        ],
      ),
    );
  }
}
