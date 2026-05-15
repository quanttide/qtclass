import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../services/app_state.dart';

class ClassroomScreen extends StatelessWidget {
  final String sessionId;

  const ClassroomScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final session = state.sessions.firstWhere((s) => s.id == sessionId);
        final isInProgress = session.status == SessionStatus.inProgress;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.lessonTitle, style: const TextStyle(fontSize: 16)),
                Text('${session.courseName} · ${session.className}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          body: isInProgress ? _InSessionView(session: session) : _ReviewView(session: session),
        );
      },
    );
  }
}

class _InSessionView extends StatelessWidget {
  final Session session;

  const _InSessionView({required this.session});

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress(session);

    return Column(
      children: [
        _ProgressBar(progress: progress),
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 3, child: _ContentArea(session: session)),
              _StudentSidebar(session: session),
            ],
          ),
        ),
        _Toolbar(session: session),
      ],
    );
  }

  double _calculateProgress(Session session) {
    final now = DateTime.now();
    final elapsed = now.difference(session.startTime).inMinutes.toDouble();
    return (elapsed / session.durationMinutes).clamp(0.0, 1.0);
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(value: progress, minHeight: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(progress * 100).toInt()}% 完成'),
              Text('${DateTime.now().hour.toString().padLeft(2, '0')}:00'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentArea extends StatelessWidget {
  final Session session;

  const _ContentArea({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.slideshow, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('课件展示区', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(session.lessonTitle, style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}

class _StudentSidebar extends StatelessWidget {
  final Session session;

  const _StudentSidebar({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, size: 16),
                const SizedBox(width: 4),
                Text('学员 (${session.students.length})',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: session.students.map((s) => _StudentTile(student: s)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final Student student;

  const _StudentTile({required this.student});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Widget? trailing;
    switch (student.attendance) {
      case AttendanceStatus.present:
        bgColor = Colors.green.shade50;
        trailing = const Icon(Icons.check_circle, color: Colors.green, size: 18);
      case AttendanceStatus.late:
        bgColor = Colors.orange.shade50;
        trailing = const Icon(Icons.access_time, color: Colors.orange, size: 18);
      case AttendanceStatus.absent:
        bgColor = Colors.red.shade50;
        trailing = const Icon(Icons.cancel, color: Colors.red, size: 18);
      case AttendanceStatus.unknown:
        bgColor = Colors.transparent;
        trailing = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: bgColor,
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            child: Text(student.name[0], style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(student.name, style: const TextStyle(fontSize: 13))),
          ?trailing,
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final Session session;

  const _Toolbar({required this.session});

  void _showAttendanceMenu(BuildContext context) {
    final state = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('出勤标记', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('全部正常'),
              onTap: () {
                state.markAllAttendance(session.id, AttendanceStatus.present);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.orange),
              title: const Text('全部迟到'),
              onTap: () {
                state.markAllAttendance(session.id, AttendanceStatus.late);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('全部缺勤'),
              onTap: () {
                state.markAllAttendance(session.id, AttendanceStatus.absent);
                Navigator.pop(ctx);
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('点击学员列表中头像可单独标记', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _ToolbarButton(
            icon: Icons.edit_note,
            label: '出勤',
            onTap: () => _showAttendanceMenu(context),
          ),
          const SizedBox(width: 16),
          _ToolbarButton(
            icon: Icons.question_answer,
            label: '提问',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('提问功能开发中')),
              );
            },
          ),
          const SizedBox(width: 16),
          _ToolbarButton(
            icon: Icons.poll,
            label: '投票',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('投票功能开发中')),
              );
            },
          ),
          const SizedBox(width: 16),
          _ToolbarButton(
            icon: Icons.notes,
            label: '备注',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('备注功能开发中')),
              );
            },
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('结束课程'),
                  content: const Text('确认结束本节课吗？'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('下课')),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.stop),
            label: const Text('下课'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolbarButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ReviewView extends StatelessWidget {
  final Session session;

  const _ReviewView({required this.session});

  @override
  Widget build(BuildContext context) {
    final present = session.students.where((s) => s.attendance == AttendanceStatus.present).length;
    final late = session.students.where((s) => s.attendance == AttendanceStatus.late).length;
    final absent = session.students.where((s) => s.attendance == AttendanceStatus.absent).length;
    final unknown = session.students.where((s) => s.attendance == AttendanceStatus.unknown).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.lessonTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${session.courseName} · ${session.className}'),
                Text('授课教师: ${session.teacher.name}'),
                Text('${session.startTime.year}-${session.startTime.month.toString().padLeft(2, '0')}-${session.startTime.day.toString().padLeft(2, '0')} · ${session.location}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('出勤统计', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(label: '应到', count: session.students.length, color: Colors.grey),
                    _StatItem(label: '正常', count: present, color: Colors.green),
                    _StatItem(label: '迟到', count: late, color: Colors.orange),
                    _StatItem(label: '缺勤', count: absent, color: Colors.red),
                    _StatItem(label: '未记', count: unknown, color: Colors.grey.shade400),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('学员列表', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                ...session.students.map((s) {
                  final statusLabel = switch (s.attendance) {
                    AttendanceStatus.present => '正常',
                    AttendanceStatus.late => '迟到',
                    AttendanceStatus.absent => '缺勤',
                    AttendanceStatus.unknown => '未记',
                  };
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(child: Text(s.name[0])),
                    title: Text(s.name),
                    trailing: Chip(label: Text(statusLabel, style: const TextStyle(fontSize: 12))),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatItem({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
