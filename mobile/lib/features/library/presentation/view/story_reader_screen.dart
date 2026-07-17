import 'package:flutter/material.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/core/widgets/content_network_image.dart';
import 'package:kids_app/features/library/domain/entities/story_entity.dart';

class StoryReaderScreen extends StatefulWidget {
  final StoryEntity story;
  final VoidCallback onClose;

  const StoryReaderScreen({super.key, required this.story, required this.onClose});

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: widget.story.pages.length,
            itemBuilder: (context, i) {
              final page = widget.story.pages[i];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.4,
                      width: double.infinity,
                      child: ContentNetworkImage(url: page.image),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [const Color(0xFFFFF7ED), const Color(0xFFFEFCE8)],
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            page.text,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.grey.shade800, height: 1.7),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 16, left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onClose,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: Text(
                      '${_currentPage + 1} / ${widget.story.pages.length}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.4 + 48,
            right: 24,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _isPlaying = !_isPlaying),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: _isPlaying ? const LinearGradient(colors: [AppColors.green500, Color(0xFF059669)]) : AppColors.primaryButtonGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
                  ),
                  child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
