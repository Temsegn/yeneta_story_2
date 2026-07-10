import 'package:flutter/material.dart';
import 'package:kids_app/features/games/domain/entities/game_entity.dart';
import 'package:kids_app/features/games/presentation/view/games/balloon_pop_game.dart';
import 'package:kids_app/features/games/presentation/view/games/drawing_game.dart';
import 'package:kids_app/features/games/presentation/view/games/memory_game.dart';
import 'package:kids_app/features/games/presentation/view/games/math_game.dart';
import 'package:kids_app/features/games/presentation/view/games/word_match_game.dart';

class GamePlayScreen extends StatelessWidget {
  final GameEntity game;
  final VoidCallback onClose;

  const GamePlayScreen({super.key, required this.game, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _colorForGame(game.color),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(game.emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(game.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.grey.shade900)),
                Text(game.category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
              ],
            ),
          ],
        ),
      ),
      body: _buildGame(context),
    );
  }

  Color _colorForGame(String c) {
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
      default: return Colors.orange.shade500;
    }
  }

  Widget _buildGame(BuildContext context) {
    switch (game.type ?? '') {
      case 'memory-match':
        return MemoryGameWidget(onClose: onClose);
      case 'balloon-pop':
        return const BalloonPopGame();
      case 'drawing':
        return const DrawingGameWidget();
      case 'math-quiz':
        return const MathGameWidget();
      case 'word-match':
        return const WordMatchGameWidget();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⏳', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 24),
              Text('በቅርብ ቀን!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.grey.shade800)),
              const SizedBox(height: 8),
              Text('ይህ ጨዋታ በቅርቡ ይጨመራል', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
              const SizedBox(height: 32),
              TextButton(
                onPressed: onClose,
                child: const Text('ተመለስ'),
              ),
            ],
          ),
        );
    }
  }
}
