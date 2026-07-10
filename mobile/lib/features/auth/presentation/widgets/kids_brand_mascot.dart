import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Playful animated brand mascot for kids — replaces the static app icon.
class KidsBrandMascot extends StatefulWidget {
  const KidsBrandMascot({
    super.key,
    this.size = 160,
    this.showGlow = true,
  });

  final double size;
  final bool showGlow;

  @override
  State<KidsBrandMascot> createState() => _KidsBrandMascotState();
}

class _KidsBrandMascotState extends State<KidsBrandMascot>
    with TickerProviderStateMixin {
  late final AnimationController _bob;
  late final AnimationController _spin;
  late final AnimationController _sparkle;

  @override
  void initState() {
    super.initState();
    _bob = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _sparkle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _bob.dispose();
    _spin.dispose();
    _sparkle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_bob, _spin, _sparkle]),
        builder: (context, _) {
          final bob = math.sin(_bob.value * math.pi) * (size * 0.028);
          final pulse = 1 + math.sin(_bob.value * math.pi * 2) * 0.03;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (widget.showGlow)
                Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: size * 1.05,
                    height: size * 1.05,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFE066).withValues(alpha: 0.45),
                          const Color(0xFFFF9A56).withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              // Orbiting sparkles
              ...List.generate(6, (i) {
                final angle = _spin.value * math.pi * 2 + (i * math.pi / 3);
                final radius = size * (0.42 + (i.isEven ? 0.04 : 0));
                final twinkle =
                    0.45 + 0.55 * ((math.sin(_sparkle.value * math.pi * 2 + i) + 1) / 2);
                return Transform.translate(
                  offset: Offset(
                    math.cos(angle) * radius,
                    math.sin(angle) * radius + bob * 0.3,
                  ),
                  child: Opacity(
                    opacity: twinkle.clamp(0.2, 1.0),
                    child: Text(
                      i.isEven ? '✨' : '⭐',
                      style: TextStyle(fontSize: size * (i.isEven ? 0.12 : 0.14)),
                    ),
                  ),
                );
              }),
              // Soft plate behind mascot
              Transform.translate(
                offset: Offset(0, bob),
                child: Container(
                  width: size * 0.92,
                  height: size * 0.92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size * 0.28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF8B5CF6),
                        Color(0xFFFF6B9D),
                        Color(0xFFFF9A56),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.75),
                      width: size * 0.025,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B4CE6).withValues(alpha: 0.4),
                        blurRadius: size * 0.18,
                        offset: Offset(0, size * 0.08),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Soft blobs
                      Positioned(
                        top: size * 0.08,
                        left: size * 0.1,
                        child: _blob(size * 0.22, Colors.white.withValues(alpha: 0.15)),
                      ),
                      Positioned(
                        bottom: size * 0.1,
                        right: size * 0.08,
                        child: _blob(size * 0.18, Colors.white.withValues(alpha: 0.12)),
                      ),
                      // Sun
                      Positioned(
                        top: size * 0.06,
                        child: Transform.rotate(
                          angle: math.sin(_bob.value * math.pi * 2) * 0.08,
                          child: Transform.scale(
                            scale: 0.95 + math.sin(_bob.value * math.pi) * 0.06,
                            child: Text(
                              '🌞',
                              style: TextStyle(fontSize: size * 0.28),
                            ),
                          ),
                        ),
                      ),
                      // Open book
                      Positioned(
                        bottom: size * 0.12,
                        child: Transform.rotate(
                          angle: math.sin(_bob.value * math.pi * 2 + 1) * 0.04,
                          child: Text(
                            '📖',
                            style: TextStyle(fontSize: size * 0.38),
                          ),
                        ),
                      ),
                      // Tiny balloon friend
                      Positioned(
                        right: size * 0.08,
                        top: size * 0.28,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            math.sin(_bob.value * math.pi * 2 + 2) * size * 0.03,
                          ),
                          child: Text(
                            '🎈',
                            style: TextStyle(fontSize: size * 0.14),
                          ),
                        ),
                      ),
                      // Tiny star friend
                      Positioned(
                        left: size * 0.08,
                        top: size * 0.32,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            math.cos(_bob.value * math.pi * 2) * size * 0.025,
                          ),
                          child: Text(
                            '🌈',
                            style: TextStyle(fontSize: size * 0.12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
