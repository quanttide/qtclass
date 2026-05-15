import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import 'classroom_screen.dart';
import 'lecture_screen.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('加载失败: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => state.loadAll(), child: const Text('重试')),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('量潮课堂')),
          body: ListView(
            children: [
              if (state.inProgressSessions.isNotEmpty) ...[
                _sectionHeader(context, '正在上课'),
                ...state.inProgressSessions.map((s) => _SessionCard(session: s, isHighlighted: true)),
              ],
              if (state.upcomingSessions.isNotEmpty) ...[
                _sectionHeader(context, '即将开始'),
                ...state.upcomingSessions.map((s) => _SessionCard(session: s)),
              ],
              if (state.completedSessions.isNotEmpty) ...[
                _sectionHeader(context, '历史课程'),
                ...state.completedSessions.map((s) => _SessionCard(session: s)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Session session;
  final bool isHighlighted;

  const _SessionCard({required this.session, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    final timeStr = '${session.startTime.hour.toString().padLeft(2, '0')}:${session.startTime.minute.toString().padLeft(2, '0')}';
    final isInProgress = session.status == SessionStatus.inProgress;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isHighlighted ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isInProgress ? Colors.green : Colors.grey.shade300,
          child: Icon(
            isInProgress ? Icons.play_arrow : Icons.check,
            color: Colors.white,
          ),
        ),
        title: Text(session.lessonTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${session.courseName} · ${session.className}\n$timeStr · ${session.location}'),
        isThreeLine: true,
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LectureScreen(sessionId: session.id)),
                  );
                },
                child: const Text('查看课时'),
              ),
              if (isInProgress)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ClassroomScreen(sessionId: session.id)),
                    );
                  },
                  child: const Text('进入课堂'),
                ),
            ],
          ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ClassroomScreen(sessionId: session.id)),
          );
        },
      ),
    );
  }
}
