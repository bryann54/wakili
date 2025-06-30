import 'dart:developer';

import 'package:wakili/core/di/injector.dart';
import 'package:wakili/core/storage/storage_preference_manager.dart';
import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en'); // Default locale is English

  Locale get locale => _locale;

  void loadLocale() {
    final String langCode =
        getIt<SharedPreferencesManager>().getString(
          SharedPreferencesManager.language,
        ) ??
        'en';
    log('LangCode: $langCode');
    _locale = Locale(langCode);
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners(); // Notify listeners about the change
  }
}
