import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kids_app/core/theme/app_colors.dart';

class MathGameWidget extends StatefulWidget {
  const MathGameWidget({super.key});

  @override
  State<MathGameWidget> createState() => _MathGameWidgetState();
}

class _MathGameWidgetState extends State<MathGameWidget> {
  late _Question _question;
  int _score = 0;
  int _streak = 0;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    final random = Random();
    final a = random.nextInt(20) + 1;
    final b = random.nextInt(20) + 1;
    final ops = ['+', '-', '×'];
    final op = ops[random.nextInt(ops.length)];
    int answer;
    int finalA = a, finalB = b;
    if (op == '+') {
      answer = a + b;
    } else if (op == '-') {
      finalA = a > b ? a : b;
      finalB = a > b ? b : a;
      answer = finalA - finalB;
    } else {
      finalA = (a / 2).floor();
      finalB = (b / 2).floor();
      answer = finalA * finalB;
    }
    final options = <int>{answer};
    while (options.length < 4) {
      options.add(answer + random.nextInt(10) - 5);
    }
    setState(() {
      _question = _Question(a: finalA, b: finalB, op: op, answer: answer, options: options.toList()..shuffle());
      _feedback = null;
    });
  }

  void _answer(int val) {
    if (_feedback != null) return;
    if (val == _question.answer) {
      setState(() {
        _feedback = 'correct';
        _score += 10;
        _streak++;
      });
      Future.delayed(const Duration(milliseconds: 1000), _generate);
    } else {
      setState(() {
        _feedback = 'wrong';
        _streak = 0;
      });
      Future.delayed(const Duration(milliseconds: 1500), _generate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigo.shade100, width: 2),
                ),
                child: Text('ነጥብ: $_score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.indigo.shade600)),
              ),
              Row(
                children: List.generate(3, (i) => Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _streak > i ? AppColors.yellow400 : Colors.indigo.shade200,
                    shape: BoxShape.circle,
                  ),
                )),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_question.a} ${_question.op == '×' ? '×' : _question.op} ${_question.b} = ?',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.indigo.shade900),
                  ),
                  const SizedBox(height: 48),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
                    itemCount: 4,
                    itemBuilder: (context, i) {
                      final opt = _question.options[i];
                      final isCorrect = opt == _question.answer;
                      Color bg = Colors.white;
                      Color text = Colors.indigo.shade900;
                      if (_feedback == 'correct' && isCorrect) {
                        bg = AppColors.green500;
                        text = Colors.white;
                      } else if (_feedback == 'wrong' && isCorrect) {
                        bg = Colors.green.shade200;
                        text = Colors.green.shade700;
                      } else if (_feedback == 'wrong' && !isCorrect) {
                        bg = Colors.white;
                        text = Colors.indigo.shade900;
                      }
                      return ElevatedButton(
                        onPressed: () => _answer(opt),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bg,
                          foregroundColor: text,
                          padding: const EdgeInsets.all(24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 8,
                        ),
                        child: Text('$opt', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_feedback != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _feedback == 'correct' ? Icons.check_circle : Icons.cancel,
                    color: _feedback == 'correct' ? AppColors.green500 : Colors.red.shade500,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _feedback == 'correct' ? 'ትክክል!' : 'ተሳስተሃል!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _feedback == 'correct' ? AppColors.green500 : Colors.red.shade500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Question {
  final int a;
  final int b;
  final String op;
  final int answer;
  final List<int> options;

  _Question({required this.a, required this.b, required this.op, required this.answer, required this.options});
}
