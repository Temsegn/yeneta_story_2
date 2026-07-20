import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/core/widgets/content_network_image.dart';
import 'package:kids_app/features/shell/presentation/providers/shell_providers.dart';
import 'package:kids_app/features/video/domain/entities/video_entity.dart';
import 'package:kids_app/features/video/presentation/viewmodel/video_list_viewmodel.dart';
import 'package:video_player/video_player.dart';

/// Full-screen player for videos opened from Home / Video tabs.
class VideoPlayerOverlay extends ConsumerStatefulWidget {
  const VideoPlayerOverlay({super.key});

  @override
  ConsumerState<VideoPlayerOverlay> createState() => _VideoPlayerOverlayState();
}

class _VideoPlayerOverlayState extends ConsumerState<VideoPlayerOverlay> {
  VideoPlayerController? _controller;
  String? _loadedUrl;
  String? _activeVideoId;
  bool _ready = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _showControls = true;

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _disposeController() {
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    _controller = null;
    _loadedUrl = null;
    _ready = false;
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  Future<void> _openVideo(VideoEntity video) async {
    final url = (video.videoUrl ?? '').trim();
    if (url.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'This video has no playable URL.';
        _ready = false;
      });
      return;
    }
    if (_loadedUrl == url && _controller != null) return;

    _disposeController();
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _ready = false;
      _showControls = true;
    });

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _controller = controller;
      _loadedUrl = url;
      controller.addListener(_onTick);
      await controller.initialize();
      await controller.play();
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'Could not play this video.';
        _ready = false;
      });
    }
  }

  void _close() {
    _disposeController();
    _activeVideoId = null;
    ref.read(isPlayerOpenProvider.notifier).state = false;
    ref.read(selectedVideoProvider.notifier).state = null;
  }

  void _togglePlay() {
    final c = _controller;
    if (c == null || !_ready) return;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
    }
    setState(() => _showControls = true);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(1, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ref.watch(isPlayerOpenProvider);
    final selected = ref.watch(selectedVideoProvider);
    final listAsync = ref.watch(videoListViewModelProvider);

    if (!isOpen) {
      if (_controller != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _disposeController();
        });
      }
      return const SizedBox.shrink();
    }

    VideoEntity? video;
    if (selected is VideoEntity) {
      video = selected;
    } else {
      final list = listAsync.valueOrNull ?? const <VideoEntity>[];
      if (list.isNotEmpty) video = list.first;
    }

    if (video == null) return const SizedBox.shrink();

    // Kick off / switch playback when selection changes.
    if (_activeVideoId != video.id) {
      _activeVideoId = video.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openVideo(video!);
      });
    }

    final safe = MediaQuery.viewPaddingOf(context);
    final c = _controller;
    final position = c?.value.position ?? Duration.zero;
    final duration = c?.value.duration ?? Duration.zero;
    final progress = duration.inMilliseconds == 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    final playing = c?.value.isPlaying ?? false;

    return Material(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Poster while loading / on error
          if (!_ready || _hasError)
            ContentNetworkImage(url: video.thumbnail),

          if (_ready && c != null && c.value.isInitialized)
            GestureDetector(
              onTap: () => setState(() => _showControls = !_showControls),
              child: Center(
                child: AspectRatio(
                  aspectRatio: c.value.aspectRatio == 0
                      ? 16 / 9
                      : c.value.aspectRatio,
                  child: VideoPlayer(c),
                ),
              ),
            ),

          if (!_ready && !_hasError)
            const Center(
              child: CircularProgressIndicator(color: AppColors.orange500),
            ),

          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),

          // Top bar: back + title
          if (_showControls || !_ready || _hasError)
            Positioned(
              top: 16 + safe.top,
              left: 16 + safe.left,
              right: 16 + safe.right,
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _close,
                      borderRadius: BorderRadius.circular(28),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Bottom controls
          if (_ready && _showControls && !_hasError)
            Positioned(
              left: 16 + safe.left,
              right: 16 + safe.right,
              bottom: 24 + safe.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _togglePlay,
                        icon: Icon(
                          playing
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                            activeTrackColor: AppColors.orange400,
                            inactiveTrackColor:
                                Colors.white.withValues(alpha: 0.3),
                            thumbColor: Colors.white,
                          ),
                          child: Slider(
                            value: progress,
                            onChanged: (v) {
                              final c2 = _controller;
                              if (c2 == null || duration.inMilliseconds == 0) {
                                return;
                              }
                              final target = Duration(
                                milliseconds:
                                    (v * duration.inMilliseconds).round(),
                              );
                              c2.seekTo(target);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
