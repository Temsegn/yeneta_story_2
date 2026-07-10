import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Playful animated sky background for splash & onboarding.
class KidsWelcomeBackground extends StatefulWidget {
  const KidsWelcomeBackground({
    super.key,
    required this.gradientColors,
    required this.child,
    this.showFloatingDecor = true,
  });

  final List<Color> gradientColors;
  final Widget child;
  final bool showFloatingDecor;

  @override
  State<KidsWelcomeBackground> createState() => _KidsWelcomeBackgroundState();
}

class _KidsWelcomeBackgroundState extends State<KidsWelcomeBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
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
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _BlobPainter(progress: _controller.value),
              ),
              if (widget.showFloatingDecor) ...[
                _floatingBadge(
                  top: 90,
                  left: 24,
                  emoji: '⭐',
                  drift: _controller.value,
                  phase: 0,
                ),
                _floatingBadge(
                  top: 140,
                  right: 30,
                  emoji: '🌈',
                  drift: _controller.value,
                  phase: 0.4,
                ),
                _floatingBadge(
                  bottom: 180,
                  left: 36,
                  emoji: '🎈',
                  drift: _controller.value,
                  phase: 0.8,
                ),
                _floatingBadge(
                  bottom: 220,
                  right: 40,
                  emoji: '✨',
                  drift: _controller.value,
                  phase: 1.2,
                ),
              ],
              child!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }

  Widget _floatingBadge({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required String emoji,
    required double drift,
    required double phase,
  }) {
    final bob = math.sin((drift + phase) * math.pi * 2) * 10;
    return Positioned(
      top: top != null ? top + bob : null,
      bottom: bottom != null ? bottom - bob : null,
      left: left,
      right: right,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 26)),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  _BlobPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = Colors.white.withValues(alpha: 0.08);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * (0.18 + progress * 0.02)),
      size.width * 0.28,
      paint,
    );

    paint.color = Colors.white.withValues(alpha: 0.06);
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * (0.22 - progress * 0.02)),
      size.width * 0.22,
      paint,
    );

    paint.color = Colors.white.withValues(alpha: 0.05);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.92),
      size.width * 0.4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Wavy white panel used at the bottom of onboarding pages.
class KidsWavePanel extends StatelessWidget {
  const KidsWavePanel({
    super.key,
    required this.child,
    this.heightFactor = 0.42,
  });

  final Widget child;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * heightFactor,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 24,
              offset: Offset(0, -8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.12)
      ..quadraticBezierTo(
        size.width * 0.25,
        0,
        size.width * 0.5,
        size.height * 0.08,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.16,
        size.width,
        size.height * 0.05,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Bouncy capsule progress indicator for splash.
class KidsLoadingBar extends StatelessWidget {
  const KidsLoadingBar({
    super.key,
    required this.progress,
    required this.label,
  });

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 18,
          width: 240,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fill = constraints.maxWidth * progress.clamp(0.0, 1.0);
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    width: fill,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFE066), Color(0xFFFF9F43)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9F43).withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.95),
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
