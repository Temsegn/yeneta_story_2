import 'package:flutter/material.dart';

/// Brand palette for auth flows — matches splash & onboarding.
abstract class AuthBrand {
  static const purple = Color(0xFF6B4CE6);
  static const purpleLight = Color(0xFF9B6BFF);
  static const coral = Color(0xFFFF6B9D);
  static const orange = Color(0xFFFF9A56);
  static const gold = Color(0xFFFFD93D);
  static const ink = Color(0xFF2D3142);
  static const inkMuted = Color(0xFF6B7280);

  static const signInGradient = [Color(0xFF667EEA), Color(0xFF764BA2)];
  static const signUpGradient = [Color(0xFFFF6B9D), Color(0xFFFF9A56)];

  static const primaryButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple, purpleLight],
  );

  static const signUpButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [coral, orange],
  );
}
