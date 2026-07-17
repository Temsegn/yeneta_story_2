import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/core/base/constants.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/features/shell/presentation/viewmodel/shell_viewmodel.dart';
import 'dart:math' as math;

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(shellViewModelProvider);
    return _BottomNavContent(
      activeTab: activeTab,
      onTabSelected: (tab) => ref.read(shellViewModelProvider.notifier).setTab(tab),
    );
  }
}

class _BottomNavContent extends StatefulWidget {
  final TabType activeTab;
  final ValueChanged<TabType> onTabSelected;

  const _BottomNavContent({
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  State<_BottomNavContent> createState() => _BottomNavContentState();
}

class _BottomNavContentState extends State<_BottomNavContent> with SingleTickerProviderStateMixin {
  static const _tabs = [
    (id: TabType.library, icon: Icons.menu_book_rounded, label: AppConstants.tabLibrary),
    (id: TabType.video, icon: Icons.play_circle_rounded, label: AppConstants.tabVideo),
    (id: TabType.home, icon: Icons.home_rounded, label: AppConstants.tabHome),
    (id: TabType.education, icon: Icons.school_rounded, label: AppConstants.tabEducation),
    (id: TabType.games, icon: Icons.sports_esports_rounded, label: AppConstants.tabGames),
  ];

  static Color _tabColor(TabType tab) {
    switch (tab) {
      case TabType.library:
        return const Color(0xFFC026D3);
      case TabType.video:
        return Colors.red.shade400;
      case TabType.home:
        return AppColors.yellow400;
      case TabType.education:
        return Colors.blue.shade400;
      case TabType.games:
        return AppColors.green500;
    }
  }

  static const int _animMs = 400;
  static const double _barHeight = 64.0;
  static const double _activeIconSize = 26.0;
  static const double _inactiveIconSize = 18.0;
  static const double _gapAboveCurve = 4.0;
  /// Max height for each tab cell so we never overflow (some contexts give 54px).
  static const double _cellHeight = 52.0;
  static const double _contentHeight = _barHeight - _gapAboveCurve;

  late AnimationController _curveController;
  Animation<double>? _curveAnimation;
  double _curveIndex = 2.0;
  bool _curveInitialized = false;

  @override
  void initState() {
    super.initState();
    _curveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _animMs),
    );
    _curveController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _curveAnimation != null) {
        setState(() => _curveIndex = _curveAnimation!.value);
      }
    });
  }

  @override
  void dispose() {
    _curveController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _BottomNavContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    final targetIndex = widget.activeTab.index.toDouble();
    if (!_curveInitialized) {
      _curveIndex = targetIndex;
      _curveInitialized = true;
    } else if (!_curveController.isAnimating && (targetIndex - _curveIndex).abs() > 0.01) {
      _curveAnimation = Tween<double>(begin: _curveIndex, end: targetIndex).animate(
        CurvedAnimation(parent: _curveController, curve: Curves.easeInOutCubic),
      );
      _curveController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = widget.activeTab;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final navWidth = screenWidth.clamp(0.0, 430.0);
    final targetIndex = activeTab.index.toDouble();

    if (!_curveInitialized) {
      _curveIndex = targetIndex;
      _curveInitialized = true;
    } else if (!_curveController.isAnimating && (targetIndex - _curveIndex).abs() > 0.01) {
      _curveAnimation = Tween<double>(begin: _curveIndex, end: targetIndex).animate(
        CurvedAnimation(parent: _curveController, curve: Curves.easeInOutCubic),
      );
      _curveController.forward(from: 0.0);
    }

    return SizedBox(
      width: navWidth,
      height: _barHeight,
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.bottomCenter,
          children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _barHeight,
            child: AnimatedBuilder(
              animation: _curveController,
              builder: (context, _) {
                final raw = _curveAnimation != null && _curveController.isAnimating
                    ? _curveAnimation!.value
                    : _curveIndex;
                final displayIndex = (raw.isNaN || raw.isInfinite)
                    ? _curveIndex
                    : raw.clamp(0.0, 4.0);
                return CustomPaint(
                  size: Size(navWidth, _barHeight),
                  painter: _NavBarPainter(animatedIndex: displayIndex),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _barHeight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: _gapAboveCurve),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _tabs.asMap().entries.map((entry) {
                  final t = entry.value;
                  final isActive = activeTab == t.id;
                  final activeIconSize =
                      t.id == TabType.home ? 34.0 : _activeIconSize;
                  final inactiveIconSize =
                      t.id == TabType.home ? 24.0 : _inactiveIconSize;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onTabSelected(t.id),
                      borderRadius: BorderRadius.circular(24),
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      highlightColor: Colors.white.withValues(alpha: 0.1),
                      child: SizedBox(
                        width: 64,
                        height: _cellHeight,
                        child: ClipRect(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TweenAnimationBuilder<double>(
                              key: ValueKey('${t.id}_$isActive'),
                              tween: Tween(
                                begin: isActive
                                    ? inactiveIconSize
                                    : activeIconSize,
                                end: isActive
                                    ? activeIconSize
                                    : inactiveIconSize,
                              ),
                              duration: const Duration(milliseconds: _animMs),
                              curve: Curves.easeInOutCubic,
                              builder: (context, value, _) {
                                final size = value.isNaN || value.isInfinite || value <= 0
                                    ? (isActive
                                        ? activeIconSize
                                        : inactiveIconSize)
                                    : value;
                                return isActive
                                    ? _AnimatedActiveIcon(icon: t.icon, size: size)
                                    : Icon(t.icon, size: size, color: Colors.white);
                              },
                            ),
                            const SizedBox(height: 1),
                            Text(
                              t.label,
                              style: TextStyle(
                                fontSize: 7.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            if (isActive)
                              Container(
                                margin: const EdgeInsets.only(top: 0.5),
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: _tabColor(t.id),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _tabColor(t.id).withValues(alpha: 0.6),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

/// Curved bar: center dip at animated index. No border radius.
class _NavBarPainter extends CustomPainter {
  final double animatedIndex;

  _NavBarPainter({required this.animatedIndex});

  static const double _barHeight = 64.0;
  static const double _curveDepth = 30.0;
  static const double _curveWidth = 60.0;

  @override
  void paint(Canvas canvas, Size size) {
    const tabCount = 5;
    final step = size.width / tabCount;
    final centerX = (animatedIndex * step) + (step / 2);

    // Path: top has curved dip at center; bottom and sides straight (no border radius)
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(centerX - _curveWidth, 0)
      ..cubicTo(
        centerX - _curveWidth / 1.8,
        0,
        centerX - _curveWidth / 2,
        _curveDepth,
        centerX,
        _curveDepth,
      )
      ..cubicTo(
        centerX + _curveWidth / 2,
        _curveDepth,
        centerX + _curveWidth / 1.8,
        0,
        centerX + _curveWidth,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, _barHeight)
      ..lineTo(0, _barHeight)
      ..close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColors.green600.withValues(alpha: 0.6),
          AppColors.orange500.withValues(alpha: 0.6),
          AppColors.red500.withValues(alpha: 0.6),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, _barHeight));
    canvas.drawPath(path, paint);

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant _NavBarPainter oldDelegate) => oldDelegate.animatedIndex != animatedIndex;
}

class _AnimatedActiveIcon extends StatefulWidget {
  final IconData icon;
  final double size;

  const _AnimatedActiveIcon({required this.icon, this.size = 40.0});

  @override
  State<_AnimatedActiveIcon> createState() => _AnimatedActiveIconState();
}

class _AnimatedActiveIconState extends State<_AnimatedActiveIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        return Transform.rotate(
          angle: math.sin(value * 2 * math.pi) * 0.08,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                widget.icon,
                size: widget.size,
                color: Colors.white,
              ),
              // Sparkle effects
              Positioned(
                top: -4,
                right: -4,
                child: Opacity(
                  opacity: math.sin(value * 2 * math.pi * 2).clamp(0.0, 1.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.yellow400,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.yellow400.withValues(alpha: 0.8),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                left: -4,
                child: Opacity(
                  opacity: math.cos(value * 2 * math.pi * 2).clamp(0.0, 1.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
