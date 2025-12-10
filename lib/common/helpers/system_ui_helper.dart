// common/helpers/system_ui_helper.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUIHelper {
  SystemUIHelper._();

  static void configureSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }
  static SystemUiOverlayStyle getOverlayStyle(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          isLight ? Colors.white : const Color(0xFF121212),
      systemNavigationBarIconBrightness:
          isLight ? Brightness.dark : Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }

  static SystemUiOverlayStyle getOverlayStyleForColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    final isLight = luminance > 0.5;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: backgroundColor,
      systemNavigationBarIconBrightness:
          isLight ? Brightness.dark : Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }

  /// Light theme overlay style
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  /// Dark theme overlay style
  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFF121212),
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  );
}
