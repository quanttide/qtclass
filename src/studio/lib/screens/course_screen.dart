import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/assignment.dart';
import '../models/revision.dart';
import '../models/scaffold_item.dart';
import '../models/solution.dart';
import '../models/solution_step.dart';
import '../services/management_store.dart';

/// 课程 — 设计和上架课程：三件模型（题目 / 参考答案 / 步骤单元）的编辑与浏览，
/// 外加脚手架与修订（上架前的预筛与合稿留缝）。
class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('课程')),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: '题目'),
                Tab(text: '参考答案'),
                Tab(text: '步骤单元'),
                Tab(text: '脚手架'),
                Tab(text: '修订'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _AssignmentsTab(),
                  _SolutionsTab(),
                  _StepsTab(),
                  _ScaffoldsTab(),
                  _RevisionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 通用编辑页：标题 + 正文，保存回 store（按 id 替换）。
class EntityEditor extends StatefulWidget {
  final String title;
  final String initialTitle;
  final String initialContent;
  final void Function(String title, String content) onSave;

  const EntityEditor({
    super.key,
    required this.title,
    required this.initialTitle,
    required this.initialContent,
    required this.onSave,
  });

  @override
  State<EntityEditor> createState() => _EntityEditorState();
}

class _EntityEditorState extends State<EntityEditor> {
  late final TextEditingController _title;
  late final TextEditingController _content;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.initialTitle);
    _content = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave(_title.text.trim(), _content.text);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: '标题'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _content,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: '正文（Markdown）',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 题目 ──

class _AssignmentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    if (store.assignments.isEmpty) return const Center(child: Text('还没有题目'));
    return ListView(
      children: [
        for (final a in store.assignments)
          ListTile(
            title: Text(a.title),
            subtitle: Text(a.content, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EntityEditor(
                  title: '编辑题目',
                  initialTitle: a.title,
                  initialContent: a.content,
                  onSave: (t, c) => store.replaceAssignment(
                    Assignment(id: a.id, title: t, content: c),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── 参考答案 ──

class _SolutionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    if (store.solutions.isEmpty) return const Center(child: Text('还没有参考答案'));
    return ListView(
      children: [
        for (final s in store.solutions)
          ListTile(
            title: Text(s.title),
            subtitle: Text(s.content, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EntityEditor(
                  title: '编辑参考答案',
                  initialTitle: s.title,
                  initialContent: s.content,
                  onSave: (t, c) => store.replaceSolution(
                    Solution(id: s.id, title: t, content: c),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── 步骤单元 ──

class _StepsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    if (store.steps.isEmpty) return const Center(child: Text('还没有步骤单元'));
    return ListView(
      children: [
        for (final st in store.steps)
          ListTile(
            title: Text(st.title),
            subtitle: Text(
              st.after.isEmpty ? '入口（无前置）' : '前置：${st.after.join('、')}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EntityEditor(
                  title: '编辑步骤单元',
                  initialTitle: st.title,
                  initialContent: st.content,
                  onSave: (t, c) => store.replaceSolutionStep(
                    SolutionStep(id: st.id, title: t, content: c, after: st.after),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── 脚手架 ──

class _ScaffoldsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () => _showAddScaffoldDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('新增脚手架'),
          ),
        ),
        Expanded(
          child: store.scaffolds.isEmpty
              ? const Center(child: Text('脚手架库是空的'))
              : ListView(
                  children: [
                    for (final s in store.scaffolds)
                      ListTile(
                        title: Text(s.title),
                        subtitle: Text(s.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Chip(label: Text(s.kind.label)),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EntityEditor(
                              title: '编辑脚手架',
                              initialTitle: s.title,
                              initialContent: s.content,
                              onSave: (t, c) => store.replaceScaffold(
                                ScaffoldItem(id: s.id, title: t, content: c, kind: s.kind),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

Future<void> _showAddScaffoldDialog(BuildContext context) async {
  final store = context.read<ManagementStore>();
  var title = '';
  var content = '';
  var kind = ScaffoldKind.pitfall;
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('新增脚手架'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ScaffoldKind>(
                initialValue: kind,
                decoration: const InputDecoration(labelText: '分类'),
                items: [
                  for (final k in ScaffoldKind.values)
                    DropdownMenuItem(value: k, child: Text(k.label)),
                ],
                onChanged: (v) => setState(() => kind = v ?? kind),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(labelText: '标题'),
                onChanged: (v) => title = v,
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 4,
                decoration: const InputDecoration(labelText: '正文'),
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
  if (saved == true && title.trim().isNotEmpty) {
    store.addScaffold(ScaffoldItem(
      id: generateId(),
      title: title.trim(),
      content: content,
      kind: kind,
    ));
  }
}

// ── 修订 ──

class _RevisionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<ManagementStore>();
    if (store.revisions.isEmpty) return const Center(child: Text('没有修订'));
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final r in store.revisions)
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
                        child: Text(r.title, style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Chip(label: Text(r.status.label)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(r.content, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    '任务 ${r.taskId} · before ${r.before.length}B → after ${r.after.length}B',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (r.status == RevisionStatus.draft)
                        FilledButton.tonal(
                          onPressed: () async {
                            await store.prefilterRevision(r.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('已过预筛缝（桩）')),
                              );
                            }
                          },
                          child: const Text('AI 预筛'),
                        ),
                      if (r.status == RevisionStatus.prefilered) ...[
                        FilledButton(
                          onPressed: () => store.mergeRevision(r.id),
                          child: const Text('合稿（留缝）'),
                        ),
                        const SizedBox(width: 8),
                        const Text('回灌仓内文件的通道 v0.2.0 只留缝'),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
