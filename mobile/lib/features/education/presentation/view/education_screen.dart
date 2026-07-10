import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/core/widgets/empty_state_widget.dart';
import 'package:kids_app/core/auth/access_gate.dart';
import 'package:kids_app/features/education/domain/entities/education_video_entity.dart';
import 'package:kids_app/features/education/presentation/view/education_video_detail_screen.dart';
import 'package:kids_app/features/education/presentation/viewmodel/education_viewmodel.dart';
import 'package:kids_app/features/shell/presentation/providers/shell_providers.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  String? _selectedAge;
  EducationVideoEntity? _selectedVideo;
  List<EducationVideoEntity> _videos = [];

  static const _ageGroups = [
    (id: '3-5', label: '3 - 5', color: Color(0xFFF97316), icon: '🐣'),
    (id: '5-8', label: '5 - 8', color: Color(0xFF16A34A), icon: '🦊'),
    (id: '8-11', label: '8 - 11', color: Color(0xFF2563EB), icon: '🦁'),
  ];
  static const _amharicAges = ['3-5 ዓመት', '5-8 ዓመት', '8-11 ዓመት'];

  @override
  Widget build(BuildContext context) {
    if (_selectedVideo != null && _videos.isNotEmpty) {
      final idx = _videos.indexWhere((v) => v.id == _selectedVideo!.id);
      return EducationVideoDetailScreen(
        videos: _videos,
        initialIndex: idx >= 0 ? idx : 0,
        onBack: () => setState(() => _selectedVideo = null),
      );
    }

    if (_selectedAge == null) {
      return _AgeSelection(
        ageGroups: _ageGroups,
        amharicAges: _amharicAges,
        onSelect: (age) async {
          ref.read(isEducationAgeSelectedProvider.notifier).state = true;
          final ds = ref.read(educationRemoteDataSourceProvider);
          final list = await ds.getVideosByAge(age);
          if (mounted) setState(() {
            _selectedAge = age;
            _videos = list;
          });
        },
      );
    }

    // Show empty state if no videos for selected age
    if (_videos.isEmpty) {
      return Stack(
        children: [
          const EmptyStateWidget(
            emoji: '🎓',
            title: 'ምንም ትምህርቶች የሉም',
            message: 'በቅርቡ አዲስ ትምህርቶች ይመጣሉ!\nበኋላ ይመልከቱ 🌈',
            primaryColor: Color(0xFF3B82F6),
            secondaryColor: Color(0xFF60A5FA),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 24,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ref.read(isEducationAgeSelectedProvider.notifier).state = false;
                  setState(() {
                    _selectedAge = null;
                    _videos = [];
                  });
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.orange200),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  ),
                  child: Icon(Icons.arrow_back, color: AppColors.orange600, size: 24),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.only(left: 12, right: 12, top: 80, bottom: 120),
          itemCount: _videos.length,
          itemBuilder: (context, i) {
            final v = _videos[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () async {
                  final ok = await AccessGate.canOpenPremium(
                    context,
                    ref,
                    isPremium: v.isPremium,
                  );
                  if (!ok || !mounted) return;
                  setState(() => _selectedVideo = v);
                },
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(v.thumbnail, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: PremiumLockBadge(isPremium: v.isPremium),
                        ),
                        Positioned(
                          top: 24,
                          right: 32,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            child: Text('ትምህርት ${v.id % 100}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, decoration: TextDecoration.none)),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 32,
                          right: 32,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(v.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2, decoration: TextDecoration.none)),
                                    const SizedBox(height: 4),
                                    Text('${v.duration} • ${v.author}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.8), decoration: TextDecoration.none)),
                                  ],
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.orange500,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 12)],
                                ),
                                child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
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
          },
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 8,
          left: 24,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref.read(isEducationAgeSelectedProvider.notifier).state = false;
                setState(() {
                  _selectedAge = null;
                  _videos = [];
                });
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.orange200),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Icon(Icons.arrow_back, color: AppColors.orange600, size: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AgeSelection extends StatelessWidget {
  final List<({String id, String label, Color color, String icon})> ageGroups;
  final List<String> amharicAges;
  final void Function(String age) onSelect;

  const _AgeSelection({required this.ageGroups, required this.amharicAges, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 120),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.orange200,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
            ),
            child: Icon(Icons.school_rounded, color: AppColors.orange600, size: 32),
          ),
          const SizedBox(height: 16),
          Text('እድሜህን ምረጥ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.grey.shade900)),
          const SizedBox(height: 8),
          Text('እድሜህን ምረጥ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
          const SizedBox(height: 48),
          ...List.generate(ageGroups.length, (i) {
            final g = ageGroups[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(g.id),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: g.color.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('እድሜ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.6))),
                              Text(amharicAges[i], style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
                            ],
                          ),
                          Text(g.icon, style: const TextStyle(fontSize: 56)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
