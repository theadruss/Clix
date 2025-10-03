import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlack = Color(0xFF000000);
  static const Color darkGray = Color(0xFF111827);
  static const Color accentYellow = Color(0xFFFACC15);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFF374151);
  static const Color mediumGray = Color(0xFF6B7280);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkGray, primaryBlack],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [accentYellow, Color(0xFFFBBF24)],
  );
}