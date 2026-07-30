import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_state.dart';
import '../services/course_data.dart';
import '../models/choice_option.dart';

/// 互动覆盖层 — 决策节点弹层
///
/// 映射自 `doc/screens/player.md → 互动覆盖层 (Interaction Overlay)`。
class InteractionOverlay extends StatelessWidget {
  const InteractionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(
      builder: (context, state, _) {
        final type = state.interactionType;
        if (type == null) return const SizedBox.shrink();

        return Stack(
          children: [
            // 遮罩背景
            Container(color: Colors.black.withValues(alpha: 0.3)),
            // 互动卡片
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(34),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(34),
                      child: _InteractionCardContent(type: type),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InteractionCardContent extends StatelessWidget {
  final InteractionType type;

  const _InteractionCardContent({required this.type});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlayerState>();
    final theme = Theme.of(context);

    // 根据互动类型配置
    final config = _getConfig(type, state);
    final options = config.options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 顶栏
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '互动节点',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        // 标题
        Text(
          config.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
        // 描述
        Text(
          config.desc,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.7,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        // 选项网格
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: options.map((option) {
                final isSelected = state.selectedChoice == option.id;
                return SizedBox(
                  width: (constraints.maxWidth - 24) / 3,
                  child: _OptionCard(
                    option: option,
                    isSelected: isSelected,
                    onTap: () => context.read<PlayerState>().selectOption(option.id),
                  ),
                );
              }).toList(),
            );
          },
        ),
        // 反馈区域
        if (state.selectedChoice != null && _getFeedback(type, state.selectedChoice!).isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _getFeedback(type, state.selectedChoice!),
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.primary,
                  height: 1.65,
                ),
              ),
            ),
          ),
        const SizedBox(height: 18),
        // 确认按钮
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: state.selectedChoice != null
                ? () => context.read<PlayerState>().confirmChoice()
                : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
            ),
            child: const Text('进入对应内容'),
          ),
        ),
      ],
    );
  }

  _InteractionConfig _getConfig(InteractionType type, PlayerState state) {
    if (type == InteractionType.env) {
      return _InteractionConfig(
        title: '你准备在哪台电脑上运行 Python？',
        desc: '不同系统的操作入口不同。请选择你正在使用的设备，系统将展示对应的运行说明。',
        options: CourseData.environmentOptions,
      );
    } else {
      final available = CourseData.runStateOptions
          .where((o) => !state.triedRunStates.contains(o.id))
          .toList();
      return _InteractionConfig(
        title: '运行结果反馈',
        desc: '',
        options: available,
      );
    }
  }

  String _getFeedback(InteractionType type, String choiceId) {
    if (type == InteractionType.env) {
      return CourseData.environmentOptions
          .firstWhere((o) => o.id == choiceId)
          .feedback;
    } else {
      return CourseData.runStateOptions
          .firstWhere((o) => o.id == choiceId)
          .feedback;
    }
  }
}

class _InteractionConfig {
  final String title;
  final String desc;
  final List<ChoiceOption> options;

  const _InteractionConfig({
    required this.title,
    required this.desc,
    required this.options,
  });
}

class _OptionCard extends StatelessWidget {
  final ChoiceOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
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
