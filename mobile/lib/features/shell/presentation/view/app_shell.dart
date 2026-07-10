import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/core/utils/responsive.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/features/education/presentation/view/education_screen.dart';
import 'package:kids_app/features/games/presentation/view/games_screen.dart';
import 'package:kids_app/features/home/presentation/view/home_screen.dart';
import 'package:kids_app/features/library/presentation/view/stories_screen.dart';
import 'package:kids_app/features/shell/presentation/providers/shell_providers.dart';
import 'package:kids_app/features/shell/presentation/view/bottom_nav.dart';
import 'package:kids_app/features/shell/presentation/viewmodel/shell_viewmodel.dart';
import 'package:kids_app/features/video/presentation/view/video_player_overlay.dart';
import 'package:kids_app/features/video/presentation/view/video_screen.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(shellViewModelProvider);
    final isPlayerOpen = ref.watch(isPlayerOpenProvider);
    final isEducationAgeSelected = ref.watch(isEducationAgeSelectedProvider);
    final isReadingStory = ref.watch(isReadingStoryProvider);
    final isPlayingGame = ref.watch(isPlayingGameProvider);

    final showNav = !((activeTab == TabType.education && isEducationAgeSelected) ||
        (activeTab == TabType.library && isReadingStory) ||
        isPlayingGame ||
        isPlayerOpen);

    return Container(
      color: const Color(0xFFF5F5F5),
      child: Stack(
        children: [
          // Background image on every screen (asset first, then network fallback)
          Positioned.fill(
            child: _AppBackground(),
          ),
          // Light overlay for text readability
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: Responsive.maxWidth),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.03, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          ),
                        );
                      },
                      child: _content(activeTab, key: ValueKey(activeTab)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom nav above system UI (Samsung back/home) so it is not covered
          if (showNav)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: const BottomNav(),
              ),
            ),
          const VideoPlayerOverlay(),
        ],
      ),
    );
  }

  Widget _content(TabType tab, {required Key key}) {
    switch (tab) {
      case TabType.home:
        return const HomeScreen(key: ValueKey('home'));
      case TabType.video:
        return const VideoScreen(key: ValueKey('video'));
      case TabType.library:
        return const StoriesScreen(key: ValueKey('library'));
      case TabType.education:
        return const EducationScreen(key: ValueKey('education'));
      case TabType.games:
        return const GamesScreen(key: ValueKey('games'));
    }
  }
}

/// Background: uses asset image; if missing, falls back to network image.
class _AppBackground extends StatelessWidget {
  static const _assetPath = 'assets/images/background.png';
  static const _fallbackUrl =
      'https://images.unsplash.com/photo-1608106055806-e892769d2e5a?auto=format&q=80&w=1920';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetPath,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (_, __, ___) => Image.network(
        _fallbackUrl,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFE8E8E8),
          child: const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
        ),
      ),
    );
  }
}
