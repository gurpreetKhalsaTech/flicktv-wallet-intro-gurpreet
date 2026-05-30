import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Background & Surfaces
  static const Color background = Color(0xFF141414); // Deep dark background
  static const Color cardSurface = Color(0xFF2A2A2D); // Dark grey for cards

  // Brand Colors
  static const Color brandGreen = Color(0xFFC0E020); // The neon/lime wallet color
  static const Color buttonGreen = Color(0xFF388E3C); // The darker green for the "Add Money" button

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA0A0A0); // Grey text for subtitles

  // Confetti Colors
  static const List<Color> confettiColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
  ];
}