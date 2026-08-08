import 'package:flutter/material.dart';
import '../../models/choice_option.dart';

/// 互动选项卡片 — 互动弹层中的单个选项
class OptionCard extends StatelessWidget {
  final ChoiceOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    option.symbol,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                option.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                option.note,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
