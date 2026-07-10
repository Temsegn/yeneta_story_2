import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids_app/core/theme/app_colors.dart';

class BalloonPopGame extends StatefulWidget {
  const BalloonPopGame({super.key});

  @override
  State<BalloonPopGame> createState() => _BalloonPopGameState();
}

class _BalloonPopGameState extends State<BalloonPopGame> {
  final List<_Balloon> _balloons = [];
  int _score = 0;
  Timer? _spawnTimer;
  Timer? _moveTimer;
  final _colors = [Colors.red.shade400, Colors.blue.shade400, Colors.green.shade400, Colors.yellow.shade400, Colors.purple.shade400, Colors.pink.shade400, Colors.orange.shade400];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) => _spawn());
    _moveTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      if (mounted) {
        setState(() {
          _balloons.removeWhere((b) => (b.y -= 1) < -20);
        });
      }
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _moveTimer?.cancel();
    super.dispose();
  }

  void _spawn() {
    if (mounted) {
      setState(() {
        _balloons.add(_Balloon(
          id: DateTime.now().millisecondsSinceEpoch,
          x: _random.nextDouble() * 80 + 10,
          y: 110,
          color: _colors[_random.nextInt(_colors.length)],
          size: _random.nextDouble() * 40 + 60,
        ));
      });
    }
  }

  void _pop(int id) {
    setState(() {
      _balloons.removeWhere((b) => b.id == id);
      _score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.orange200, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.yellow400, size: 20),
                    const SizedBox(width: 12),
                    Text('ነጥብ: $_score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.orange600)),
                  ],
                ),
              ),
            ),
          ),
          ..._balloons.map((b) => Positioned(
                left: MediaQuery.sizeOf(context).width * (b.x / 100) - (b.size / 2),
                top: MediaQuery.sizeOf(context).height * (b.y / 100) - (b.size * 1.2 / 2),
                child: GestureDetector(
                  onTap: () => _pop(b.id),
                  child: Container(
                    width: b.size,
                    height: b.size * 1.2,
                    decoration: BoxDecoration(
                      color: b.color,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(b.size / 2),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: -b.size * 0.1,
                          left: b.size * 0.4,
                          child: Transform.rotate(
                            angle: 0.785,
                            child: Container(
                              width: b.size * 0.2,
                              height: b.size * 0.2,
                              color: b.color,
                            ),
                          ),
                        ),
                        Positioned(
                          top: b.size * 0.15,
                          left: b.size * 0.25,
                          child: Container(
                            width: b.size * 0.2,
                            height: b.size * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(b.size * 0.1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          if (_score == 0 && _balloons.isEmpty)
            Center(
              child: Text('ፊኛዎቹን አፈንዳቸው! 🎈', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.grey.shade400)),
            ),
        ],
      ),
    );
  }
}

class _Balloon {
  final int id;
  double x;
  double y;
  final Color color;
  final double size;

  _Balloon({required this.id, required this.x, required this.y, required this.color, required this.size});
}
