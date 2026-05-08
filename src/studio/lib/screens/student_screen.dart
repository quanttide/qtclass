import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('学员管理')),
          body: ListView(
            children: [
              _buildSummaryCard(state),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('学员列表',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ...state.students.map((s) => _StudentTile(student: s)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(AppState state) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('组织与合同', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...state.organizations.map((org) {
              final contracts = state.contracts
                  .where((c) => c.organizationId == org.id)
                  .toList();
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(org.type == 'university' ? Icons.school : Icons.business, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text('${org.name} (${contracts.length}份合同)')),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final Student student;

  const _StudentTile({required this.student});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final org = state.organizationById(student.organizationId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _colorForType(student.type),
          child: Text(student.name[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(student.name),
        subtitle: Text('${student.type.label} | ${org?.name ?? "未知机构"}'),
        trailing: Chip(
          label: Text(student.type.label, style: const TextStyle(fontSize: 12)),
          backgroundColor: _colorForType(student.type).withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Color _colorForType(StudentType type) {
    switch (type) {
      case StudentType.paid:
        return Colors.blue;
      case StudentType.vip:
        return Colors.amber;
      case StudentType.free:
        return Colors.green;
    }
  }
}
