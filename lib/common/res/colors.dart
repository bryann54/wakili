import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

isDarkTheme() {
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return isDarkMode;
}

class AppColors {
  static const Color primaryColor = Color(0xFF2A52BE);
  static const Color accentColor = Color(0xFF6B8E23);
  static const Color background = Colors.white;
  static const Color dividerColor = Color(0xFFDCDCDC);
  static const Color shadowColor = Color(0x33000000);
}
