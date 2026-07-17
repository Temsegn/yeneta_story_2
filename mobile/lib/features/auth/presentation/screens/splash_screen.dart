import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../../../../core/bootstrap/bootstrap_service.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../widgets/kids_welcome_background.dart';
import '../widgets/kids_brand_mascot.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _introController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  double _progress = 0;

  static const _gradient = [
    Color(0xFFFACC15),
    Color(0xFF22C55E),
    Color(0xFF15803D),
  ];

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _introController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _slideAnimation = Tween<double>(begin: 24, end: 0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _introController.forward();
    _runBootstrap();
  }

  Future<void> _runBootstrap() async {
    final bootstrap = ref.read(bootstrapServiceProvider);
    bootstrap.warmUpBackend();

    setState(() => _progress = 0.15);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _progress = 0.4);

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _progress = 0.65);

    final result = await bootstrap.run();
    if (!mounted) return;

    if (result.step == BootstrapStep.updateRequired) {
      _showUpdateDialog(AppLocalizations.of(context));
      return;
    }

    setState(() => _progress = 0.9);
    await Future.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;

    setState(() => _progress = 1.0);
    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted && result.nextRoute != null) {
      context.go(result.nextRoute!);
    }
  }

  void _showUpdateDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.updateRequiredTitle),
        content: Text(l10n.updateRequiredMessage),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9A56),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(l10n.updateNow),
          ),
        ],
      ),
    );
  }

  String _statusForProgress(AppLocalizations l10n, double p) {
    if (p < 0.35) return l10n.bootstrapLoading;
    if (p < 0.6) return l10n.bootstrapCheckingVersion;
    if (p < 0.9) return l10n.bootstrapCheckingAuth;
    if (p < 1.0) return l10n.bootstrapCheckingPayment;
    return l10n.bootstrapReady;
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: KidsWelcomeBackground(
        gradientColors: _gradient,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: const LanguageSwitcher(onDarkBackground: true),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final pulse = 1.0 + (_pulseController.value * 0.06);
                          return Transform.scale(
                            scale: _scaleAnimation.value * pulse,
                            child: child,
                          );
                        },
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: const KidsBrandMascot(size: 168, showGlow: true),
                        ),
                      ),
                      const SizedBox(height: 32),
                      AnimatedBuilder(
                        animation: _introController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              l10n.appTitle,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                height: 1.1,
                                shadows: [
                                  Shadow(
                                    color: Color(0x66000000),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Text(
                                l10n.splashTagline,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.95),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: ['📚', '🎬', '🎮', '🦁'].map((emoji) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(emoji, style: const TextStyle(fontSize: 28)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 44),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: KidsLoadingBar(
                          progress: _progress,
                          label: _statusForProgress(l10n, _progress),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 28,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    '✨ ${l10n.bootstrapLoading}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
