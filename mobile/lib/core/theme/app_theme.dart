import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get light {
    const noDecoration = TextDecoration.none;
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.background,
        onSurface: AppColors.foreground,
        error: AppColors.destructive,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: null,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radius)),
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(decoration: noDecoration),
        displayMedium: const TextStyle(decoration: noDecoration),
        displaySmall: const TextStyle(decoration: noDecoration),
        headlineLarge: const TextStyle(decoration: noDecoration),
        headlineMedium: const TextStyle(decoration: noDecoration),
        headlineSmall: const TextStyle(decoration: noDecoration),
        titleLarge: const TextStyle(decoration: noDecoration),
        titleMedium: const TextStyle(decoration: noDecoration),
        titleSmall: const TextStyle(decoration: noDecoration),
        bodyLarge: const TextStyle(decoration: noDecoration),
        bodyMedium: const TextStyle(decoration: noDecoration),
        bodySmall: const TextStyle(decoration: noDecoration),
        labelLarge: const TextStyle(decoration: noDecoration),
        labelMedium: const TextStyle(decoration: noDecoration),
        labelSmall: const TextStyle(decoration: noDecoration),
      ),
    );
  }
}
