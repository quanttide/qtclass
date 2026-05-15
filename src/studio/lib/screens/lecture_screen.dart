import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../models/lecture.dart';
import '../services/app_state.dart';

class LectureScreen extends StatelessWidget {
  final String sessionId;

  const LectureScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final session = state.sessions.firstWhere((s) => s.id == sessionId);
        final lecture = state.lectureForSession(sessionId);

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
          body: lecture == null
              ? const Center(child: Text('暂无课时数据'))
              : _LectureBody(session: session, lecture: lecture),
        );
      },
    );
  }
}

class _LectureBody extends StatelessWidget {
  final Session session;
  final Lecture lecture;

  const _LectureBody({required this.session, required this.lecture});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _PullquoteCard(description: lecture.description),
        const SizedBox(height: 12),
        _InfoCard(
          title: '目标用户',
          child: Text(lecture.target,
              style: const TextStyle(color: Colors.black87, height: 1.6)),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: '学习目标',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lecture.objectives
                .map((o) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: Colors.indigo)),
                          Expanded(child: Text(o, style: const TextStyle(height: 1.5))),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: '提纲',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(lecture.points.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('${i + 1}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo.shade700)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(lecture.points[i],
                          style: const TextStyle(height: 1.5)),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        _MetaFooter(lecture: lecture),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _PullquoteCard extends StatelessWidget {
  final String description;

  const _PullquoteCard({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('"',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade300,
                  height: 1)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(description,
                style: TextStyle(
                    color: Colors.grey.shade700, height: 1.7, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.indigo.shade400)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetaFooter extends StatelessWidget {
  final Lecture lecture;

  const _MetaFooter({required this.lecture});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _MetaChip(
            label: '时长 ${lecture.duration} 分钟',
            color: Colors.indigo,
          ),
          _MetaChip(
            label: '难度 ${lecture.level}',
            color: Colors.indigo,
          ),
          _MetaChip(
            label: lecture.format,
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final Color color;

  const _MetaChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w500)),
    );
  }
}
