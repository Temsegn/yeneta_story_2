import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/core/widgets/empty_state_widget.dart';
import 'package:kids_app/core/widgets/content_network_image.dart';
import 'package:kids_app/core/auth/access_gate.dart';
import 'package:kids_app/core/network/api_exception.dart';
import 'package:kids_app/features/library/domain/entities/story_entity.dart';
import 'package:kids_app/features/library/presentation/providers/library_providers.dart';
import 'package:kids_app/features/library/presentation/view/story_reader_screen.dart';
import 'package:kids_app/features/library/presentation/viewmodel/stories_viewmodel.dart';
import 'package:kids_app/features/shell/presentation/providers/shell_providers.dart';

class StoriesScreen extends ConsumerStatefulWidget {
  const StoriesScreen({super.key});

  @override
  ConsumerState<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends ConsumerState<StoriesScreen> {
  bool _storiesFilter = true; // true = Stories, false = Books
  bool _opening = false;

  Future<void> _openStory(StoryEntity story) async {
    if (_opening) return;

    final ok = await AccessGate.canOpenPremium(
      context,
      ref,
      isPremium: story.isPremium,
    );
    if (!ok || !mounted) return;

    setState(() => _opening = true);
    try {
      StoryEntity detailed = story;
      if (story.apiId.isNotEmpty && !story.apiId.startsWith('sample_')) {
        final repo = ref.read(storyRepositoryProvider);
        detailed = _storiesFilter
            ? await repo.getStoryById(story.apiId)
            : await repo.getBookById(story.apiId);
      }

      if (!mounted) return;
      if (detailed.pages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This item has no pages yet.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      ref.read(isReadingStoryProvider.notifier).state = true;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => StoryReaderScreen(
            story: detailed,
            onClose: () {
              ref.read(isReadingStoryProvider.notifier).state = false;
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open this item. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storiesViewModelProvider(_storiesFilter));
    return Stack(
      children: [
        state.when(
          data: (list) => _buildContent(list),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.orange500),
          ),
          error: (e, _) => Center(child: Text('$e')),
        ),
        if (_opening)
          Container(
            color: Colors.black26,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: AppColors.orange500),
          ),
      ],
    );
  }

  Widget _buildContent(List<StoryEntity> list) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 120),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _FilterButton(
                  label: 'ታሪኮች',
                  icon: Icons.menu_book_rounded,
                  isActive: _storiesFilter,
                  gradient: AppColors.primaryButtonGradient,
                  onTap: () => setState(() => _storiesFilter = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FilterButton(
                  label: 'መጻሕፍት',
                  icon: Icons.book_rounded,
                  isActive: !_storiesFilter,
                  gradient: const LinearGradient(colors: [Color(0xFF4ADE80), Color(0xFF059669)]),
                  onTap: () => setState(() => _storiesFilter = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Show empty state or story list
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: EmptyStateWidget(
                emoji: _storiesFilter ? '📚' : '📖',
                title: _storiesFilter ? 'ምንም ታሪኮች የሉም' : 'ምንም መጻሕፍት የሉም',
                message: 'በቅርቡ አዲስ ${_storiesFilter ? 'ታሪኮች' : 'መጻሕፍት'} ይመጣሉ!\nበኋላ ይመልከቱ ✨',
                primaryColor: const Color(0xFF8B5CF6),
                secondaryColor: const Color(0xFFA78BFA),
              ),
            )
          else
            ...list.asMap().entries.map((entry) {
            final index = entry.key;
            final story = entry.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: _StoryCard(
                story: story,
                onTap: () => _openStory(story),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Gradient gradient;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 64,
          decoration: BoxDecoration(
            gradient: isActive ? gradient : null,
            color: isActive ? null : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isActive ? Colors.transparent : AppColors.orange200, width: 2),
            boxShadow: isActive ? [BoxShadow(color: AppColors.orange400.withValues(alpha: 0.4), blurRadius: 12)] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: isActive ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1.0 + (value * 0.1),
                    child: Transform.rotate(
                      angle: value * 0.1,
                      child: Icon(
                        icon,
                        size: 24,
                        color: isActive ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isActive ? Colors.white : Colors.grey.shade700,
                  decoration: TextDecoration.none,
                ),
              ),
              if (isActive)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.auto_awesome,
                          size: 20 * value,
                          color: AppColors.yellow400,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatefulWidget {
  final StoryEntity story;
  final VoidCallback onTap;

  const _StoryCard({required this.story, required this.onTap});

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_controller.value * 0.05),
                        child: ContentNetworkImage(
                          url: widget.story.coverImage,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: PremiumLockBadge(isPremium: widget.story.isPremium),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          widget.story.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            decoration: TextDecoration.none,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.8),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
