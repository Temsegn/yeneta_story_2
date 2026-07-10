import 'package:flutter/material.dart';
import 'package:kids_app/core/theme/app_colors.dart';

class WordMatchGameWidget extends StatefulWidget {
  const WordMatchGameWidget({super.key});

  @override
  State<WordMatchGameWidget> createState() => _WordMatchGameWidgetState();
}

class _WordMatchGameWidgetState extends State<WordMatchGameWidget> {
  final _words = [
    (word: 'Apple', amharic: 'ፖም', correct: 'https://images.unsplash.com/photo-1669999207738-fcdb7103a6f3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400', wrong: 'https://images.unsplash.com/photo-1757332050958-b797a022c910?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400'),
    (word: 'Dog', amharic: 'ውሻ', correct: 'https://images.unsplash.com/photo-1649003592455-77c0efdec77e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400', wrong: 'https://images.unsplash.com/photo-1704947807029-c75381b64869?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400'),
    (word: 'Sun', amharic: 'ፀሐይ', correct: 'https://images.unsplash.com/photo-1597166226894-8d12892f31a3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400', wrong: 'https://images.unsplash.com/photo-1750662709925-f2410ae02fad?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400'),
    (word: 'Elephant', amharic: 'ዝሆን', correct: 'https://images.unsplash.com/photo-1761627064528-84b5cdc1ee3f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400', wrong: 'https://images.unsplash.com/photo-1670597878635-a9f6f4213e31?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400'),
    (word: 'Car', amharic: 'መኪና', correct: 'https://images.unsplash.com/photo-1615540953671-6d0db05fd764?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400', wrong: 'https://images.unsplash.com/photo-1765267388286-3ee6b25d3a9c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400'),
  ];
  int _currentIndex = 0;
  int _score = 0;
  String? _feedback;
  bool _won = false;
  late List<({String url, bool isCorrect})> _options;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  void _shuffle() {
    final w = _words[_currentIndex];
    _options = [
      (url: w.correct, isCorrect: true),
      (url: w.wrong, isCorrect: false),
    ]..shuffle();
    _feedback = null;
  }

  void _choose(bool isCorrect) {
    if (_feedback != null) return;
    setState(() => _feedback = isCorrect ? 'correct' : 'wrong');
    if (isCorrect) {
      _score += 20;
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          if (_currentIndex < _words.length - 1) {
            setState(() {
              _currentIndex++;
              _shuffle();
            });
          } else {
            setState(() => _won = true);
          }
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) setState(() => _feedback = null);
      });
    }
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _won = false;
      _shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(40),
          ),
          child: _buildGameContent(context),
        ),
        if (_won)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.6),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(48),
                    border: Border.all(color: AppColors.yellow400, width: 4),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      Text('ሁሉንም ቃላት አውቀሃል!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _restart,
                        icon: const Icon(Icons.refresh),
                        label: const Text('እንደገና'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGameContent(BuildContext context) {

    final w = _words[_currentIndex];
    return Column(
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.orange200, width: 2),
                ),
                child: Text('ነጥብ: $_score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.orange600)),
              ),
              Text('${_currentIndex + 1} / ${_words.length}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.orange400)),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(w.amharic, style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.amber.shade900)),
                  const SizedBox(height: 8),
                  Text(w.word.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.orange600, letterSpacing: 2)),
                  const SizedBox(height: 48),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
                    itemCount: 2,
                    itemBuilder: (context, i) {
                      final opt = _options[i];
                      Color border = Colors.white;
                      if (_feedback == 'correct' && opt.isCorrect) {
                        border = AppColors.green500;
                      } else if (_feedback == 'wrong' && !opt.isCorrect) {
                        border = Colors.red.shade500;
                      }
                      return GestureDetector(
                        onTap: () => _choose(opt.isCorrect),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: border, width: 4),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.network(opt.url, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        if (_feedback != null)
          Positioned.fill(
            child: Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: _feedback == 'correct' ? AppColors.green500 : Colors.red.shade500,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 24)],
                ),
                child: Icon(
                  _feedback == 'correct' ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
