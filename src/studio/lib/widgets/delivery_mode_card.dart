import 'package:flutter/material.dart';
import '../models/models.dart';

class DeliveryModeCard extends StatelessWidget {
  final DeliveryMode mode;

  const DeliveryModeCard({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _iconForCategory(mode.category),
        title: Text(mode.category.label),
        subtitle: Text(
          '${mode.category.description}\n'
          '最大人数: ${mode.maxStudents} | 计费: ${mode.billingMethod}',
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _iconForCategory(DeliveryModeCategory category) {
    IconData icon;
    switch (category) {
      case DeliveryModeCategory.schoolEnterpriseCoop:
        icon = Icons.school;
      case DeliveryModeCategory.trainingBase:
        icon = Icons.workspaces;
      case DeliveryModeCategory.internalTeaching:
        icon = Icons.business;
      case DeliveryModeCategory.oneOnOne:
        icon = Icons.person;
    }
    return Icon(icon, size: 32);
  }
}
