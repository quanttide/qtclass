import 'package:flutter/material.dart';
import '../services/player_state.dart';
import 'package:provider/provider.dart';

/// 播放控制栏
///
/// 映射自 `doc/screens/player.md → 播放控制 (Player Controls)`。
class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(
      builder: (context, state, _) {
        final seg = state.currentSegment;
        final total = seg?.duration ?? 0;

        return Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 进度条
              _Timeline(state: state),
              const SizedBox(height: 11),
              // 控制行
              Row(
                children: [
                  _PlayButton(state: state),
                  const SizedBox(width: 13),
                  Text(
                    '${_formatTime(state.elapsed)} / ${_formatTime(total)}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: state.restartCurrentScene,
                    child: Text(
                      '重播当前片段',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 章节标签
                  Flexible(
                    child: Text(
                      seg?.chapter ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(double seconds) {
    final safe = (seconds < 0 ? 0 : seconds).floor();
    return '${(safe ~/ 60).toString().padLeft(2, '0')}:${(safe % 60).toString().padLeft(2, '0')}';
  }
}

class _Timeline extends StatelessWidget {
  final PlayerState state;

  const _Timeline({required this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _seek(context, details),
      onHorizontalDragUpdate: (details) => _seek(context, details),
      child: Container(
        height: 18,
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // 轨道
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                // 填充
                FractionallySizedBox(
                  widthFactor: state.finished ? 1 : state.progress,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                // 滑块
                Positioned(
                  left: (state.finished ? 1 : state.progress) * constraints.maxWidth - 6.5,
                  top: 2.5,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _seek(BuildContext context, dynamic details) {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.globalToLocal(details.localPosition);
    final ratio = (position.dx / renderBox.size.width).clamp(0.0, 1.0);
    context.read<PlayerState>().seek(ratio);
  }
}

class _PlayButton extends StatelessWidget {
  final PlayerState state;

  const _PlayButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final isPlaying = state.playing;

    return SizedBox(
      width: 38,
      height: 38,
      child: Material(
        shape: const CircleBorder(),
        color: Theme.of(context).colorScheme.surface,
        elevation: 0,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.read<PlayerState>().togglePlay(),
          child: Center(
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
