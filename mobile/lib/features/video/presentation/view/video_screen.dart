import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/core/widgets/empty_state_widget.dart';
import 'package:kids_app/core/auth/access_gate.dart';
import 'package:kids_app/features/shell/presentation/providers/shell_providers.dart';
import 'package:kids_app/features/video/domain/entities/video_entity.dart';
import 'package:kids_app/features/video/presentation/viewmodel/video_list_viewmodel.dart';

class VideoScreen extends ConsumerWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(videoListViewModelProvider);
    return state.when(
      data: (videos) {
        if (videos.isEmpty) {
          return const EmptyStateWidget(
            emoji: '🎬',
            title: 'ምንም ቪዲዮዎች የሉም',
            message: 'በቅርቡ አዲስ ቪዲዮዎች ይመጣሉ!\nበኋላ ይመልከቱ 🌟',
            primaryColor: Color(0xFFF97316),
            secondaryColor: Color(0xFFFB923C),
          );
        }
        return _VideoListContent(videos: videos, ref: ref);
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.orange500)),
      error: (e, _) => const EmptyStateWidget(
        emoji: '🎬',
        title: 'ምንም ቪዲዮዎች የሉም',
        message: 'በቅርቡ አዲስ ቪዲዮዎች ይመጣሉ!\nበኋላ ይመልከቱ 🌟',
        primaryColor: Color(0xFFF97316),
        secondaryColor: Color(0xFFFB923C),
      ),
    );
  }
}

class _VideoListContent extends StatefulWidget {
  final List<VideoEntity> videos;
  final WidgetRef ref;

  const _VideoListContent({required this.videos, required this.ref});

  @override
  State<_VideoListContent> createState() => _VideoListContentState();
}

class _VideoListContentState extends State<_VideoListContent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 120),
      itemCount: widget.videos.length,
      itemBuilder: (context, i) {
        final v = widget.videos[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (i * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
              child: GestureDetector(
              onTap: () async {
                  final ok = await AccessGate.canOpenPremium(
                    context,
                    widget.ref,
                    isPremium: v.isPremium ?? false,
                  );
                  if (!ok) return;
                  widget.ref.read(selectedVideoProvider.notifier).state = v;
                  widget.ref.read(isPlayerOpenProvider.notifier).state = true;
                },
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.95, end: 1.0),
                duration: const Duration(milliseconds: 200),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      height: 500,
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
                            Hero(
                              tag: 'video_${v.id}',
                              child: Image.network(
                                v.thumbnail,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.broken_image, size: 48),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.6),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 24,
                              left: 24,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.green600.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      v.duration,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  PremiumLockBadge(isPremium: v.isPremium ?? false),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 24,
                              right: 24,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: Duration(milliseconds: 400 + (i * 100)),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Transform.rotate(
                                      angle: value * 0.1,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryButtonGradient,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              left: 24,
                              right: 24,
                              child: Text(
                                v.title,
                                style: TextStyle(
                                  fontSize: 28,
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
