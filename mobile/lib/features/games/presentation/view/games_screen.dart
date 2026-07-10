import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_app/core/theme/app_colors.dart';
import 'package:kids_app/core/widgets/empty_state_widget.dart';
import 'package:kids_app/features/games/domain/entities/game_entity.dart';
import 'package:kids_app/features/games/presentation/view/game_play_screen.dart';
import 'package:kids_app/features/games/presentation/viewmodel/games_viewmodel.dart';
import 'package:kids_app/features/shell/presentation/providers/shell_providers.dart';

class GamesScreen extends ConsumerStatefulWidget {
  const GamesScreen({super.key});

  @override
  ConsumerState<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends ConsumerState<GamesScreen> {
  String? _selectedAge;
  List<GameEntity> _games = [];
  GameEntity? _activeGame;

  static const _ageGroups = [
    (id: '3-5', label: '3 - 5', color: Color(0xFFF97316), icon: '🐣', title: 'ቀላል፣ አስደሳች እና ትምህርታዊ'),
    (id: '6-8', label: '6 - 8', color: Color(0xFF16A34A), icon: '🦊', title: 'ትምህርት + መዝናኛ + ፈጠራ'),
    (id: '9-11', label: '9 - 11', color: Color(0xFF2563EB), icon: '🦁', title: 'አእምሮ፣ ኮዲንግ፣ ስልት'),
  ];
  static const _amharicAges = ['3-5 ዓመት', '6-8 ዓመት', '9-11 ዓመት'];

  Color _colorFromString(String c) {
    switch (c) {
      case 'purple': return Colors.purple.shade500;
      case 'pink': return Colors.pink.shade500;
      case 'green': return Colors.green.shade500;
      case 'blue': return Colors.blue.shade500;
      case 'indigo': return Colors.indigo.shade500;
      case 'yellow': return Colors.yellow.shade600;
      case 'orange': return Colors.orange.shade500;
      case 'red': return Colors.red.shade500;
      case 'teal': return Colors.teal.shade500;
      case 'cyan': return Colors.cyan.shade500;
      case 'rose': return Colors.red.shade300;
      case 'fuchsia': return Colors.deepPurple.shade300;
      case 'amber': return Colors.amber.shade500;
      case 'emerald': return Colors.green.shade700;
      case 'gray': return Colors.grey.shade700;
      default: return AppColors.orange500;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activeGame != null) {
      return GamePlayScreen(
        game: _activeGame!,
        onClose: () {
          ref.read(isPlayingGameProvider.notifier).state = _selectedAge != null;
          setState(() => _activeGame = null);
        },
      );
    }

    if (_selectedAge == null) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 120),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF4ADE80), Color(0xFF059669)]),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24)],
              ),
              child: const Icon(Icons.sports_esports_rounded, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 16),
            Text('የጨዋታ ማእከል', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.grey.shade900, decoration: TextDecoration.none)),
            const SizedBox(height: 8),
            Text('እድሜህን ምረጥ እና ዘወትር ተጫወት!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade600, decoration: TextDecoration.none)),
            const SizedBox(height: 48),
            ...List.generate(_ageGroups.length, (i) {
              final g = _ageGroups[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      ref.read(isPlayingGameProvider.notifier).state = true;
                      final ds = ref.read(gamesDataSourceProvider);
                      final list = await ds.getGamesByAge(g.id);
                      if (mounted) setState(() {
                        _selectedAge = g.id;
                        _games = list;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: g.color.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('እድሜ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.6))),
                                Text(_amharicAges[i], style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
                                const SizedBox(height: 8),
                                Text(g.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.8))),
                              ],
                            ),
                          ),
                          Text(g.icon, style: const TextStyle(fontSize: 56)),
                        ],
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

    // Show empty state if no games for selected age
    if (_games.isEmpty) {
      return Stack(
        children: [
          const EmptyStateWidget(
            emoji: '🎮',
            title: 'ምንም ጨዋታዎች የሉም',
            message: 'በቅርቡ አዲስ ጨዋታዎች ይመጣሉ!\nበኋላ ይመልከቱ 🎯',
            primaryColor: Color(0xFF10B981),
            secondaryColor: Color(0xFF34D399),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 24,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ref.read(isPlayingGameProvider.notifier).state = false;
                  setState(() {
                    _selectedAge = null;
                    _games = [];
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

    // Show empty state if no games for selected age
    if (_games.isEmpty) {
      return Stack(
        children: [
          const EmptyStateWidget(
            emoji: '🎮',
            title: 'ምንም ጨዋታዎች የሉም',
            message: 'በቅርቡ አዲስ ጨዋታዎች ይመጣሉ!\nበኋላ ይመልከቱ 🎉',
            primaryColor: Color(0xFF10B981),
            secondaryColor: Color(0xFF34D399),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 24,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ref.read(isPlayingGameProvider.notifier).state = false;
                  setState(() {
                    _selectedAge = null;
                    _games = [];
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

    final grouped = <String, List<GameEntity>>{};
    for (final g in _games) {
      grouped.putIfAbsent(g.category, () => []).add(g);
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(left: 24, right: 24, top: 88, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_ageGroups.firstWhere((e) => e.id == _selectedAge).icon} እድሜ $_selectedAge ዓመት', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.grey.shade900)),
                      Text('${_games.length} አስደሳች ጨዋታዎች', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                    ],
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.purple.shade500, Colors.pink.shade600]),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ...grouped.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 32, height: 4, decoration: BoxDecoration(gradient: AppColors.primaryButtonGradient, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 12),
                          Text(e.key, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.grey.shade800)),
                          Expanded(child: Container(height: 4, margin: const EdgeInsets.only(left: 8), decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.green500, Colors.transparent]), borderRadius: BorderRadius.circular(2)))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.85),
                        itemCount: e.value.length,
                        itemBuilder: (context, i) {
                          final game = e.value[i];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => setState(() => _activeGame = game),
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _colorFromString(game.color).withValues(alpha: 0.95),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(game.emoji, style: const TextStyle(fontSize: 40)),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        game.name,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white, decoration: TextDecoration.none),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 8,
          left: 24,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref.read(isPlayingGameProvider.notifier).state = false;
                setState(() {
                  _selectedAge = null;
                  _games = [];
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
