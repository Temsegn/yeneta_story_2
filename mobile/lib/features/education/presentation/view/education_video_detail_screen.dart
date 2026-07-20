import 'package:flutter/material.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/core/widgets/content_network_image.dart';
import 'package:kids_app/features/education/domain/entities/education_video_entity.dart';
import 'package:video_player/video_player.dart';

class EducationVideoDetailScreen extends StatefulWidget {
  final List<EducationVideoEntity> videos;
  final int initialIndex;
  final VoidCallback onBack;

  const EducationVideoDetailScreen({
    super.key,
    required this.videos,
    required this.initialIndex,
    required this.onBack,
  });

  @override
  State<EducationVideoDetailScreen> createState() =>
      _EducationVideoDetailScreenState();
}

class _EducationVideoDetailScreenState
    extends State<EducationVideoDetailScreen> {
  late int _currentIndex;
  VideoPlayerController? _controller;
  String? _loadedUrl;
  bool _ready = false;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.videos.length - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrent());
  }

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

  EducationVideoEntity get _video =>
      widget.videos[_currentIndex.clamp(0, widget.videos.length - 1)];

  Future<void> _loadCurrent() async {
    final url = _video.videoUrl.trim();
    if (url.isEmpty) {
      setState(() {
        _hasError = true;
        _ready = false;
      });
      return;
    }
    if (_loadedUrl == url && _controller != null) return;

    _disposeController();
    setState(() {
      _hasError = false;
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
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _ready = false;
      });
    }
  }

  void _togglePlay() {
    final c = _controller;
    if (c == null || !_ready) return;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
    }
    setState(() {});
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.videos.length) return;
    setState(() => _currentIndex = index);
    _loadCurrent();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videos.isEmpty) return const SizedBox.shrink();
    final video = _video;
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
      child: GestureDetector(
        onVerticalDragEnd: (d) {
          final dy = -d.velocity.pixelsPerSecond.dy;
          if (dy > 50) {
            _goTo(_currentIndex + 1);
          } else if (dy < -50) {
            _goTo(_currentIndex - 1);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!_ready || _hasError)
              ContentNetworkImage(url: video.thumbnail),
            if (_ready && c != null && c.value.isInitialized)
              GestureDetector(
                onTap: () => setState(() => _showControls = !_showControls),
                child: Center(
                  child: AspectRatio(
                    aspectRatio:
                        c.value.aspectRatio == 0 ? 16 / 9 : c.value.aspectRatio,
                    child: VideoPlayer(c),
                  ),
                ),
              ),
            if (!_ready && !_hasError)
              const Center(
                child: CircularProgressIndicator(color: AppColors.orange500),
              ),
            if (_hasError)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Could not play this video.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            if (_showControls || !_ready || _hasError)
              Positioned(
                top: 8 + safe.top,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onBack,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
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
            if (_ready && _showControls && !_hasError)
              Positioned(
                left: 16,
                right: 16,
                bottom: 24 + safe.bottom,
                child: Row(
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
                    Text(
                      _formatDuration(position),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                          activeTrackColor: AppColors.orange400,
                          inactiveTrackColor:
                              Colors.white.withValues(alpha: 0.3),
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: progress,
                          onChanged: (v) {
                            if (duration.inMilliseconds == 0) return;
                            _controller?.seekTo(
                              Duration(
                                milliseconds:
                                    (v * duration.inMilliseconds).round(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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
              ),
          ],
        ),
      ),
    );
  }
}
