import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/core/widgets/content_network_image.dart';
import 'package:kids_app/features/education/domain/entities/education_video_entity.dart';

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
  State<EducationVideoDetailScreen> createState() => _EducationVideoDetailScreenState();
}

class _EducationVideoDetailScreenState extends State<EducationVideoDetailScreen> {
  late int _currentIndex;
  double _progress = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.videos.length - 1);
    _startProgress();
  }

  void _startProgress() {
    _timer?.cancel();
    _progress = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() => _progress = _progress >= 100 ? 0 : _progress + 0.5);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int _parseDuration(String d) {
    final parts = d.split(':');
    if (parts.length >= 2) {
      final m = int.tryParse(parts[0]) ?? 0;
      final s = int.tryParse(parts[1]) ?? 0;
      return m * 60 + s;
    }
    return 300;
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _onVerticalDrag(double delta) {
    if (delta > 50 && _currentIndex < widget.videos.length - 1) {
      setState(() {
        _currentIndex++;
        _startProgress();
      });
    } else if (delta < -50 && _currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _startProgress();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videos.isEmpty) return const SizedBox.shrink();
    final video = widget.videos[_currentIndex.clamp(0, widget.videos.length - 1)];
    final totalSec = _parseDuration(video.duration);
    final currentSec = ((_progress / 100) * totalSec).floor();

    return GestureDetector(
      onVerticalDragEnd: (d) => _onVerticalDrag(-d.velocity.pixelsPerSecond.dy),
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ContentNetworkImage(url: video.thumbnail),
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
              top: MediaQuery.paddingOf(context).top + 8,
              left: 24,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onBack,
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
              top: MediaQuery.paddingOf(context).top + 32,
              right: 32,
              left: 100,
              child: Text(
                video.title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
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
          ],
        ),
      ),
    );
  }
}
