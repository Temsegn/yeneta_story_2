import 'package:flutter/material.dart';

/// Design tokens matching React theme.css and component gradients.
abstract class AppColors {
  static const Color primary = Color(0xFF030213);
  static const Color background = Colors.white;
  static const Color foreground = Color(0xFF1A1A1A);
  static const Color muted = Color(0xFFECECF0);
  static const Color mutedForeground = Color(0xFF717182);
  static const Color destructive = Color(0xFFD4183D);
  static const Color border = Color(0x1A000000);
  static const double radius = 10.0; // 0.625rem

  // Ethiopian / app accents (orange, red, green, yellow)
  static const Color orange400 = Color(0xFFFB923C);
  static const Color orange500 = Color(0xFFF97316);
  static const Color red500 = Color(0xFFEF4444);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);
  static const Color yellow400 = Color(0xFFFACC15);
  static const Color orange200 = Color(0xFFFED7AA);
  static const Color orange600 = Color(0xFFEA580C);

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orange400, red500],
  );
  static const LinearGradient navGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF22C55E),
      Color(0xFFFB8C47),
      Color(0xFFEF4444),
    ],
  );
}
