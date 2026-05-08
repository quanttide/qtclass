import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/delivery_mode_card.dart';
import 'course_screen.dart';
import 'student_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('加载失败: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => state.loadAll(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('量潮课堂'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => state.loadAll(),
              ),
            ],
          ),
          body: ListView(
            children: [
              _buildSectionHeader(context, '交付模式', Icons.category),
              ...state.deliveryModes.map(
                (m) => DeliveryModeCard(mode: m),
              ),
              _buildSectionHeader(context, '课程', Icons.book),
              ...state.courses.map(
                (c) => _buildCourseTile(context, c),
              ),
              _buildSectionHeader(context, '学员概况', Icons.people),
              _buildStudentSummary(context, state),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: 0,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: '首页'),
              NavigationDestination(icon: Icon(Icons.book), label: '课程'),
              NavigationDestination(icon: Icon(Icons.people), label: '学员'),
            ],
            onDestinationSelected: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CourseScreen(),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentScreen(),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseTile(BuildContext context, Course course) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.book, size: 32),
        title: Text(course.title),
        subtitle: Text('${course.classes.length} 个开课班'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseScreen(initialCourseId: course.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentSummary(BuildContext context, AppState state) {
    final paidCount = state.students.where((s) => s.type == StudentType.paid).length;
    final vipCount = state.students.where((s) => s.type == StudentType.vip).length;
    final freeCount = state.students.where((s) => s.type == StudentType.free).length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('付费', paidCount, Colors.blue),
            _statItem('VIP', vipCount, Colors.amber),
            _statItem('免费', freeCount, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
