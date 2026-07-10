import 'package:flutter/material.dart';
import 'package:kids_app/core/theme/app_colors.dart';

class MemoryGameWidget extends StatefulWidget {
  final VoidCallback onClose;

  const MemoryGameWidget({super.key, required this.onClose});

  @override
  State<MemoryGameWidget> createState() => _MemoryGameWidgetState();
}

class _MemoryGameWidgetState extends State<MemoryGameWidget> {
  final _emojis = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮'];
  late List<_Card> _cards;
  final List<int> _flipped = [];
  int _moves = 0;
  bool _won = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    final pairs = [..._emojis, ..._emojis]..shuffle();
    setState(() {
      _cards = List.generate(24, (i) => _Card(id: i, emoji: pairs[i], flipped: false, matched: false));
      _flipped.clear();
      _moves = 0;
      _won = false;
    });
  }

  void _flip(int id) {
    if (_flipped.length == 2 || _cards[id].flipped || _cards[id].matched) return;
    setState(() {
      _cards[id].flipped = true;
      _flipped.add(id);
      if (_flipped.length == 2) {
        _moves++;
        final [a, b] = _flipped;
        if (_cards[a].emoji == _cards[b].emoji) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _cards[a].matched = true;
                _cards[b].matched = true;
                _flipped.clear();
                if (_cards.every((c) => c.matched)) _won = true;
              });
            }
          });
        } else {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _cards[a].flipped = false;
                _cards[b].flipped = false;
                _flipped.clear();
              });
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.orange200),
                ),
                child: Text('እንቅስቃሴ: $_moves', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.orange600)),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.green600),
                onPressed: _reset,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12),
              itemCount: _cards.length,
              itemBuilder: (context, i) {
                final card = _cards[i];
                return GestureDetector(
                  onTap: () => _flip(i),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: card.flipped || card.matched
                        ? Container(
                            key: ValueKey('front-$i'),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.orange200, width: 2),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                            ),
                            child: Center(child: Text(card.emoji, style: const TextStyle(fontSize: 32))),
                          )
                        : Container(
                            key: ValueKey('back-$i'),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryButtonGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                            ),
                            child: const Center(child: Text('?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
                          ),
                  ),
                );
              },
            ),
          ),
          if (_won)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(48),
                border: Border.all(color: AppColors.yellow400, width: 4),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24)],
              ),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.yellow400,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
                    ),
                    child: const Icon(Icons.emoji_events, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 24),
                  Text('ጎበዝ!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.grey.shade900)),
                  const SizedBox(height: 8),
                  Text('ሁሉንም አግኝተሃል!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green500,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('እንደገና ተጫወት', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Card {
  final int id;
  final String emoji;
  bool flipped;
  bool matched;

  _Card({required this.id, required this.emoji, required this.flipped, required this.matched});
}
