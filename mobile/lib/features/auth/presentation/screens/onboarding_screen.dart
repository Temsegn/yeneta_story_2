import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/storage/onboarding_storage.dart';
import '../widgets/kids_welcome_background.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final _onboardingStorage = OnboardingStorage();
  int _currentPage = 0;

  List<OnboardingPage> _pages(AppLocalizations l10n) => [
        OnboardingPage(
          title: l10n.onboardingTitle1,
          description: l10n.onboardingDesc1,
          emoji: '📖',
          icon: Icons.auto_stories_rounded,
          gradient: const [Color(0xFF667EEA), Color(0xFF764BA2)],
          accent: const Color(0xFFFFD93D),
          imageAsset: 'assets/images/onboarding_1.png',
        ),
        OnboardingPage(
          title: l10n.onboardingTitle2,
          description: l10n.onboardingDesc2,
          emoji: '🎬',
          icon: Icons.play_circle_filled_rounded,
          gradient: const [Color(0xFFFF6B9D), Color(0xFFFF9A56)],
          accent: const Color(0xFF4ECDC4),
        ),
        OnboardingPage(
          title: l10n.onboardingTitle3,
          description: l10n.onboardingDesc3,
          emoji: '🎮',
          icon: Icons.videogame_asset_rounded,
          gradient: const [Color(0xFF11998E), Color(0xFF38EF7D)],
          accent: const Color(0xFFFFE066),
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await _onboardingStorage.setHasSeenOnboarding(true);
    ref.read(guestModeProvider.notifier).state = true;
    if (mounted) context.go('/home');
  }

  void _onNext(int pageCount) {
    if (_currentPage == pageCount - 1) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = _pages(l10n);
    final page = pages[_currentPage];

    return Scaffold(
      body: KidsWelcomeBackground(
        gradientColors: page.gradient,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentPage + 1}/${pages.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        l10n.skip,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: pages.length,
                  itemBuilder: (context, index) => _buildHero(pages[index]),
                ),
              ),
              KidsWavePanel(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Column(
                          key: ValueKey(_currentPage),
                          children: [
                            Text(
                              page.title,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: page.gradient.first,
                                height: 1.15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                                height: 1.55,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      _buildIndicator(pages),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(colors: page.gradient),
                            boxShadow: [
                              BoxShadow(
                                color: page.gradient.last.withValues(alpha: 0.45),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => _onNext(pages.length),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == pages.length - 1
                                      ? l10n.getStarted
                                      : l10n.next,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _currentPage == pages.length - 1
                                      ? Icons.rocket_launch_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      color: Colors.white.withValues(alpha: 0.22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: page.imageAsset != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.asset(
                              page.imageAsset!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _heroFallback(page),
                            ),
                          )
                        : _heroFallback(page),
                  ),
                  Positioned(
                    top: 8,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: page.accent,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        page.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroFallback(OnboardingPage page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(page.emoji, style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 12),
        Icon(page.icon, size: 56, color: Colors.white.withValues(alpha: 0.95)),
      ],
    );
  }

  Widget _buildIndicator(List<OnboardingPage> pages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pages.length, (index) {
        final active = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: active
                ? LinearGradient(colors: pages[index].gradient)
                : null,
            color: active ? null : Colors.grey.shade300,
          ),
        );
      }),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String emoji;
  final IconData icon;
  final List<Color> gradient;
  final Color accent;
  final String? imageAsset;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.emoji,
    required this.icon,
    required this.gradient,
    required this.accent,
    this.imageAsset,
  });
}
