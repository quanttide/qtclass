import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../services/player_state.dart';

/// 视频场景 — 片段关联视频时全区域播放
///
/// 与 [PlayerState] 联动：播放/暂停同步；视频结束时触发片段结束。
/// 平台不支持 video_player 时（如 Linux 桌面）降级显示提示。
class VideoScene extends StatefulWidget {
  final String assetPath;
  final PlayerState state;

  const VideoScene({super.key, required this.assetPath, required this.state});

  @override
  State<VideoScene> createState() => _VideoSceneState();
}

class _VideoSceneState extends State<VideoScene> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void didUpdateWidget(VideoScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _disposeVideo();
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    debugPrint('VIDEO: init start ${widget.assetPath}');
    final controller = VideoPlayerController.asset(widget.assetPath);
    try {
      await controller.initialize().timeout(const Duration(seconds: 30));
      if (!mounted) {
        await controller.dispose();
        return;
      }
      debugPrint('VIDEO: init ok duration=${controller.value.duration}');
      setState(() => _controller = controller);
      // 同步视频实际时长到播放器状态
      final duration = controller.value.duration.inMilliseconds / 1000;
      widget.state.setDurationOverride(duration);
      if (widget.state.playing) controller.play();
      controller.addListener(_onVideoTick);
    } catch (e) {
      debugPrint('VIDEO: init FAILED: $e');
      await controller.dispose();
      if (mounted) {
        setState(() {
          _failed = true;
          _controller = null;
        });
      }
    }
  }

  void _onVideoTick() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isCompleted && !widget.state.finished) {
      widget.state.seek(1.0); // 视频播放完 → 触发片段结束
    }
  }

  void _syncPlayback() {
    final controller = _controller;
    if (controller == null) return;
    if (widget.state.playing && !controller.value.isPlaying) {
      controller.play();
    } else if (!widget.state.playing && controller.value.isPlaying) {
      controller.pause();
    }
  }

  void _disposeVideo() {
    _controller?.removeListener(_onVideoTick);
    _controller?.dispose();
    _controller = null;
    // 不在此通知：dispose 期间 notifyListeners 会触发 markNeedsBuild 异常；
    // 片段切换时 PlayerState.setActiveSegment 已清除动态时长
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 播放状态联动
    widget.state.addListener(_syncPlayback);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPlayback());

    if (_failed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.videocam_off,
              size: 40,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 12),
            const Text(
              '当前平台暂不支持视频播放，请在 Web 端查看课时视频。',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: VideoPlayer(controller),
      ),
    );
  }
}
