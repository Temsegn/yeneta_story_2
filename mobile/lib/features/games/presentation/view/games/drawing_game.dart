import 'package:flutter/material.dart';
import 'package:kids_app/core/theme/app_colors.dart';

class DrawingGameWidget extends StatefulWidget {
  const DrawingGameWidget({super.key});

  @override
  State<DrawingGameWidget> createState() => _DrawingGameWidgetState();
}

class _DrawingGameWidgetState extends State<DrawingGameWidget> {
  final _points = <Offset>[];
  Color _color = AppColors.orange500;
  double _brushSize = 8;
  bool _isEraser = false;
  final _colors = [
    const Color(0xFFEF4444),
    const Color(0xFFF97316),
    const Color(0xFFEAB308),
    const Color(0xFF22C55E),
    const Color(0xFF3B82F6),
    const Color(0xFFA855F7),
    const Color(0xFFEC4899),
    Colors.black,
  ];

  void _onPanStart(DragStartDetails d) {
    setState(() => _points.add(d.localPosition));
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _points.add(d.localPosition));
  }

  void _clear() {
    setState(() => _points.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            child: SizedBox.expand(
              child: CustomPaint(
                painter: _DrawingPainter(_points, _color, _brushSize, _isEraser),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.orange200.withValues(alpha: 0.3),
            border: Border(top: BorderSide(color: AppColors.orange200, width: 2)),
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _colors.map((c) {
                    final isSelected = c == _color && !_isEraser;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _color = c;
                          _isEraser = false;
                        }),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.white, width: 4) : const Border(),
                            boxShadow: isSelected ? [BoxShadow(color: Colors.black26, blurRadius: 8)] : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _isEraser = false),
                      icon: const Icon(Icons.edit),
                      label: const Text('መፃፊያ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isEraser ? AppColors.orange500 : Colors.white,
                        foregroundColor: !_isEraser ? Colors.white : AppColors.orange600,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.orange200),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _isEraser = true),
                      icon: const Icon(Icons.cleaning_services),
                      label: const Text('ማጥፊያ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEraser ? AppColors.orange500 : Colors.white,
                        foregroundColor: _isEraser ? Colors.white : AppColors.orange600,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.orange200),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _clear,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.red.shade100),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double brushSize;
  final bool isEraser;

  _DrawingPainter(this.points, this.color, this.brushSize, this.isEraser);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isEraser ? Colors.white : color
      ..strokeWidth = isEraser ? brushSize * 3 : brushSize
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => oldDelegate.points != points || oldDelegate.color != color || oldDelegate.brushSize != brushSize || oldDelegate.isEraser != isEraser;
}
