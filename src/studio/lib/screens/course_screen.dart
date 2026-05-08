import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';

class CourseScreen extends StatelessWidget {
  final String? initialCourseId;

  const CourseScreen({super.key, this.initialCourseId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('课程管理')),
          body: ListView(
            children: state.courses.map((course) {
              final isExpanded = course.id == initialCourseId;
              return _CourseExpansionTile(
                course: course,
                initiallyExpanded: isExpanded,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _CourseExpansionTile extends StatelessWidget {
  final Course course;
  final bool initiallyExpanded;

  const _CourseExpansionTile({
    required this.course,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: const Icon(Icons.book, size: 32),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(course.description),
        children: course.classes.map((cls) {
          return _ClassTile(classObj: cls);
        }).toList(),
      ),
    );
  }
}

class _ClassTile extends StatelessWidget {
  final Class classObj;

  const _ClassTile({required this.classObj});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final mode = state.deliveryModeById(classObj.deliveryModeId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(classObj.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('交付模式: ${mode?.category.label ?? "未知"}'),
          Text('时间: ${_formatDate(classObj.startDate)} - ${_formatDate(classObj.endDate)}'),
          const SizedBox(height: 8),
          const Text('课程安排:', style: TextStyle(fontWeight: FontWeight.w500)),
          ...classObj.lessons.map((lesson) => Padding(
            padding: const EdgeInsets.only(left: 16, top: 2),
            child: Text('• ${lesson.title} (${lesson.durationMinutes}分钟)'),
          )),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
