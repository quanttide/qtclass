import 'package:flutter/material.dart';
import '../../services/player_state.dart';

/// 场景文字 — 播放舞台左侧的章节/标题/描述
class SceneText extends StatelessWidget {
  final String sceneKey;
  final PlayerState state;
  final ThemeData theme;

  const SceneText({
    super.key,
    required this.sceneKey,
    required this.state,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final data = _sceneTextData(sceneKey, state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.kicker != null)
          Text(
            data.kicker!,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        if (data.kicker != null) const SizedBox(height: 12),
        Text(
          data.title,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.14,
            letterSpacing: -0.3,
          ),
        ),
        if (data.desc != null) ...[
          const SizedBox(height: 18),
          Text(
            data.desc!,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.8,
              fontSize: 15,
            ),
          ),
        ],
      ],
    );
  }

  _SceneTextData _sceneTextData(String key, PlayerState state) {
    final seg = state.currentSegment;
    if (seg == null) return const _SceneTextData(title: '');
    return _SceneTextData(
      kicker: seg.chapter,
      title: seg.title.isNotEmpty ? seg.title : seg.caption,
      desc: seg.caption,
    );
  }
}

class _SceneTextData {
  final String? kicker;
  final String title;
  final String? desc;

  const _SceneTextData({this.kicker, required this.title, this.desc});
}
