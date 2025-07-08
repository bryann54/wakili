import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

isDarkTheme() {
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return isDarkMode;
}

class AppColors {
  // Primary Colors
  static const Color brandPrimary = Color(0xFF2A52BE);
  static const Color brandSecondary = Color(0xFF6B8E23);
  static const Color brandAccent = Color(0xFF4CC9F0);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardColor = Color.fromARGB(255, 30, 45, 60);

  static const LinearGradient primaryButtonGradient = LinearGradient(
    colors: [brandPrimary, brandSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentButtonGradient = LinearGradient(
    colors: [brandAccent, Color(0xFF4895EF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF495057);
  static const Color textLight = Color(0xFF6C757D);
  static const Color textLightDark = Color(0xFFADB5BD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPrimaryDark = Color(0xFFF8F9FA);
  static const Color textSecondaryDark = Color(0xFFE9ECEF);

  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // UI Colors
  static const Color dividerColor = Color(0xFFDCDCDC);
  static const Color shadowColor = Color(0x33000000);
  static const Color disabledColor = Color(0xFFE9ECEF);
  static const Color borderColor = Color(0xFFDEE2E6);

  // Social Colors
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color googleRed = Color(0xFFDB4437);

  // Additional Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color cardColorDark = Color(0xFF2D2D2D);
  static const Color dividerColorDark = Color(0xFF3D3D3D);
  static const Color inputBorderDark = Color(0xFF3D3D3D);
  static const Color inputFillDark = Color(0xFF2A2A2A);

  // Consistency for Split Screen Backgrounds - These are the fixed visual halves
  static const Color visualDarkBackgroundHalf =
      Color(0xFF1A1A1A); // Always the dark side of the split
  static const Color visualLightBackgroundHalf =
      Colors.white; // Always the light side of the split
}
