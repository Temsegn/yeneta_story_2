import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/features/shell/presentation/providers/shell_providers.dart';
import 'package:kids_app/features/video/domain/entities/video_entity.dart';
import 'package:kids_app/features/video/domain/usecases/get_sample_videos_usecase.dart';
import 'package:kids_app/features/video/presentation/providers/video_providers.dart';

class VideoPlayerOverlay extends ConsumerStatefulWidget {
  const VideoPlayerOverlay({super.key});

  @override
  ConsumerState<VideoPlayerOverlay> createState() => _VideoPlayerOverlayState();
}

class _VideoPlayerOverlayState extends ConsumerState<VideoPlayerOverlay> {
  int _currentIndex = 0;
  double _progress = 0;
  bool _showGesture = true;
  List<VideoEntity> _videos = [];
  Timer? _progressTimer;
  Timer? _gestureTimer;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final useCase = ref.read(getSampleVideosUseCaseProvider);
    final list = await useCase();
    if (mounted) setState(() => _videos = list);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selected = ref.watch(selectedVideoProvider);
    final isOpen = ref.watch(isPlayerOpenProvider);
    if (selected is VideoEntity && _videos.isNotEmpty) {
      final idx = _videos.indexWhere((v) => v.id == selected.id);
      if (idx >= 0 && idx != _currentIndex) {
        _currentIndex = idx;
        _progress = 0;
        _showGesture = true;
      }
    }
    if (isOpen) {
      _progressTimer ??= Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (mounted) setState(() => _progress = _progress >= 100 ? 0 : _progress + 0.5);
      });
      _gestureTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showGesture = false);
      });
    } else {
      _progressTimer?.cancel();
      _progressTimer = null;
      _progress = 0;
      _showGesture = true;
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _gestureTimer?.cancel();
    super.dispose();
  }

  void _close() {
    ref.read(isPlayerOpenProvider.notifier).state = false;
    ref.read(selectedVideoProvider.notifier).state = null;
  }

  void _onVerticalDrag(double delta) {
    if (delta > 50 && _currentIndex < _videos.length - 1) {
      setState(() {
        _currentIndex++;
        _progress = 0;
        _showGesture = true;
      });
    } else if (delta < -50 && _currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _progress = 0;
        _showGesture = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ref.watch(isPlayerOpenProvider);
    if (!isOpen || _videos.isEmpty) return const SizedBox.shrink();

    final video = _videos[_currentIndex.clamp(0, _videos.length - 1)];
    final totalSec = _parseDuration(video.duration);
    final currentSec = ((_progress / 100) * totalSec).floor();

    // System insets (status bar + home/back nav bar). On gesture-nav phones
    // these are ~0; on phones with on-screen buttons they keep the controls
    // clear of the navigation bar in both portrait and landscape.
    final safe = MediaQuery.viewPaddingOf(context);

    return GestureDetector(
      onTap: _close,
      onVerticalDragEnd: (d) => _onVerticalDrag(-d.velocity.pixelsPerSecond.dy),
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(video.thumbnail, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.2), Colors.transparent, Colors.black.withValues(alpha: 0.4)],
                ),
              ),
            ),
            Positioned(
              top: 24 + safe.top,
              left: 24 + safe.left,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _close,
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryButtonGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 16)],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 32 + safe.top,
              left: 56 + safe.left,
              child: Row(
                children: [
                  Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.red.shade500, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('Playing', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Positioned(
              top: 32 + safe.top,
              right: 32 + safe.right,
              left: 100 + safe.left,
              child: Text(
                video.title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              bottom: 32 + safe.bottom,
              left: 32 + safe.left,
              right: 32 + safe.right,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatTime(currentSec), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(video.duration, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 6,
                            width: w,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(3)),
                          ),
                          Container(
                            height: 6,
                            width: w * (_progress / 100),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.orange400, AppColors.red500]),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Positioned(
                            left: (w * (_progress / 100)).clamp(0.0, w - 20) - 10,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.orange400, width: 2),
                                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            if (_showGesture)
              Positioned(
                left: 32 + safe.left,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.keyboard_arrow_up, color: Colors.white.withValues(alpha: 0.9), size: 40),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('Swipe', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.5 - 12,
              right: 32 + safe.right,
              child: Text('Tap to close', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  int _parseDuration(String d) {
    final parts = d.split(':');
    if (parts.length >= 2) {
      final m = int.tryParse(parts[0]) ?? 0;
      final s = int.tryParse(parts[1]) ?? 0;
      return m * 60 + s;
    }
    return 312;
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
