import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

isDarkTheme() {
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return isDarkMode;
}
