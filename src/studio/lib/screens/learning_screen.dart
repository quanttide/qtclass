import 'package:flutter/material.dart';

import '../services/auth_api.dart';
import '../services/learn_api.dart';
import 'login_screen.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key, this.api});

  final LearnApi? api;

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  late final LearnApi _api = widget.api ?? LearnApi();
  List<LearningSchedule>? _schedules;
  List<LearningTask>? _tasks;
  Set<String> _completedTaskIds = {};
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        _api.fetchSchedules(),
        _api.fetchTasks(),
        _api.fetchCompletions(),
      ]);
      if (!mounted) return;
      final completions = results[2] as List<LearningCompletion>;
      setState(() {
        _schedules = results[0] as List<LearningSchedule>;
        _tasks = results[1] as List<LearningTask>;
        _completedTaskIds = {
          for (final completion in completions)
            if (completion.status == 'completed') completion.taskId,
        };
        _error = null;
      });
    } catch (_) {
      if (mounted) setState(() => _error = '学习数据加载失败，请稍后重试');
    }
  }

  Future<void> _complete(String taskId) async {
    if (!await AuthApi.hasToken()) {
      if (!mounted) return;
      final loggedIn = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      if (loggedIn != true) return;
    }
    setState(() => _saving = true);
    try {
      await _api.completeTask(taskId);
      if (!mounted) return;
      setState(() => _completedTaskIds = {..._completedTaskIds, taskId});
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('标记完成失败')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schedules = _schedules;
    final tasks = _tasks;
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习'),
        leading: IconButton(
          tooltip: '返回',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _load, child: const Text('重试')),
                ],
              ),
            )
          : schedules == null || tasks == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('训练营', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                for (final schedule in schedules)
                  _SchedulePanel(
                    schedule: schedule,
                    completedTaskIds: _completedTaskIds,
                    saving: _saving,
                    onComplete: _complete,
                  ),
                const SizedBox(height: 24),
                Text('全部任务', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                for (final task in tasks)
                  _TaskTile(
                    task: task,
                    completed: _completedTaskIds.contains(task.id),
                    saving: _saving,
                    onComplete: () => _complete(task.id),
                  ),
              ],
            ),
    );
  }
}

class _SchedulePanel extends StatelessWidget {
  const _SchedulePanel({
    required this.schedule,
    required this.completedTaskIds,
    required this.saving,
    required this.onComplete,
  });

  final LearningSchedule schedule;
  final Set<String> completedTaskIds;
  final bool saving;
  final Future<void> Function(String taskId) onComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(schedule.title),
        subtitle: Text(schedule.description),
        children: [
          for (final task in schedule.tasks)
            _TaskTile(
              task: task,
              completed: completedTaskIds.contains(task.id),
              saving: saving,
              onComplete: () => onComplete(task.id),
            ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.completed,
    required this.saving,
    required this.onComplete,
  });

  final LearningTask task;
  final bool completed;
  final bool saving;
  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: completed
          ? const Chip(label: Text('已完成'))
          : FilledButton.icon(
              onPressed: saving ? null : onComplete,
              icon: const Icon(Icons.check, size: 18),
              label: const Text('标记完成'),
            ),
    );
  }
}
